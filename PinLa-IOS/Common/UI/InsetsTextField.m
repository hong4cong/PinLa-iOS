//
//  InsetsTextField.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/14.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "InsetsTextField.h"

@interface InsetsTextField ()

@property(nonatomic,assign)CGFloat leftMargin;
@property(nonatomic,assign)CGFloat rightMargin;

@end

@implementation InsetsTextField


- (instancetype)initWithLeftMargin:(CGFloat)leftMargin
{
    self = [super init];
    if (self) {
        self.leftMargin = leftMargin;
        self.rightMargin = 0.0f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame leftMargin:(CGFloat)leftMargin
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftMargin = leftMargin;
        self.rightMargin = 0.0f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftMargin = leftMargin;
        self.rightMargin = rightMargin;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += self.leftMargin;
    bounds.size.width -= (self.rightMargin + 5);
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += self.leftMargin;
    bounds.size.width -= (self.rightMargin + 5);
    return bounds;
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.size.width - 25 - self.rightMargin, 0, 15, bounds.size.height);
//}

@end
