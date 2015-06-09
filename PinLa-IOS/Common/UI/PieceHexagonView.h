//
//  PieceHexagonView.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HexagonView.h"
#import "PieceNumberingEntity.h"

@interface HazyLayerView : UIView

@property(nonatomic,assign)CGPoint centerPoint;
@property(nonatomic,assign)int r;

- (void)setPieceBranchList:(NSArray*)arr_list;
- (void)setPieceNumberingEntity:(PieceNumberingEntity*)entity;

@end

@interface PieceHexagonView : UIImageView

@property(nonatomic,assign)CGPoint centerPoint;
@property(nonatomic,assign)int r;

@property(nonatomic,strong)HazyLayerView* hazyLayerView;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image;

- (instancetype)initWithFrame:(CGRect)frame;

- (CAShapeLayer*)layer;

@end
