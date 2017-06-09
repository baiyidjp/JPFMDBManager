//
//  DHSQLiteManager.m
//  iPadShow
//
//  Created by Keep丶Dream on 2017/5/10.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "JPFMDBManager.h"
#import "FMDB.h"

/** dataBase */
static FMDatabaseQueue *databaseQueue;

@interface JPFMDBManager ()

@end

@implementation JPFMDBManager

+ (instancetype)sharedManager {
    
    static JPFMDBManager *dhManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dhManager == nil) {
            dhManager = [[JPFMDBManager alloc] init];
            NSString *dbPathName = @"JPFMDBManager.db";
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *dbPath = [path stringByAppendingPathComponent:dbPathName];
            
            //使用 FMDatabaseQueue  保证线程安全
            databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        }
    });
    
    return dhManager;
}

#pragma mark -创建数据表
- (void)jp_CreatTableWithSql:(NSString *)sql {
    
    
    //MARK: --FMDB的内部队列是 串行队列 同步执行
    //可以保证同一时间 只有一个任务在操作数据库 从而保证数据库的读写安全
    [databaseQueue inDatabase:^(FMDatabase *db) {

        //只有在创表的使用执行多条语句 可以一次创建多个数据表
        //在执行增删改的时候 一定不能使用 statments 方法 否则可能会被注入
        BOOL isCreatTableSuccess = [db executeStatements:sql];
        if (isCreatTableSuccess) {
            NSLog(@"创建表成功");
        }else {
            NSLog(@"创建表失败");
        }
    }];
    
}

#pragma mark -插入数据
- (void)jp_InsertDataWithTableName:(NSString *)tableName Array:(NSArray *)dataArray {
    

    NSDictionary *dict = dataArray[0];
    NSArray *keys = [dict allKeys];
    if (keys.count == 0) {
        return;
    }
    
    //拼接字符串  标准格式  后面可以使用数组传入(经验证使用字符串无法插入)
    //@"INSERT INTO authors (X, X, X, X) VALUES (?, ?, ?, ?)", @(X), X, X, X
    
    NSString *keyStr = keys[0];
    NSString *unknowStr = @"?";
    for (NSInteger i = 1; i < keys.count; i++) {
        
        keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@",%@",keys[i]]];
        unknowStr = [unknowStr stringByAppendingString:@",?"];
    
    }
    
    //保存当前表格的所有key值 以便查询使用
    [[NSUserDefaults standardUserDefaults] setObject:[dict allKeys] forKey:tableName];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)",tableName,keyStr,unknowStr];
    
    //执行SQL -- 开启事物
    //事务的目的是保证数据的有效性  一旦失败可以回滚
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSLog(@"dizhi---  %@",db.databasePath);
        for (NSDictionary *dataDict in dataArray) {
            
            //拼接 value 数组
            NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:[dataDict allKeys].count];
            for (NSString *key in [dataDict allKeys]) {
                [valueArr addObject:[dataDict objectForKey:key]];
            }
            //将 value 另外从一个数组传入
            BOOL isInsertSuccess = [db executeUpdate:insertSql withArgumentsInArray:valueArr];
            if (isInsertSuccess) {
                NSLog(@"插入数据成功 %@",tableName);
            }else {
                NSLog(@"插入数据失败 %@",tableName);
                NSLog(@"error = %@", [db lastErrorMessage]);
                //回滚
                *rollback = YES;
                continue ;
            }
        }
    }];
}

#pragma mark -查询数据表
- (NSArray *)jp_SelectDataWithTableName:(NSString *)tableName WhereStr:(NSString *)where{
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    if (where.length) {
        selectSql = [selectSql stringByAppendingString:where];
    }
    NSMutableArray *selectDataArray = [NSMutableArray array];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
       
        FMResultSet *resultSet = [db executeQuery:selectSql];
        
        //取出以保存的keys
        NSArray *keys = [[NSUserDefaults standardUserDefaults] objectForKey:tableName];
        
        while ([resultSet next]) {
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:keys.count];
            
            for (NSString *key in keys) {

                [dictM setObject:[resultSet stringForColumn:key] forKey:key];
            }
            
            [selectDataArray addObject:dictM];
        }
        
    }];
    return [selectDataArray copy];
}

#pragma mark -删除数据
- (void)jp_DeleteDataWithTableName:(NSString *)tableName WhereStr:(NSString *)where{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    if (where.length) {
        sql = [sql stringByAppendingString:where];
    }
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isDeleteSuccess = [db executeUpdate:sql];
        if (isDeleteSuccess) {
            NSLog(@"删除数据成功 %@",tableName);
        }else {
            NSLog(@"删除数据失败 %@",tableName);
            NSLog(@"%@",db.lastErrorMessage);
        }
        
    }];
}


@end
