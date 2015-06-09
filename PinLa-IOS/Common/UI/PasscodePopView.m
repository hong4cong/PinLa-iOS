//
//  PasscodePopView.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/2/28.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "PasscodePopView.h"
#import "BKPasscodeField.h"
#import "NSString+Size.h"
#import "UITextField+ResignKeyboard.h"

static const CGFloat hTitleFontSize = 18;
static const CGFloat hPopSideMargin = 10;

@interface PasscodePopView ()<BKPasscodeFieldImageSource>

@property(nonatomic,strong)UILabel*             titleLabel;
@property(nonatomic,strong)UILabel*             messageLabel;
@property(nonatomic,strong)UIView*              popView;
@property(nonatomic,strong)UIImageView*         backgroundView;
@property(nonatomic,strong)UIButton*            cancelBtn;

@property(nonatomic,strong)BKPasscodeField*     passcodefield;

@property(nonatomic,assign)CGFloat              msgFontSize;
@property(nonatomic,assign)NSString*            msgColor;
@property(nonatomic)       NSTextAlignment      msgTextAlignment;

@end

@implementation PasscodePopView

- (instancetype)initWithTitle:(NSString *)title Message:(NSString*) message delegate:(id /*<PasscodePopDelegate>*/)delegate
{
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        
        self.title = title;
        self.message = message;
        self.msgFontSize = 14;
        self.msgColor = @"#666666";
        self.msgTextAlignment = NSTextAlignmentCenter;
//        [self initView];
    }
    return self;
}

- (void)initView
{
    self.frame = [self mainScreenFrame];
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    [self makeBackgroundBlur];
    [self makePopupView];
    if (self.title) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.popView.frame), 50)];
        self.titleLabel.text = self.title;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:hTitleFontSize];
        [self.popView addSubview:self.titleLabel];
    }
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(10, 13, 25, 25);
    [self.cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self
                       action:@selector(pressButton:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:self.cancelBtn];
    
    int height = [self.message fittingLabelHeightWithWidth:CGRectGetWidth(self.popView.frame)-24 andFontSize:[UIFont systemFontOfSize:self.msgFontSize]];
    
    if (height != 0 && height < self.msgFontSize*2) {
        height = self.msgFontSize*2;
    }
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.popView.frame)-24, height)];
    self.messageLabel.text = self.message;
    self.messageLabel.textColor = [UIColor colorWithHexString:self.msgColor];
    self.messageLabel.font = [self.messageLabel.font fontWithSize:self.msgFontSize];
    // Line Breaking
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.numberOfLines = 0;
    [self.messageLabel setTextAlignment:self.msgTextAlignment];
    [self.popView addSubview:self.messageLabel];
    
    self.passcodefield = [[BKPasscodeField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.messageLabel.frame)+10, 240, 40)];
    self.passcodefield.dotSpacing = 0;
    self.passcodefield.maximumLength = 6;
    self.passcodefield.dotSize = CGSizeMake(40, 40);
    self.passcodefield.keyboardType = UIKeyboardTypeNumberPad;
    self.passcodefield.imageSource = self;
    [self.passcodefield addTarget:self action:@selector(passcodeControlEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.popView addSubview:self.passcodefield];
    
    self.popView.frame = CGRectMake(self.popView.frame.origin.x, self.popView.frame.origin.y, CGRectGetWidth(self.popView.frame), CGRectGetMaxY(self.passcodefield.frame) + hPopSideMargin*3);
    self.popView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/3);
}

#pragma mark - View Layout Methods
- (void)makeBackgroundBlur
{
    self.backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.42];
    self.backgroundView.alpha = 0.0;
    
    [self addSubview:self.backgroundView];
}

- (void)makePopupView
{
    
    CGRect screen = [self mainScreenFrame];
    CGRect frame = CGRectMake(30, 0, screen.size.width - 60, 200);
    
    self.popView = [[UIView alloc]initWithFrame:frame];
    //    CGRect screen = [self mainScreenFrame];
    //    self.alertView.center = CGPointMake(CGRectGetWidth(screen)/2, (screen.size.height + 64)/2);
    [self.popView.layer setCornerRadius:2.0];
    [self.popView.layer setBorderWidth:1.0];
    [self.popView.layer setBorderColor:[UIColor clearColor].CGColor];
    self.popView.layer.masksToBounds = YES;
    self.popView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
    
    [self addSubview:self.popView];
}

- (void)show
{
    [self initView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    //    [HAlertView exChangeOut:self.alertView dur:0.3];
    [self showAnimation];
    
    [self.passcodefield becomeFirstResponder];
}

- (void)update
{
    self.titleLabel.text = self.title;
    
    int height = [self.message fittingLabelHeightWithWidth:CGRectGetWidth(self.popView.frame)-24 andFontSize:[UIFont systemFontOfSize:self.msgFontSize]];
    
    if (height != 0 && height < self.msgFontSize*2) {
        height = self.msgFontSize*2;
    }
    self.messageLabel.frame = CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.popView.frame)-24, height);
    self.messageLabel.text = self.message;
    
    self.passcodefield.frame = CGRectMake(10, CGRectGetMaxY(self.messageLabel.frame)+10, 240, 40);
    
    self.popView.frame = CGRectMake(self.popView.frame.origin.x, self.popView.frame.origin.y, CGRectGetWidth(self.popView.frame), CGRectGetMaxY(self.passcodefield.frame) + hPopSideMargin*3);
    self.popView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/3);
}

- (void)dismiss{
    [self hideAnimation];
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
    [self.popView.layer addAnimation:animation forKey:nil];
}

- (void)hideAnimation
{
    self.backgroundView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.popView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.0;
            self.popView.transform = CGAffineTransformMakeScale(0.35, 0.35);
            self.popView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(passcodePopView:cancelBtn:)]) {
                [self.delegate passcodePopView:self cancelBtn:nil];
            }
            [self removeFromSuperview];
        }];
    }];
}

- (NSString *)passcode
{
    return self.passcodefield.passcode;
}

- (void)setPasscode:(NSString *)passcode
{
    [(BKPasscodeField *)self.passcodefield setPasscode:passcode];;
}

#pragma mark - Button Methods
- (void)pressButton:(id)sender
{
    [self dismiss];
}

- (void)passcodeControlEditingChanged:(id)sender
{
    if (![self.passcodefield isKindOfClass:[BKPasscodeField class]]) {
        return;
    }
    
    BKPasscodeField *passcodeField = (BKPasscodeField *)self.passcodefield;
    
    if (passcodeField.passcode.length == passcodeField.maximumLength) {
        if ([self.delegate respondsToSelector:@selector(passcodeDidFinish:)]) {
            [self.delegate passcodeDidFinish:self];
        }
    }
}

#pragma mark - BKPasscodeFieldImageSource

- (UIImage *)passcodeField:(BKPasscodeField *)aPasscodeField dotImageAtIndex:(NSInteger)aIndex filled:(BOOL)aFilled
{
    if (aFilled) {
        return [UIImage imageNamed:@"input_highlight"];
    } else {
        return [UIImage imageNamed:@"input_normal"];
    }
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
