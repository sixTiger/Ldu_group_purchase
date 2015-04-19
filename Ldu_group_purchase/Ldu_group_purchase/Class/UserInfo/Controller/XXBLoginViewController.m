//
//  XXBLoginViewController.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/4/18.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBLoginViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XXBUserTool.h"
#import "XXBViewShaker.h"

@interface XXBLoginViewController ()
/**
 *  昵称头像
 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userName;
/**
 *  用户名的图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *userNameIcon;
/**
 *  用户名的背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *userNameBG;

/**
 *  用户密码
 */
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
/**
 *  用户密码的图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *userPasswordIcon;
/**
 *  用户密码的背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *userPasswordBG;
/**
 *  记住密码
 */
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswowrd;
/**
 *  记住密码的点击事件
 *
 */
- (IBAction)rememberPasswowrdClick:(UIButton *)sender;
/**
 *  自动登录
 */
@property (weak, nonatomic) IBOutlet UIButton *autoLogin;
/**
 *  自动登录的点击事件
 *
 */

- (IBAction)autoLoginCLick:(UIButton *)sender;


/**
 *  返回
 */
@property (nonatomic, strong) UIBarButtonItem *backItem;


/**
 *  登录点击
 */
- (IBAction)loginClick:(id)sender;
@end

@implementation XXBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    [self setLoginViewController];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
#pragma mark - 默认注册一个账号
    [XXBUserTool registerWithUserName:@"123" password:@"123" successed:^{
        
    } failed:^(NSString *error) {
        
    }];
}
#pragma mark -  事件处理

/**
 *  返回
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 懒加载
- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        self.backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}
- (IBAction)loginClick:(id)sender {
    [self saveButtonStates];
    [XXBUserTool loginWithUserName:self.userName.text password:self.userPassword.text successed:^{
        [MBProgressHUD showSuccess:@"登录成功"];
    } failed:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
        [[[XXBViewShaker alloc] initWithViewsArray:@[self.userName,self.userNameIcon,self.userNameBG,self.userPassword,self.userPasswordIcon,self.userPasswordBG]] shake];
    }];

}
/**
 设置窗口的信息
 */
- (void)setLoginViewController
{
    [self setButtonStates];
    [self setAccount];
}

/**
 保存按钮的状态
 */
- (void)saveButtonStates
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.rememberPasswowrd.selected forKey:@"rememberPasswowrdSelected"];
    [defaults setBool:self.autoLogin.selected forKey:@"autoLoginSelected"];
    [defaults synchronize];
}
/**
 设置按钮的状态
 */
- (void)setButtonStates
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rememberPasswowrd.selected = [defaults boolForKey:@"rememberPasswowrdSelected"];
    self.autoLogin.selected = [defaults boolForKey:@"autoLoginSelected"];
}
/**
 保存账号信息
 */
- (void)saveAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.rememberPasswowrd.isSelected)
    {
        [defaults setValue:self.userName.text forKey:@"userName"];
        [defaults setValue:self.userPassword.text forKey:@"userPassword"];
    }
    else
    {
        [defaults setValue:self.userName.text forKey:@"userName"];
        [defaults setValue:@"" forKey:@"userPassword"];
    }
    [defaults synchronize];
}
/**
 设置账号信息
 */
- (void)setAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName.text =  [defaults valueForKey:@"userName"];
    self.userPassword.text = [defaults valueForKey:@"userPassword"];
//    if (self.autoLoginBtn.isSelected &&!self.isLogout) {
//        [self loginClick];
//    }
}
- (IBAction)rememberPasswowrdClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(!sender.selected)
    {
        self.autoLogin.selected = NO;
    }
    [self saveButtonStates];
}
- (IBAction)autoLoginCLick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        self.rememberPasswowrd.selected = YES;
    }
    [self saveButtonStates];
}
@end