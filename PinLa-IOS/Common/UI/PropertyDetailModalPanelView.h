//
//  PropertyDetailModalPanelView.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackpackDetailView;
@class PropertyEntity;

@interface PropertyDetailModalPanelView : UIView

@property (nonatomic,strong)BackpackDetailView* detailView;

- (void)contentWithPropertyEntity:(PropertyEntity*)entity;

@end
