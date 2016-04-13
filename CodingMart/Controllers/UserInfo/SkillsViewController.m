//
//  SkillsViewController.m
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillsViewController.h"
#import "FillRoleSkillViewController.h"
#import "FillProjectSkillViewController.h"
#import "MartSkill.h"
#import "Coding_NetAPIManager.h"
#import "SkillRoleCell.h"
#import "SkillProCell.h"
#import "EASingleSelectView.h"

@interface SkillsViewController ()
@property (strong, nonatomic) IBOutlet UIView *firstSectionH;
@property (strong, nonatomic) IBOutlet UIView *secondSectionH;
@property (weak, nonatomic) IBOutlet UIButton *addRoleSBtn;
@property (weak, nonatomic) IBOutlet UIButton *addProSBtn;

@property (strong, nonatomic) MartSkill *skill;
@end

@implementation SkillsViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"SkillsViewController"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView addPullToRefreshAction:@selector(refresh) onTarget:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)setSkill:(MartSkill *)skill{
    _skill = skill;
    _addRoleSBtn.hidden = (_skill.roleList.count <= 0 || _skill.roleList.count == _skill.allRoleList.count);
    _addProSBtn.hidden = _skill.proList.count <= 0;
    [self.tableView reloadData];
}

- (void)refresh{
    if (!_skill) {
        [self.tableView beginLoading];
    }
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_SkillBlock:^(id data, NSError *error) {
        [weakSelf.tableView endLoading];
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.skill = data;
        }
    }];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _skill? 2: 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 0? _firstSectionH: _secondSectionH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 200;
    if (section == 0) {
        height = _skill.roleList.count > 0? 90: 140;
    }else{
        height = _skill.proList.count > 0? 45: 110;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0? _skill.roleList.count: _skill.proList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    if (indexPath.section == 0) {
        SkillRole *role = _skill.roleList[indexPath.row];
        SkillRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:role.role.data.length > 0? kCellIdentifier_SkillRoleCellDeveloper: kCellIdentifier_SkillRoleCell];
        cell.role = role;
        cell.editRoleBlock = ^(SkillRole *roleT){
            [weakSelf goToRole:roleT];
        };
        return cell;
    }else{
        SkillPro *pro = _skill.proList[indexPath.row];
        SkillProCell * cell = [tableView dequeueReusableCellWithIdentifier:pro.files.count > 0? kCellIdentifier_SkillProCellHasFiles: kCellIdentifier_SkillProCell];
        cell.pro = pro;
        cell.clickedFileBlock = ^(MartFile *file){
            [weakSelf goToFile:file];
        };
        cell.editProBlock = ^(SkillPro *proT){
            [weakSelf goToPro:proT];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = [SkillRoleCell cellHeightWithObj:_skill.roleList[indexPath.row]];
    }else{
        height = [SkillProCell cellHeightWithObj:_skill.proList[indexPath.row]];
    }
    return height;
}

#pragma mark - ib_action

- (IBAction)addRoleBtnClicked:(id)sender {
    WEAKSELF;
    NSArray *dataList = [[_skill.allRoleList valueForKey:@"role"] valueForKey:@"name"];
    NSArray *disableList = [[_skill.roleList valueForKey:@"role"] valueForKey:@"name"];
    [EASingleSelectView showInView:self.view withTitle:@"选择角色" dataList:dataList disableList:disableList andConfirmBlock:^(NSString *selectedStr) {
        for (SkillRole *role in weakSelf.skill.unselectedRoleList) {
            if ([role.role.name isEqualToString:selectedStr]) {
                [weakSelf goToRole:role];
                return ;
            }
        }
        [NSObject showHudTipStr:@"暂时不能添加该角色"];
    }];
}

- (IBAction)addProBtnClicked:(id)sender {
    [self goToPro:nil];
}

#pragma vc
- (void)goToFile:(MartFile *)file{
    [self goToWebVCWithUrlStr:file.url title:file.filename];
}

- (void)goToRole:(SkillRole *)role{
    FillRoleSkillViewController *vc = [FillRoleSkillViewController storyboardVC];
    vc.role = role;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToPro:(SkillPro *)pro{
    FillProjectSkillViewController *vc = [FillProjectSkillViewController storyboardVC];
    vc.pro = pro;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
