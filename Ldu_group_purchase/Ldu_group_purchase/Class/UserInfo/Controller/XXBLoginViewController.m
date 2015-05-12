//
//  XXBLoginViewController.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/4/18.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBLoginViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XXBViewShaker.h"
#import "XXBRegisterVC.h"

#import "XXBUserTools.h"
#import "XXBUserModle.h"
#import "NSString+Help.h"
#import "XXBChangeUserInfoView.h"

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
 *  更改用户信息
 */
@property (nonatomic, strong) UIBarButtonItem *rightItem;
/**
 *  退出按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
/**
 *  注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

/**
 *  用户信息更改的窗口
 */
@property(nonatomic , weak)XXBChangeUserInfoView *chageUserInfoView;

/**
 *  登录点击
 */
- (IBAction)loginClick:(id)sender;
- (IBAction)registerClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *logbgView;

- (IBAction)logoutClick:(UIButton *)sender;

@end

@implementation XXBLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLoginView];
    [self addKeyboardNote];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)setupLoginView
{
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    [self setLoginViewController];
    self.iconButton.layer.cornerRadius = self.iconButton.width * 0.5;
    self.iconButton.clipsToBounds = YES;
    self.chageUserInfoView.edit = self.chageUserInfoView.edit;
    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (userID.intValue > 0)
    {
        self.chageUserInfoView.hidden = NO;
        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.logoutButton.hidden = NO;
        self.registerButton.hidden = YES;
    }
    else
    {
        self.chageUserInfoView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        self.logoutButton.hidden = YES;
        self.registerButton.hidden = NO;
    }
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
- (XXBChangeUserInfoView *)chageUserInfoView
{
    if (_chageUserInfoView == nil)
    {
        XXBChangeUserInfoView *chageUserInfoView = [[XXBChangeUserInfoView alloc] initWithFrame: self.logbgView.bounds];
        [self.logbgView addSubview:chageUserInfoView];
        _chageUserInfoView = chageUserInfoView;
    }
    return _chageUserInfoView;
}
- (UIBarButtonItem *)rightItem
{
    if (_rightItem == nil)
    {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    }
    return _rightItem;
}
- (void)editClick
{
    if([self.rightItem.title isEqualToString:@"编辑"])
    {
        self.chageUserInfoView.edit = YES;
        self.rightItem.title = @"保存";
    }
    else
    {
        self.chageUserInfoView.edit = NO;
        if (self.chageUserInfoView.edit )
            return;
        [self.view endEditing:YES];
        self.rightItem.title = @"编辑";
    }
}
- (UIBarButtonItem *)backItem
{
    if (_backItem == nil)
    {
        _backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}
- (IBAction)loginClick:(id)sender {
    [self saveButtonStates];
    __weak typeof(self) weakSelf = self;
    XXBUserModle *userModle = [XXBUserTools userWithUserName:self.userName.text];
    if (userModle == nil)
    {
        [MBProgressHUD showError:@"没有用户" toView:self.view];
        [[[XXBViewShaker alloc] initWithViewsArray:@[weakSelf.userName,weakSelf.userNameIcon,weakSelf.userNameBG,weakSelf.userPassword,weakSelf.userPasswordIcon,weakSelf.userPasswordBG]] shake];
    }
    else
    {
        if([userModle.userPassword isEqualToString:self.userPassword.text.md5String])
        {
            [[NSUserDefaults standardUserDefaults] setObject:userModle.userID forKey:@"userID"];
            [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
            [self setupLoginView];
        }
        else
        {
            [MBProgressHUD showSuccess:@"登录失败" toView:self.view];
            [[[XXBViewShaker alloc] initWithViewsArray:@[weakSelf.userName,weakSelf.userNameIcon,weakSelf.userNameBG,weakSelf.userPassword,weakSelf.userPasswordIcon,weakSelf.userPasswordBG]] shake];
        }
      
    }
}

- (IBAction)registerClick:(UIButton *)sender
{
    XXBRegisterVC *reisterVC = [[XXBRegisterVC alloc] init];
    [self.navigationController pushViewController:reisterVC animated:YES];
}

- (IBAction)logoutClick:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"userID"];
    [self setupLoginView];
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
        
        self.logbgView.transform = CGAffineTransformMakeTranslation(0,  -200);
    }];
    
}
//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        self.logbgView.transform = CGAffineTransformIdentity;
    }];
}

@end
