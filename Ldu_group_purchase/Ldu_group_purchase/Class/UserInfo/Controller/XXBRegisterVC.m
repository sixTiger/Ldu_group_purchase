//
//  XXBRegisterVC.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/5/6.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBRegisterVC.h"
#import "XXBUserTools.h"
#import "NSString+Help.h"
#import "XXBUserModle.h"
#import "XXBViewShaker.h"

@interface XXBRegisterVC ()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (weak, nonatomic) IBOutlet UIView *registerBGView;
/**
 *  账号
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTF;
/**
 *  验证密码
 */
@property (weak, nonatomic) IBOutlet UITextField *userRePasswordTF;

- (IBAction)registerClick:(UIButton *)sender;


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

- (IBAction)registerClick:(UIButton *)sender
{
    if(self.userNameTF.text.length < 1)
    {
        [MBProgressHUD showError:@"没有设置账号"];
        [self.userNameTF becomeFirstResponder];
        [[[XXBViewShaker alloc] initWithViewsArray:@[self.registerBGView]] shake];
        return;
    }
    if (self.userPasswordTF.text.length < 1)
    {
        [MBProgressHUD showError:@"没有设置密码"];
        self.userPasswordTF.text = @"";
        self.userRePasswordTF.text = @"";
        [self.userPasswordTF becomeFirstResponder];
        [[[XXBViewShaker alloc] initWithViewsArray:@[self.registerBGView]] shake];
        return ;
    }
    if (![self.userPasswordTF.text isEqualToString:self.userRePasswordTF.text])
    {
        [MBProgressHUD showError:@"两次设置的密码不一样"];
        self.userPasswordTF.text = @"";
        self.userRePasswordTF.text = @"";
        [self.userPasswordTF becomeFirstResponder];
        [[[XXBViewShaker alloc] initWithViewsArray:@[self.registerBGView]] shake];
        return;
    }
    XXBUserModle *userModle = [XXBUserTools userWithUserName:self.userNameTF.text];
    if (userModle)
    {
        [MBProgressHUD showError:@"用户已存在"];
        self.userNameTF.text = @"";
        [[[XXBViewShaker alloc] initWithViewsArray:@[self.registerBGView]] shake];
        return;
    }
    userModle = [[XXBUserModle alloc] init];
    userModle.userName = self.userNameTF.text;
    userModle.userPassword = [self.userPasswordTF.text md5String];
    [XXBUserTools addUser:userModle];
    userModle = [XXBUserTools userWithUserName:self.userNameTF.text];
    [[NSUserDefaults standardUserDefaults] setObject:userModle.userID forKey:@"userID"];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
