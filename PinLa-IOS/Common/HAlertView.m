//
//  HAlertView.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/28.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "HAlertView.h"
#import "UIImage+Util.h"
#import "NSString+Size.h"
#import <QuartzCore/CAAnimation.h>

static NSString* hAlertconfirmBtnNormalColor = @"#ff7736";
static NSString* hAlertconfirmBtnHighlightColor = @"#2a36b1";
static NSString* hAlertCancelBtnNormalColor = @"#e51c23";
static NSString* hAlertCancelBtnHighlightColor = @"#b0120a";

//static const CGFloat hAlertTitleHeight = 40;
static const CGFloat hAlertBtnHeight = 40;
static const CGFloat hAlertTitleFontSize = 18;
//static const CGFloat hAlertMessageFontSize = 13;
static const CGFloat hAlertBtnFontSize = 15;

static const CGFloat hAlertSideMargin = 10;

@interface HAlertView()
{
    HAlertBtnType buttonType;
}

@property(nonatomic,strong)NSString*            title;
@property(nonatomic,strong)NSString*            message;

@property(nonatomic,strong)NSString*            cancelTitle;
@property(nonatomic,strong)NSString*            confirmTitle;

@property(nonatomic,strong)UIImageView*         backgroundView;
@property(nonatomic,strong)UIView*              alertView;
@property(nonatomic,strong)UILabel*             titleLabel;
@property(nonatomic,strong)UILabel*             messageLabel;


@end

@implementation HAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<HAlertViewDelegate>*/)delegate cancelBtnTitle:(NSString *)cancelBtnTitle confirmBtnTitle:(NSString *)confirmBtnTitle;
{
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        
        self.title = title;
        self.message = message;
        
        self.confirmTitle = confirmBtnTitle;
        self.cancelTitle = cancelBtnTitle;
        self.titleFontSize = 18;
        self.msgFontSize = 14;
        self.msgColor = @"#666666";
        self.msgTextAlignment = NSTextAlignmentCenter;
        
//        [self initAlert];
    }
    return self;
}

- (void)initAlert
{
    self.frame = [self mainScreenFrame];
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self makeBackgroundBlur];
    [self makeAlertPopupView];
    
    [self makeAlertTitle];
    [self makeAlertMessage];
    [self makeAlertButton];

//    [self moveAlertPopupView];
}

#pragma mark - View Layout Methods
- (void)makeBackgroundBlur
{
    self.backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
    
//    UIImage *image = [UIImage convertViewToImage];
//    UIImage *blurSnapshotImage = nil;
//    blurSnapshotImage = [image applyBlurWithRadius:5.0
//                                         tintColor:[UIColor colorWithWhite:0.5
//                                                                     alpha:0.7]
//                             saturationDeltaFactor:1.8
//                                         maskImage:nil];
//    
//    self.backgroundView.image = blurSnapshotImage;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.42];
    self.backgroundView.alpha = 0.0;
    
    [self addSubview:self.backgroundView];
}

- (void)makeAlertPopupView
{
    
    CGRect screen = [self mainScreenFrame];
    CGRect frame = CGRectMake(30, 0, screen.size.width - 60, 200);
    
    self.alertView = [[UIView alloc]initWithFrame:frame];
//    CGRect screen = [self mainScreenFrame];
//    self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, (screen.size.height + 64)/2);
    [self.alertView.layer setCornerRadius:2.0];
    [self.alertView.layer setBorderWidth:1.0];
    [self.alertView.layer setBorderColor:[UIColor clearColor].CGColor];
    self.alertView.layer.masksToBounds = YES;
    self.alertView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
    
    [self addSubview:self.alertView];
}

- (void)makeAlertTitle
{
    if (self.title && self.title.length) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, hAlertSideMargin, CGRectGetWidth(self.alertView.frame), 20)];
        self.titleLabel.text = self.title;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleFontSize];
        [self.alertView addSubview:self.titleLabel];
    }
}

- (void)makeAlertMessage
{
    int height = [self.message fittingLabelHeightWithWidth:CGRectGetWidth(self.alertView.frame)-24 andFontSize:[UIFont systemFontOfSize:self.msgFontSize]];
    
    if (height != 0 &&height < self.msgFontSize*2) {
        height = self.msgFontSize*2;
    }
    
    if (height == 0) {
        self.titleLabel.frame = CGRectMake(0, hAlertSideMargin*2, CGRectGetWidth(self.alertView.frame), 20);
    }
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + hAlertSideMargin, CGRectGetWidth(self.alertView.frame) - 20, height)];
    self.messageLabel.text = self.message;
    self.messageLabel.textColor = [UIColor colorWithHexString:self.msgColor];
    self.messageLabel.font = [self.messageLabel.font fontWithSize:self.msgFontSize];
    // Line Breaking
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.numberOfLines = 0;
    [self.messageLabel setTextAlignment:self.msgTextAlignment];
    [self.alertView addSubview:self.messageLabel];
    
    if (self.confirmTitle || self.cancelTitle) {
        UIView* bottomLine = [UIView new];
        bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.alertView.frame), LINE_HEIGHT);
        bottomLine.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
