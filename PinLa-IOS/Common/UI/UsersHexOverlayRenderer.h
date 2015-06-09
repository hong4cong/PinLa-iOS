//
//  HotspotHexOverlayRenderer.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/30.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HexagonOverlayRenderer.h"

@interface UsersHexOverlayRenderer : HexagonOverlayRenderer

@property(nonatomic)CGPoint minicenterPoint;

@property(nonatomic)CGPoint firstPoint;

@property(nonatomic,strong)UIFont* scaleFont;

@property(nonatomic,strong)NSString* text;

@end
