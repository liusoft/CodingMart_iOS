//
//  SegmentControl.h
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

/**
 *  左右切换的pageControl
 *
 *  效果为X易的效果
 */

#import <UIKit/UIKit.h>

typedef void(^XTSegmentControlBlock)(NSInteger index);

@interface XTSegmentControl : UIView
@property (strong, nonatomic) UIColor *defaultTextColor;
@property (assign, nonatomic) BOOL lineHiden;
@property (assign, nonatomic) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItems selectedBlock:(XTSegmentControlBlock)selectedHandle;

- (void)selectIndex:(NSInteger)index;

- (void)moveIndexWithProgress:(float)progress;

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;

@end
