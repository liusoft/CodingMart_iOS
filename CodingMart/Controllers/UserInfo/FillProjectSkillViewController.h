//
//  FillProjectSkillViewController.h
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SkillPro.h"

@interface FillProjectSkillViewController : BaseTableViewController
@property (strong, nonatomic) SkillPro *pro;
+ (instancetype)storyboardVC;
@end
