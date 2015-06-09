//
//  BackpackDetailView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BackpackDetailView.h"
#import <UIImageView+WebCache.h>
#import "PieceHandler.h"
#import "UserStorage.h"
#import "SJAvatarBrowser.h"
#import "PieceHexagonView.h"

@interface BackpackDetailView ()

@property(nonatomic,strong)NSString* pic;
@property(nonatomic,strong)SJAvatarBrowser* browser;

@end

@implementation BackpackDetailView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

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
    _browser = [[SJAvatarBrowser alloc]init];
    CGRect contentViewFrame = self.bounds;
    self.btn_share = [[UIButton alloc]initWithFrame:CGRectMake(12, 12, 30, 28)];
    [self.btn_share setBackgroundImage:[UIImage imageNamed:@"ShareTo"] forState:UIControlStateNormal];
//    [self.contentView addSubview:self.btn_share];
    
    self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame) - 42, 10, 40, 40)];
    [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn_back];
    
    self.lb_title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btn_share.frame), 0,CGRectGetWidth(contentViewFrame) - 80, 60)];
    [self.lb_title setText:@"星巴克兑换劵"];
    [self.lb_title setTextColor:[UIColor whiteColor]];
    [self.lb_title setFont:[UIFont boldSystemFontOfSize:FONT_SIZE + 2]];
    [self.lb_title setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.lb_title];
    
    self.iv_avatar = [[PieceHexagonView alloc] initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame)/2 - 70,CGRectGetMaxY(self.lb_title.frame) + 10, 140, 165)];
    self.iv_avatar.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iv_avatar];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarInvoked:)];
    self.iv_avatar.userInteractionEnabled = YES;
    [self.iv_avatar addGestureRecognizer:gesture];
    
    self.iv_synthetic = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 15, self.iv_avatar.frame.size.height / 2 - 35/2 + self.iv_avatar.frame.origin.y, 35, 40)];
    [self.iv_synthetic setImage:[UIImage imageNamed:@"Polygon"] forState:UIControlStateNormal];
    [self.iv_synthetic addTarget:self action:@selector(syntheticAction) forControlEvents:UIControlEventTouchUpInside];
    self.iv_synthetic.hidden = YES;
    [self.contentView addSubview:self.iv_synthetic];
    
    self.tv_detail = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.iv_avatar.frame) + 20,CGRectGetMaxX(contentViewFrame) - 24, 140)];
    [self.tv_detail setBackgroundColor:[UIColor clearColor]];
    [self.tv_detail setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [self.tv_detail setTextColor:[UIColor whiteColor]];
    _tv_detail.editable = NO;
    self.tv_detail.text = @"星巴克式的体验:舒适的木质桌椅,店内播放的清雅的音乐,还有极其考究的咖啡制作器具,都能为来星巴克的顾客烘托出一种典雅、悠闲的氛围。鲜艳的绿色美人鱼标志，整幅墙面艳丽的美国时尚画、艺术品、悬挂的灯、摩登又舒适的家具，会给人以一种星巴克式的视觉体验";
    [self.contentView addSubview:self.tv_detail];
    
    self.btn_turn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentViewFrame)/2 - 30, CGRectGetHeight(contentViewFrame) - 60 - 10, 60, 60)];
    [self.btn_turn setBackgroundImage:[UIImage imageNamed:@"iconfontPolygon"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btn_turn];
    
    _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _useBtn.frame = CGRectMake(0, contentViewFrame.size.height - 45, contentViewFrame.size.width, 30);
    _useBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_useBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_useBtn setTitleColor:[UIColor colorWithHexString:COLOR_MAIN] forState:UIControlStateNormal];
    [_useBtn setTitleColor:[UIColor colorWithHexString:COLOR_TEXT_GRAY] forState:UIControlStateHighlighted];
    [_useBtn addTarget:self action:@selector(useAction) forControlEvents:UIControlEventTouchUpInside];
    _useBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _useBtn.hidden = YES;
    [self.contentView addSubview:_useBtn];
}

- (void)goBack:(id)sender{
    [self hide];
}

- (void)useAction
{
    NSString* prop = _property.prop_id;
    [PieceHandler makeCardWithUserId:[UserStorage userId] propId:prop prepare:^{
        
    } success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"使用成功"];
        [self goBack:nil];
        [_viewController requestBackpack];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString*)json];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)requestPic
{
    NSString* prop = _property.prop_id;
    
    [PieceHandler makeCardWithUserId:[UserStorage userId] propId:prop prepare:^{
        
    } success:^(id obj) {
        if (obj) {
            _pic = (NSString*)obj;
        }else{
            
        }
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

- (void)avatarInvoked:(id)sender
{
    if (_pic) {
//        [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:_pic] placeholderImage:self.iv_avatar.image];
        
        [_browser showImage:self.iv_avatar newImage:_pic];
    }
}

- (void)syntheticAction
{
    NSString* prop = _piece.prop_father_id;
    [PieceHandler makePropWithUserId:[UserStorage userId] propFatherId:prop prepare:^{
        
    } success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"合成成功，请查看道具"];
        [self goBack:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SYNTHETIC_SUCCESS object:nil];
        [_viewController requestBackpack];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

- (void)contentPieceWithEntity:(PieceEntity*)entity isCanSynthesis:(BOOL)isCanSynthesis{
    if (isCanSynthesis) {
        self.iv_synthetic.hidden = NO;
        [self.iv_synthetic setImage:[UIImage imageNamed:@"img_synthesis_props"] forState:UIControlStateNormal];
    }else{
        self.iv_synthetic.hidden = YES;
    }
    
    _piece = entity;
    
    self.lb_title.text = entity.piece_title;
    self.tv_detail.text = entity.piece_detail;
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
}

- (void)setPieceBranchList:(NSArray *)piecesBranchList
{
    [self.iv_avatar.hazyLayerView setPieceBranchList:piecesBranchList];
    
}

- (void)setPieceNumberingEntity:(PieceNumberingEntity*)entity
{
    [self.iv_avatar.hazyLayerView setPieceNumberingEntity:entity];
}

- (void)contentPropertyWithEntity:(PropertyEntity*)entity
{
    [self contentPropertyWithEntity:entity isShowUseBtn:YES];
}

- (void)contentPropertyWithEntity:(PropertyEntity*)entity isShowUseBtn:(BOOL)isShowUseBtn
{
    self.iv_synthetic.hidden = YES;
    self.btn_turn.hidden = YES;
    
    if (entity.prop_type != 4 && isShowUseBtn) {
        self.useBtn.hidden = NO;
    }
    _property = entity;
    self.lb_title.text = entity.prop_title;
    self.tv_detail.text = entity.prop_detail;
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.prop_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    
    if (entity.prop_type == 4) {
        [self requestPic];
    }
}

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity
{
    self.iv_synthetic.hidden = YES;
    [self setPieceNumberingEntity:entity];
    self.lb_title.text = entity.piece_title;
    self.tv_detail.text = entity.piece_detail;
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
}

@end
