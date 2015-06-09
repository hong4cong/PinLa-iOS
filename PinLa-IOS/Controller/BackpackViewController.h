//
//  BackpackViewController.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, BackpackType) {
    BackpackType_piece = 0,
    BackpackType_prop,
    BackpackType_card,
};

@interface BackpackViewController : BaseViewController

@property(nonatomic,assign)id<RENavigationDelegate> delegate;

- (void)requestBackpack;

@end
