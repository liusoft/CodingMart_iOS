//
//  SkiillRoleType.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkiillRoleType : NSObject
@property (strong, nonatomic) NSNumber *id, *selected;
@property (strong, nonatomic) NSString *code, *name, *data;
- (NSArray *)goodAtList;
@end
