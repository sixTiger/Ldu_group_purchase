//
//  XXBChangeUserInfoView.m
//  Ldu_group_purchase
//
//  Created by 杨小兵 on 15/5/10.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBChangeUserInfoView.h"
#import "XXBUserModle.h"
#import "XXBUserTools.h"
#import "NSString+Help.h"

@interface XXBChangeUserInfoView ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *userPasswordIM;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTF;
@property (weak, nonatomic) IBOutlet UIImageView *userPasswordBG;
@property (weak, nonatomic) IBOutlet UIImageView *userRePasswordIM;
@property (weak, nonatomic) IBOutlet UITextField *userRePasswordTF;
@property (weak, nonatomic) IBOutlet UIImageView *userREPasswordBG;

@end
@implementation XXBChangeUserInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XXBChangeUserInfoView" owner:nil options:nil] lastObject];
        self.frame = frame;
        [self setEdit:NO];
    }
    return self;
}
- (void)setupChangeUserInfoView
{
    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    XXBUserModle *userModle = [XXBUserTools userWithUserID:userID];
    self.userNameTF.text = userModle.userName;
}
- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    [self setupChangeUserInfoView];
    self.userPasswordTF.text = @"";
    self.userRePasswordTF.text = @"";
    self.userNameTF.userInteractionEnabled = edit;
    if(_edit)
    {
        
    }
    else
    {
        if ([self.userPasswordTF.text isEqualToString:self.userRePasswordTF.text] )
        {
            XXBUserModle *userModle;
            if (self.userPasswordTF.text.length > 0)
            {
                /**
                 *  更改账户和密码
                 */
                userModle = [[XXBUserModle alloc] init];
                userModle.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
                userModle.userName = self.userNameTF.text;
                userModle.userPassword = self.userPasswordTF.text.md5String;
                
                [XXBUserTools updateUserWithUserModle:userModle];
            }
            else
            {
                userModle = [XXBUserTools userWithUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
                if ([userModle.userName isEqualToString:self.userNameTF.text] || self.userNameTF.text.length < 1)
                {
                }
                else
                {
                    
                    userModle.userName = self.userNameTF.text;
                    
                    [XXBUserTools updateUserWithUserModle:userModle];
                }
            }
        }
        else
        {
            [MBProgressHUD showError:@"两次密码不一样"];
            _edit = YES;
            return;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.userPasswordTF.hidden = !edit;
        self.userPasswordBG.hidden = !edit;
        self.userPasswordIM.hidden = !edit;
        self.userRePasswordTF.hidden = !edit;
        self.userREPasswordBG.hidden = !edit;
        self.userRePasswordIM.hidden = !edit;
    }];
}

@end
