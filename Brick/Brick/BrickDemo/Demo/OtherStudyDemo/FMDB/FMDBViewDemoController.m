//
//  FMDBViewDemoController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/30.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "FMDBViewDemoController.h"
#import <FMDB/FMDB.h>

@interface FMDBViewDemoController ()
@property (nonatomic, strong) FMDatabase *dbBase;

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation FMDBViewDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *dbName = @"testDb";
    
    NSString *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *fullPath = [dbPath stringByAppendingPathComponent:dbName];
    
    NSString *sql = @"";
    
    self.dbBase = [FMDatabase databaseWithPath:fullPath];
    [self.dbBase executeUpdate:sql values:nil error:nil];
    
    //一般用dataBaseQueue操作sql, 其单独再一个队列中执行sql, 保证线程安全, 一般一个线程对应一个dataBaseQueue
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:fullPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql values:nil error:nil];
    }];
}

- (void)sqlStudy
{
    //DDL-数据定义语言:CREATE(创建) ALTER(修改) DROP(删除)
    
    //DML-数据操作语言:INSERT(插入) UPDATE(更新) DELETE(删除)
    
    //DSL-数据查询语言:SELECT(检索)
    
    NSString *sqlCreateTable = @"create table if not exists \'class\' ()";
}


@end
