//
//  PropertyDetailModalPanelView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PropertyDetailModalPanelView.h"
#import "BackpackDetailView.h"
#import "PropertyEntity.h"

@interface BackpackDetailView ()<HModalPanelDelegate>


@end

@implementation PropertyDetailModalPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _detailView = [[BackpackDetailView alloc]initWithFrame:CGRectMake(20, 32, self.frame.size.width - 40, self.frame.size.height - 104)];
        _detailView.delegate = self;
        
        self.detailView.btn_turn.hidden = YES;
        self.detailView.btn_share.hidden = YES;
        [self addSubview:self.detailView];
        [self.detailView showFromPoint:[self center]];
        
    }
    
    return self;
}

- (void)contentWithPropertyEntity:(PropertyEntity*)entity
{
    [_detailView contentPropertyWithEntity:entity isShowUseBtn:NO];
}

#pragma mark - HModalPanelDelegate
- (void)didCloseModalPanel:(HModalPanel *)modalPanel
{
    [self removeFromSuperview];
}

@end
