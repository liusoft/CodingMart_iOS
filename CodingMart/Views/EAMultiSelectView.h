//
//  EAMultiSelectView.h
//  CodingMart
//
//  Created by Ease on 15/11/2.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCCellIdentifier_EAMultiSelectViewCCell @"EAMultiSelectViewCCell"

#import <UIKit/UIKit.h>

@interface EAMultiSelectView : UIView
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray<NSString *> *dataList;
@property (strong, nonatomic) NSMutableArray<NSString *> *selectedList;
@property (assign, nonatomic) NSUInteger maxSelectNum;

@property (copy, nonatomic) void(^confirmBlock)(NSArray<NSString *> *selectedList);
- (void)showInView:(UIView *)view;
+ (instancetype)showInView:(UIView *)view withTitle:(NSString *)title dataList:(NSArray<NSString *> *)dataList selectedList:(NSArray<NSString *> *)selectedList andConfirmBlock:(void(^)(NSArray<NSString *> *selectedList))block;
@end

@interface EAMultiSelectViewCCell : UICollectionViewCell
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL hasBeenSeleted;
@end