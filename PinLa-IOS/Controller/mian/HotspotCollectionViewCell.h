//
//  HotspotCollectionViewCell.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface HotspotCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property(nonatomic,strong)UIImageView *imgView;

- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

- (void)contentDataWithEntity:(UserEntity*)entity;

@end
