//
//  ViewController.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/12.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RENavigationController.h"

@interface MainViewController : BaseViewController

@property(nonatomic,assign)id<RENavigationDelegate> delegate;

@end

