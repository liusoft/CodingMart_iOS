//
//  Reward.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardRoleType.h"
#import "RewardWinnerInfo.h"
#import "JoinInfo.h"

@interface Reward : NSObject
//List
@property (strong, nonatomic) NSNumber *id, *type, *status, *progress, *price, *duration;
@property (strong, nonatomic) NSString *title, *format_price;
@property (strong, nonatomic) NSString *cover, *home;
@property (strong, nonatomic) NSMutableArray *roleTypes, *winners;
@property (readwrite, nonatomic, strong) NSDictionary *propertyArrayMap;
//Do Publish
@property (strong, nonatomic) NSNumber *budget, *require_clear, *need_pm;
@property (strong, nonatomic) NSString *name, *description_mine, *contact_name, *contact_email, *contact_mobile, *first_sample, *second_sample, *first_file, *second_file, *require_doc;
//Display
@property (strong, nonatomic) NSString *typeDisplay, *typeImageName, *statusDisplay, *roleTypesDisplay, *statusStrColorHexStr, *statusBGColorHexStr;

- (void)prepareToDisplay;
- (NSDictionary *)toPostParams;

+ (BOOL)saveDraft:(Reward *)curReward;
+ (BOOL)deleteCurDraft;
+ (Reward *)rewardWithId:(NSUInteger)r_id;
+ (Reward *)rewardToBePublished;
@end
