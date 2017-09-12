//
//  DHSQLiteManager.h
//  iPadShow
//
//  Created by Keep丶Dream on 2017/5/10.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPFMDBManager : NSObject

/**
 单例 用来调用所用方法

 @return 唯一的实例对象
 */
+ (instancetype)sharedManager;

/**
 创建表

 @param sql sql语句 可以同时创建多个表
 */
- (void)jp_CreatTableWithSql:(NSString *)sql;

/**
 插入数据

 @param tableName 要插入的数据表
 @param dataArray 插入的数据集合 字典数组类型 @[@{},@{}] 可以自己根据扩展 模型数组
 */
- (void)jp_InsertDataWithTableName:(NSString *)tableName
                             Array:(NSArray *)dataArray;

/**
 查询表中所有数据

 @param tableName 要查询的表名
 @param where 条件制定key查询 可穿nil 为查询表中所有数据 (用来拼接Sql语句)  @" WHERE id2 = '21' "
 @return 返回查询的数据
 */
- (NSArray *)jp_SelectDataWithTableName:(NSString *)tableName
                               WhereStr:(NSString *)where;

/**
 删除表中数据

 @param tableName 表名
 @param where 条件 可穿nil 为删除表中所有数据 (用来拼接Sql语句)
 */
- (void)jp_DeleteDataWithTableName:(NSString *)tableName
                          WhereStr:(NSString *)where;


/**
 删除表

 @param tableName 表名
 */
- (void)jp_DeleteTableWithTableName:(NSString *)tableName;

@end
