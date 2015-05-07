//
//  XXBRegisterVC.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/5/6.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBRegisterVC.h"

@interface XXBRegisterVC ()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (weak, nonatomic) IBOutlet UIView *registerBGView;

@end

@implementation XXBRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKeyboardNote];
    self.iconButton.layer.cornerRadius = self.iconButton.width * 0.5;
    self.iconButton.clipsToBounds = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark -处理键盘
- (void)addKeyboardNote
{
    //获取通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //键盘要弹出
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘要消失
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘弹出
- (void)keyboardWillShow:(NSNotification *)note
{
    //动画调整
    [UIView animateWithDuration:0.25 animations:^{
        
        self.registerBGView.transform = CGAffineTransformMakeTranslation(0,  -200);
    }];
    
}
//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        self.registerBGView.transform = CGAffineTransformIdentity;
    }];
}
@end
