//
//  PieceDetailModalPanelView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PieceDetailModalPanelView.h"
#import "BackpackDetailView.h"
#import "FragmentDetailView.h"

@interface PieceDetailModalPanelView ()<HModalPanelDelegate>
{
    bool displayingPrimary;
}

@property (nonatomic,strong) BackpackDetailView     *detailView;
@property (nonatomic,strong) FragmentDetailView     *fragmentDetail;

@end

@implementation PieceDetailModalPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    displayingPrimary = YES;
    UIView* bgModalPanel = [[UIView alloc]initWithFrame:CGRectMake(20, 32, self.frame.size.width - 40, self.frame.size.height - 104)];
    [self addSubview:bgModalPanel];
    
    _detailView = [[BackpackDetailView alloc]initWithFrame:bgModalPanel.bounds];
    _detailView.delegate = self;
    [self.detailView.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgModalPanel addSubview:self.detailView];
    [self.detailView showFromPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    
    
    _fragmentDetail = [[FragmentDetailView alloc]initWithFrame:bgModalPanel.bounds];
    _fragmentDetail.delegate = self;
    [self.fragmentDetail.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];    
}

- (void)turnAction:(id)sender {
    
    [UIView transitionFromView:(displayingPrimary ? self.detailView : self.fragmentDetail)
                        toView:(displayingPrimary ? self.fragmentDetail : self.detailView)
                      duration: 0.6
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            displayingPrimary = !displayingPrimary;
                        }
                    }
     ];
}

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity
{
    [_detailView contentWithPieceNumberingEntity:entity];
    [_fragmentDetail contentWithPieceNumberingEntity:entity];
    
}

#pragma mark - HModalPanelDelegate
- (void)didCloseModalPanel:(HModalPanel *)modalPanel
{
    [self removeFromSuperview];
}

@end
