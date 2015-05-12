//
//  XXBUserTools.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/5/10.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBUserTools.h"
#import "FMDB.h"
#import "XXBUserModle.h"

@implementation XXBUserTools
static FMDatabaseQueue *_queue;
+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_UserInfo (id integer primary key autoincrement, userName text, userPassword text );"];
        [db close];
    }];
    [_queue close];
}

+ (void)addUser:(XXBUserModle *)user
{
    [self setup];
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1.获得需要存储的数据
        NSString *userName = user.userName;
        NSString *userPassword = user.userPassword;
        //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        
        // 2.存储数据
        [db executeUpdate:@"insert into t_UserInfo (userName, userPassword) values(?, ?)", userName, userPassword];
        
        [db close];
    }];
    [_queue close];
}

/**
 *  根据用户的昵称返回用户的模型
 *
 *  @param userName 用户的昵称
 *
 *  @return 返回的用户的模型
 */
+ (XXBUserModle *)userWithUserName:(NSString *)userName
{
    [self setup];
    
    // 1.定义数组
    __block XXBUserModle *userModle = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_UserInfo where userName = ? ;", userName];
        while (rs.next)
        {
            // 创建模型
            userModle = [[XXBUserModle alloc] init];
            NSString *userPassword = [rs stringForColumn:@"userPassword"];
            userModle.userName = userName;
            userModle.userPassword = userPassword;
            userModle.userID = [rs objectForColumnName:@"id"];
            break;
        }
        [db close];
        [rs close];
    }];
    [_queue close];
    // 3.返回数据
    return userModle;
}

/**
 *  根据用户的uid查找用户
 */
+ (XXBUserModle *)userWithUserID:(NSNumber *)userID
{
    [self setup];
    __block XXBUserModle *userModle = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs =[db executeQuery:@"select * from t_UserInfo where id = ? ;",userID];
        while (rs.next)
        {
            // 创建模型
            userModle = [[XXBUserModle alloc] init];
            userModle.userName = [rs stringForColumn:@"userName"];
            userModle.userPassword = [rs stringForColumn:@"userPassword"];
            
            userModle.userID = [rs objectForColumnName:@"id"];
            break;
        }
        [rs close];
        [db close];
    }];
    [_queue close];
    // 3.返回数据
    return userModle;
}


/**
 *  更新用户的信息
 */
+ (void)updateUserWithUserModle:(XXBUserModle *)userModle
{
    [self setup];
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
       BOOL chage = [db executeUpdate:@"update t_UserInfo set userName = ? ,userPassword = ? where id = ? ;",userModle.userName,userModle.userPassword,userModle.userID];
        if (chage)
        {
            [MBProgressHUD showSuccess:@"更新成功"];
        }
        else
        {
            [MBProgressHUD showError:@"跟新失败"];
        }
    }];
    [_queue close];
    
}
+ (NSArray *)users
{
    __block NSMutableArray *array = [NSMutableArray array];
    [self setup];
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_UserInfo ;"];
        while (rs.next)
        {
            
            // 创建模型
            XXBUserModle *userModle = [[XXBUserModle alloc] init];
            NSString *userName = [rs stringForColumn:@"userName"];
            userModle.userName = userName;
            NSString *userPassword = [rs stringForColumn:@"userPassword"];
            userModle.userPassword = userPassword;
            userModle.userID = [rs objectForColumnName:@"id"];
            [array addObject:userModle];
        }
        [rs close];
    }];
    [_queue close];
    
    return array;
}
@end
