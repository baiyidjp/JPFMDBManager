//
//  ViewController.m
//  Sqlite
//
//  Created by Keep丶Dream on 2017/5/11.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "ViewController.h"
#import "JPFMDBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)creatTable:(id)sender {
    
    [[JPFMDBManager sharedManager] jp_CreatTableWithSql:@"CREATE TABLE IF NOT EXISTS T_DataTable1 (id1 INTEGER PRIMARY KEY AUTOINCREMENT, name1 TEXT NOT NULL, age1 INTEGER NOT NULL);" "CREATE TABLE IF NOT EXISTS T_DataTable2 (id2 INTEGER PRIMARY KEY AUTOINCREMENT, age2 INTEGER NOT NULL);"];
}
- (IBAction)insertData:(id)sender {
    
    NSInteger num = arc4random_uniform(100);
    NSString *str = [NSString stringWithFormat:@"%zd",num];
    NSString *str1 = [NSString stringWithFormat:@"%zd",num+1];
    NSString *str2 = [NSString stringWithFormat:@"%zd",num+2];
    
    NSArray *data1 = @[@{@"id1":str,@"name1":@"one",@"age1":str},
                       @{@"id1":str1,@"name1":@"one",@"age1":str1},
                       @{@"id1":str2,@"name1":@"one",@"age1":str2}];
    
    [[JPFMDBManager sharedManager] jp_InsertDataWithTableName:@"T_DataTable1" Array:data1];
    
    NSArray *data2 = @[@{@"id2":str,@"age2":str}];
    
    
    [[JPFMDBManager sharedManager] jp_InsertDataWithTableName:@"T_DataTable2" Array:data2];
}
- (IBAction)selectData:(id)sender {
    
    NSArray *data1 = [[JPFMDBManager sharedManager] jp_SelectDataWithTableName:@"T_DataTable1" WhereStr:nil];
    NSLog(@"表单1数据 --- %@",data1);
    NSArray *data2 = [[JPFMDBManager sharedManager] jp_SelectDataWithTableName:@"T_DataTable2" WhereStr:@" WHERE id2 = '21' "];
    NSLog(@"表单2数据 --- %@",data2);

}
- (IBAction)delectData:(id)sender {
    
    [[JPFMDBManager sharedManager] jp_DeleteDataWithTableName:@"T_DataTable1" WhereStr:@" WHERE id1 = '40' "];
    [[JPFMDBManager sharedManager] jp_DeleteDataWithTableName:@"T_DataTable2" WhereStr:@" WHERE id2 = '20' "];
}
- (IBAction)updateData:(id)sender {
    
    
}


@end
