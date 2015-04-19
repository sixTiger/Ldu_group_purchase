//
//  XXBLoginTool.h
//  2014_11_09_私人备忘录
//
//  Created by Mac10.9 on 14-11-10.
//  Copyright (c) 2014年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBUserTool : NSObject

/**
 *  判断用户名是否存在
 */
+(BOOL)userExise:(NSString *)userName;
+(void)loginWithUserName:(NSString *)userName  password:(NSString *)password  successed:(void(^)())successd  failed:(void(^)(NSString* error))fail;
+(void)registerWithUserName:(NSString *)userName  password:(NSString *)password  successed:(void(^)())successd  failed:(void(^)(NSString* error))fail;
@end
