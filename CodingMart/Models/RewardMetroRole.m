//
//  RewardMetroRole.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardMetroRole.h"

@implementation RewardMetroRole
- (NSDictionary *)propertyArrayMap{
    return @{@"stages": @"RewardMetroRoleStage"};
}

- (NSInteger)needToPayStageNum{
    NSInteger needToPayStageNum = 0;
    for (RewardMetroRoleStage *curStage in _stages) {
        if ([curStage needToPay]) {
            needToPayStageNum++;
        }
    }
    return needToPayStageNum;
}
@end
