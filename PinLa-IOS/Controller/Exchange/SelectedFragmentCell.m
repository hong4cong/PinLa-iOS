//
//  FragmentViewCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SelectedFragmentCell.h"

@implementation SelectedFragmentCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iv_fragment = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 40, 40)];
        self.iv_fragment.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iv_fragment];
    }
    return self;
}

- (void)contentCellWithPieceEntity:(PieceEntity *)pieceEntity{
    [AppUtils contentImageView:_iv_fragment withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
}

- (void)contentCellWithPropertyEntity:(PropertyEntity *)propEntity{
        [AppUtils contentImageView:_iv_fragment withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
}


@end
