//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Awesome)
static char overlayKey;
static char emptyImageKey;
static char lineKey;
static char lineIsShowKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyImage
{
    return objc_getAssociatedObject(self, &emptyImageKey);
}

- (void)setEmptyImage:(UIImage *)image
{
    objc_setAssociatedObject(self, &emptyImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lineView
{
    return objc_getAssociatedObject(self, &lineKey);
}

- (void)setLineView:(UIView *)lineView
{
    objc_setAssociatedObject(self, &lineKey, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowLine
{
    return [objc_getAssociatedObject(self, &lineIsShowKey) boolValue];
}

- (void)setIsShowLine:(BOOL)isShowLine
{
    objc_setAssociatedObject(self, &lineIsShowKey, [NSNumber numberWithBool:isShowLine], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.overlay.frame) - LINE_HEIGHT, CGRectGetWidth(self.overlay.frame), LINE_HEIGHT)];
        
        if (!self.isShowLine) {
            self.lineView.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_1];
            self.lineView.hidden = NO;
            [self.overlay addSubview:self.lineView];
        }else{
            self.lineView.hidden = YES;
            self.lineView.backgroundColor = [UIColor clearColor];
            [self.overlay addSubview:self.lineView];
        }
        
        [self insertSubview:self.overlay atIndex:0];
    }
    
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setContentAlpha:(CGFloat)alpha
{
    if (!self.overlay) {
        [self lt_setBackgroundColor:self.barTintColor];
    }
    [self setAlpha:alpha forSubviewsOfView:self];
    if (alpha == 1) {
        if (!self.emptyImage) {
            self.emptyImage = [UIImage new];
        }
        self.backIndicatorImage = self.emptyImage;
    }
}

- (void)setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if (subview == self.overlay) {
            continue;
        }
        subview.alpha = alpha;
        [self setAlpha:alpha forSubviewsOfView:subview];
    }
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];

    [self.overlay removeFromSuperview];
    self.overlay = nil;
    
    [self.lineView removeFromSuperview];
    self.lineView = nil;
}

@end
