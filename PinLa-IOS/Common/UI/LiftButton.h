//
//  LiftButton.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/3/20.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "NMButton.h"

@interface LiftButton : NMButton

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
