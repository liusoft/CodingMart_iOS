//
//  FillTypesViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillTypesViewController.h"
#import "FillUserInfoViewController.h"
#import "FillSkillsViewController.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"
#import "IdentityAuthenticationModel.h"
#import "CodingMarkTestViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "SkillsViewController.h"

typedef NS_ENUM(NSInteger, IdentityStatusCode)
{
    identity_Unautherized=0,//未认证
    identity_Certificate=1,//认证通过
    identity_Authfaild=2,//认证失败
    identity_Authing=3//认证中
};

@interface FillTypesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userinfoCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *skillsCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *testingCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *statusCheckV;
@property (weak, nonatomic) IBOutlet UILabel *identityStatusLabel;
@property (strong, nonatomic) User *curUser;

@property (assign,nonatomic)IdentityStatusCode identityCode;
@property (strong,nonatomic)NSDictionary *identity_server_CacheDataDic;
@end

@implementation FillTypesViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillTypesViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"完善资料";
    [self getUserinfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_curUser) {
        self.curUser = [Login curLoginUser];
    }else{
        [self refresh];
    }
 
    [self refreshIdCardCheck];
}

- (void)refresh{

    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        if (data) {
            self.curUser = data;
        }
    }];
    
}

-(void)refreshIdCardCheck
{
    WEAKSELF
    [[Coding_NetAPIManager sharedManager]get_AppInfo:^(id data, NSError *error)
     {
         if (data){
             NSDictionary *dataDic =data[@"data"];
             NSInteger status=[dataDic[@"status"] integerValue];
             weakSelf.identityCode=status;
             weakSelf.identity_server_CacheDataDic=data[@"data"];
             if (weakSelf.identityCode==identity_Authfaild){
                 weakSelf.statusCheckV.hidden=YES;
                 weakSelf.identityStatusLabel.hidden=NO;
                 weakSelf.identityStatusLabel.textColor=[UIColor colorWithHexString:@"FF4B80"];
                 weakSelf.identityStatusLabel.text=@"认证失败";
             }else if(weakSelf.identityCode==identity_Authing){
                 weakSelf.statusCheckV.hidden=YES;
                 weakSelf.identityStatusLabel.hidden=NO;
                 weakSelf.identityStatusLabel.textColor=[UIColor colorWithHexString:@"F5A623"];
                 weakSelf.identityStatusLabel.text=@"认证中";
             }else{
                 weakSelf.statusCheckV.hidden=NO;
                 weakSelf.identityStatusLabel.hidden=YES;
             }
         }
     }];
}

- (void)setCurUser:(User *)curUser
{
    _curUser = curUser;
    _userinfoCheckV.image = [UIImage imageNamed:_curUser.fullInfo.boolValue? @"fill_checked": @"fill_unchecked"];
    _skillsCheckV.image = [UIImage imageNamed:_curUser.fullSkills.boolValue? @"fill_checked": @"fill_unchecked"];
    
    _testingCheckV.image = [UIImage imageNamed:_curUser.passingSurvey.boolValue? @"fill_checked": @"fill_unchecked"];
    _statusCheckV.image = [UIImage imageNamed:_curUser.identityChecked.boolValue? @"fill_checked": @"fill_unchecked"];
    
    
}

-(void)getUserinfo
{
    [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id data, NSError *error)
    {
        FillUserInfo *userInfo = data[@"data"][@"info"]? [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"][@"info"]]: [FillUserInfo new];
        if (userInfo.name)
        {
            [IdentityAuthenticationModel cacheUserName:userInfo.name];
        }
    }];
}

#pragma mark Table M

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (!self.curUser.fullInfo.boolValue) {
                [NSObject showHudTipStr:@"请先完善个人信息"];
                return;
            }
            [self.navigationController pushViewController:[SkillsViewController storyboardVC] animated:YES];
        }else if (indexPath.row == 2){
            CodingMarkTestViewController *vc = [CodingMarkTestViewController storyboardVC];
            vc.hasPassTheTesting=_curUser.passingSurvey.boolValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (!self.curUser.fullInfo.boolValue) {
            [NSObject showHudTipStr:@"请先完善个人信息"];
            return;
        }
        if (self.identityCode==identity_Authing)
        {
            [NSObject showHudTipStr:@"已提交认证，将在工作日48小时内进行审核"];
            return;
        }
        IdentityAuthenticationViewController *vc = [IdentityAuthenticationViewController storyboardVC];
        vc.identity_server_CacheDataDic=self.identity_server_CacheDataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 40;
    }
    else if(section==1)
    {
        return 20;
    }else if (section==2)
    {
        return 8;
    }else
    {
        return 1;
    }
}
@end
