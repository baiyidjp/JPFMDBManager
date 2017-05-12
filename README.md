# JPFMDBManager
- 支持创建表 / 插入数据 / 查询数据 / 删除数据 的操作
- 调用需要拖入文件夹 DBHandle 至自己项目中

```
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
@return 返回查询的数据
*/
- (NSArray *)jp_SelectDataWithTableName:(NSString *)tableName;

/**
删除表中数据

@param tableName 表名
@param where 条件 可穿nil 为删除表中所有数据 (用来拼接Sql语句)
*/
- (void)jp_DeleteDataWithTableName:(NSString *)tableName
WhereStr:(NSString *)where;

```
- 引用

```
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

NSArray *data1 = [[JPFMDBManager sharedManager] jp_SelectDataWithTableName:@"T_DataTable1"];
NSLog(@"表单1数据 --- %@",data1);
NSArray *data2 = [[JPFMDBManager sharedManager] jp_SelectDataWithTableName:@"T_DataTable2"];
NSLog(@"表单2数据 --- %@",data2);

}
- (IBAction)delectData:(id)sender {

[[JPFMDBManager sharedManager] jp_DeleteDataWithTableName:@"T_DataTable1" WhereStr:@" WHERE id1 = '40' "];
[[JPFMDBManager sharedManager] jp_DeleteDataWithTableName:@"T_DataTable2" WhereStr:@" WHERE id2 = '20' "];
}


```
