//
//  XXBUserTools.h
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/5/10.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXBUserModle;

@interface XXBUserTools : NSObject
/**
 *  向数据库里边存储一个用户
 *
 *  @param user 要存储的用户的模型
 */
+ (void)addUser:(XXBUserModle *)user;
/**
 *  根据用户的昵称返回用户的模型
 *
 *  @param userName 用户的昵称
 *
 *  @return 返回的用户的模型
 */
+ (XXBUserModle *)userWithUserName:(NSString *)userName;
/**
 *  根据用户的uid查找用户
 */
+ (XXBUserModle *)userWithUserID:(NSNumber *)userID;
/**
 *  更新用户的信息
 */
+ (void)updateUserWithUserModle:(XXBUserModle *)userModle;
+ (NSArray *)users;
@end
