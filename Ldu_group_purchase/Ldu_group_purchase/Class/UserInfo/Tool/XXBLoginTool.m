//
//  XXBLoginTool.m
//  2014_11_09_私人备忘录
//
//  Created by Mac10.9 on 14-11-10.
//  Copyright (c) 2014年 xiaoxiaobing. All rights reserved.
//

#import "XXBUserTool.h"

@implementation XXBUserTool

+(BOOL)userExise:(NSString *)userName
{
    
    return [self getUserPassward:userName];
}
+(void)loginWithUserName:(NSString *)userName  password:(NSString *)password  successed:(void(^)())successd  failed:(void(^)(NSString* error))fail
{
    NSString *userPassword = [self getUserPassward:userName];
    if ([userPassword isEqualToString:password])
    {
        successd();
    }
    else
    {
        if (userPassword)
        {
            fail(@"用户不存在");
        }
        else
        {
            fail(@"用户或者密码错误");
        }
        
    }
    
}
+(void)registerWithUserName:(NSString *)userName  password:(NSString *)password  successed:(void(^)())successd  failed:(void(^)(NSString* error))fail
{
    if ([self getUserPassward:userName])
    {
        fail(@"用户已存在");
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:password forKey:userName];
        [defaults synchronize];
        successd();
    }
}
+ (NSString *)getUserPassward:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:userName];
}
@end