//        [self.alertView addSubview:bottomLine];
    }
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x, self.alertView.frame.origin.y, CGRectGetWidth(self.alertView.frame), CGRectGetMaxY(self.messageLabel.frame) + hAlertSideMargin);
    self.alertView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}

- (void)makeAlertButton
{
    if (self.cancelTitle) {
        self.cancelBtn = [[UIButton alloc]init];
        [self.cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:hAlertBtnFontSize];
        [self.cancelBtn setTitleColor:[UIColor colorWithHexString:COLOR_BUTTON_MAIN] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.15] andSize:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f).size] forState:UIControlStateHighlighted];
        [self.cancelBtn addTarget:self
                           action:@selector(pressAlertButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancelBtn];
        
        if (self.confirmTitle) {
            self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, CGRectGetWidth(self.alertView.frame)/2, hAlertBtnHeight);
        }else{
            self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, CGRectGetWidth(self.alertView.frame), hAlertBtnHeight);
        }
    }
    
    if (self.confirmTitle) {
        self.confirmBtn = [[UIButton alloc]init];
        [self.confirmBtn setTitle:self.confirmTitle forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor colorWithHexString:hAlertconfirmBtnNormalColor] forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.15] andSize:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f).size] forState:UIControlStateHighlighted];
        
        self.confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:hAlertBtnFontSize];
        [self.confirmBtn addTarget:self
                         action:@selector(pressAlertButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.confirmBtn];
        
        if (self.cancelTitle) {
            self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame), CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, CGRectGetWidth(self.alertView.frame)/2, hAlertBtnHeight);
        }else{
            self.confirmBtn.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, CGRectGetWidth(self.alertView.frame), hAlertBtnHeight);
        }
    }
    
    if (self.confirmTitle || self.cancelTitle) {
        
        UIView* bottomLine = [UIView new];
        bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, CGRectGetWidth(self.alertView.frame), LINE_HEIGHT);
        bottomLine.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.alertView addSubview:bottomLine];
        
        self.alertView.frame = CGRectMake(self.alertView.frame.origin.x, self.alertView.frame.origin.y, CGRectGetWidth(self.alertView.frame), CGRectGetMaxY(self.messageLabel.frame) + hAlertBtnHeight + hAlertSideMargin );
        self.alertView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    }
    
    if (self.confirmTitle && self.cancelTitle) {
        UIView *middleLine = [UIView new];
        middleLine.frame = CGRectMake(CGRectGetWidth(self.alertView.frame)/2, CGRectGetMaxY(self.messageLabel.frame)+hAlertSideMargin, LINE_HEIGHT, hAlertBtnHeight);
        middleLine.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.alertView addSubview:middleLine];
    }
    
}

- (void)show
{
    [self initAlert];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
//    [HAlertView exChangeOut:self.alertView dur:0.3];
    [self showAnimation];
}

- (void)dismiss{
    [self hideAnimation];
}

+ (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [changeOutView.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)showAnimation
{
    self.backgroundView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.backgroundView.alpha = 1.0;
    }];
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.505824;
    animation.fillMode = kCAFillModeBoth;
    animation.keyTimes = @[@0.1f, @0.5f];
    animation.values = [NSMutableArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.26f, 1.26f, 1.0)],[NSValue valueWithCATransform3D:CATransform3DIdentity],nil];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.delegate = self;
    [self.alertView.layer addAnimation:animation forKey:nil];
}

- (void)hideAnimation
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
////    animation.beginTime = CMTimeGetSeconds(CMTimeAdd(img.passTimeRange.start, img.passTimeRange.duration));
//    animation.duration = 0.505824;
//    animation.fromValue = [NSNumber numberWithFloat:1.0f];
//    animation.toValue = [NSNumber numberWithFloat:0.0f];
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeBoth;
//    animation.additive = NO;
//    animation.delegate = self;
//    
//    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
//    keyFrame.duration = 1;
//    //    self.view.backgroundColor
//    keyFrame.values = @[(id)[UIColor clearColor].CGColor];
//    //keyTimes 0 1/7 2/7 3/7 4/7 5/7 6/7 1(时间分配)
//    //keyTimes第一个值是0不能改变;最后一个为1同理;
//    keyFrame.keyTimes = @[@(0.1),@(0.9),@(1.0),@(0.5),@(0.6),@(0.7),@(1.0)];//(手动时间分配)
//    
//    [self.alertView.layer addAnimation:keyFrame forKey:@"opacityOUT"];
    self.backgroundView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.0;
            self.alertView.transform = CGAffineTransformMakeScale(0.35, 0.35);
            self.alertView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:buttonType:)]) {
                [self.delegate alertView:self buttonType:buttonType];
            }
            [self removeFromSuperview];
        }];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    [self removeFromSuperview];
    self.alpha = 1.0;
}

#pragma mark - Button Methods
- (IBAction)pressAlertButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if( [button isEqual:self.confirmBtn] ) {
        NSLog(@"Pressed Button is confirmButton");
        buttonType = HAlertBtnConfirm;
    }
    else {
        NSLog(@"Pressed Button is CancelButton");
        buttonType = HAlertBtnCancel;
    }
    
    [self dismiss];
}

#pragma mark - Util Methods
- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)setShadowLayer:(CALayer *)layer
{
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 0.6;
    layer.shadowOpacity = 0.3;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
