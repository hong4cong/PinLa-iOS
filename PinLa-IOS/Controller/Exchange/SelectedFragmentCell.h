//
//  FragmentViewCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieceEntity.h"
#import "PropertyEntity.h"

@interface SelectedFragmentCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView       *iv_fragment;

- (void)contentCellWithPieceEntity:(PieceEntity *)pieceEntity;
- (void)contentCellWithPropertyEntity:(PropertyEntity *)propEntity;


@end
