//
//  HModalPanel.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HModalPanel.h"

#define DEFAULT_MARGIN 20
#define DEFAULT_BORDER_WIDTH		1.5f

@implementation HModalPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
//        _margin = UIEdgeInsetsMake(DEFAULT_MARGIN, DEFAULT_MARGIN, DEFAULT_MARGIN, DEFAULT_MARGIN);
//        _padding = UIEdgeInsetsMake(DEFAULT_MARGIN, DEFAULT_MARGIN, DEFAULT_MARGIN, DEFAULT_MARGIN);
        
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        self.autoresizesSubviews = YES;
        
        self.layer.masksToBounds = YES;
        
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 1.5f;
        self.layer.cornerRadius = 4;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
//        [self setBackgroundColor:[UIColor redColor]]; // Fixed value, the bacground mask.
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        self.contentView.autoresizesSubviews = YES;
        [self addSubview:_contentView];
        
//        self.delegate = nil;
        
        self.tag = (arc4random() % 32768);
        
    }
    return self;
}

- (void)show {
    
//    if ([delegate respondsToSelector:@selector(willShowModalPanel:)])
//        [delegate willShowModalPanel:self];
    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    
    void (^animationBlock)(BOOL) = ^(BOOL finished) {
        // Wait one second and then fade in the view
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(0.95, 0.95);
                         }
                         completion:^(BOOL finished){
                             
                             // Wait one second and then fade in the view
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.transform = CGAffineTransformMakeScale(1.02, 1.02);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  // Wait one second and then fade in the view
                                                  [UIView animateWithDuration:0.1
                                                                   animations:^{
                                                                       self.transform = CGAffineTransformIdentity;
                                                                   }
                                                                   completion:^(BOOL finished){
//                                                                       if ([delegate respondsToSelector:@selector(didShowModalPanel:)])
//                                                                           [delegate didShowModalPanel:self];
                                                                   }];
                                              }];
                         }];
    };
    
    // Show the view right away
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0;
                         self.center = self.center;
                         self.transform = CGAffineTransformMakeScale(1.05 , 1.05 );
                     }
                     completion:animationBlock];
    
}
- (void)showFromPoint:(CGPoint)point {
    startEndPoint = point;
//    self.contentView.center = point;
    [self show];
}

- (void)hide {
    // Hide the view right away
//    if ([delegate respondsToSelector:@selector(willCloseModalPanel:)])
//        [delegate willCloseModalPanel:self];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                         if (startEndPoint.x != CGPointZero.x || startEndPoint.y != CGPointZero.y) {
                             self.center = startEndPoint;
                         }
                         self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                     }
                     completion:^(BOOL finished){
                         if ([_delegate respondsToSelector:@selector(didCloseModalPanel:)]) {
                             [_delegate didCloseModalPanel:self];
                         }
                         [self.superview removeFromSuperview];
                     }];
}

@end
