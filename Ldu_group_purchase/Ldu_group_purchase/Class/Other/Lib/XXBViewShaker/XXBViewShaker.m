//
//  XXBViewShaker
//  XXBViewShaker
//
//  Created by Philip Vasilchenko on 03.12.13.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "XXBViewShaker.h"

static NSTimeInterval const XXBShakeTime  = 0.25;
static NSString * const XXBViewShakerAnimationKey = @"XXBViewShakerAnimationKey";


@interface XXBViewShaker ()
@property (nonatomic, strong) NSArray * views;
@property (nonatomic, assign) NSUInteger completedAnimations;
@property (nonatomic, copy) void (^completionBlock)();
@end


@implementation XXBViewShaker

- (instancetype)initWithView:(UIView *)view {
    return [self initWithViewsArray:@[ view ]];
}


- (instancetype)initWithViewsArray:(NSArray *)viewsArray {
    self = [super init];
    if ( self ) {
        self.views = viewsArray;
    }
    return self;
}


#pragma mark - Public methods

- (void)shake {
    [self shakeWithDuration:XXBShakeTime  completion:nil];
}


- (void)shakeWithDuration:(NSTimeInterval)duration completion:(void (^)())completion {
    self.completionBlock = completion;
    for (UIView * view in self.views) {
        [self addShakeAnimationForView:view withDuration:duration];
    }
}


#pragma mark - Shake Animation

- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    
    animation.delegate = self;
    animation.duration = duration;
    animation.repeatCount = 2;
    animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:XXBViewShakerAnimationKey];
}


#pragma mark - CAAnimation Delegate 重写系统的方法 当动画及结束的时候执行block
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    self.completedAnimations += 1;
    if ( self.completedAnimations >= self.views.count ) {
        self.completedAnimations = 0;
        if ( self.completionBlock ) {
            self.completionBlock();
        }
    }
}


@end
