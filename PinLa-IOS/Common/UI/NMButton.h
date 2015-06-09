//
//  NMButton.h
//  HelloWorld
//
//  Created by Cuibin on 8/12/13.
//  Copyright (c) 2013 Cuibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMButton : UIControl
{
    NSMutableDictionary *_titles;       // NSString
    NSMutableDictionary *_titleColors;  // UIColor
    NSMutableDictionary *_titleShadows; // UIColor
    NSMutableDictionary *_images;       // UIImage
    NSMutableDictionary *_backgrounds;  // UIImage
}

@property(nonatomic, assign) CGPoint titleCenter; // default is center in background
@property(nonatomic, assign) CGPoint imageCenter; // default is center in background

@property(nonatomic,readonly,retain) UILabel     *titleLabel;
@property(nonatomic,readonly,retain) UIImageView *imageView;
@property(nonatomic,readonly,retain) UIImageView *background;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (UIColor *)titleShadowColorForState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;

@end
