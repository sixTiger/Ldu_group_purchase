//
//  XXBAPITool.h
//  Ldu_group_purchase
//
//  Created by Jinhong on 15-1-13.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBSingleton.h"

@interface XXBAPITool : NSObject

- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

XXBSingletonH(APITool)

@end
