//  道具Cell
//  PropertyCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyEntity.h"

@interface PropertyCell : UITableViewCell

- (void)contentWithPropertyEntity:(PropertyEntity *)propertyEntity;

@end
