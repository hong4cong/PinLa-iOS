//
//  LiftButton.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/3/20.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "LiftButton.h"

#define time_interval 0.5

@interface LiftButton ()

@property (nonatomic,strong)id                  target;
@property (nonatomic,assign)SEL                 action;
@property (nonatomic,assign)UIControlEvents     controlEvents;
@property (nonatomic,assign)NSTimeInterval      lastTimeTouch;
@property (nonatomic,assign)double              timeInterval;

@end

@implementation LiftButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initAction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAction];
    }
    return self;
}

- (void)initAction
{
    [super addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [super addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target = target;
    self.action = action;
    self.controlEvents = controlEvents;
}

- (void)touchDown:(NMButton*) sender
{
    NSLog(@"touchDown");
    NSTimeInterval timeTouch = [NSDate date].timeIntervalSince1970;
    self.timeInterval = timeTouch - self.lastTimeTouch;
    self.lastTimeTouch = timeTouch;
    if (self.timeInterval > time_interval) {
        [sender.imageView.layer addAnimation:[self liftAnimationUp] forKey:@"liftAnimationUp"];
    }
}

- (void)touchUp:(NMButton*) sender
{
    NSLog(@"touchUp");
    if (self.timeInterval > time_interval) {
        [sender.imageView.layer addAnimation:[self liftAnimationDown] forKey:@"liftAnimationDown"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.controlEvents == UIControlEventTouchUpInside || self.controlEvents == UIControlEventTouchUpOutside) {
        
        [self.target performSelector:self.action withObject:nil afterDelay:0.0];
    }
}

- (CABasicAnimation*)liftAnimationUp
{
    CGFloat durationUp = 0.2f;
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0f / 800.0f;
    t = CATransform3DTranslate(t, 0, 0, 200);
    CABasicAnimation *liftAnimationUp = [CABasicAnimation animationWithKeyPath:@"transform"];
    liftAnimationUp.toValue = (id) [NSValue valueWithCATransform3D:t];
    liftAnimationUp.duration = durationUp;
    liftAnimationUp.fillMode = kCAFillModeForwards;
    liftAnimationUp.removedOnCompletion = NO;
    liftAnimationUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return liftAnimationUp;
}

- (CABasicAnimation*)liftAnimationDown
{
    CGFloat durationDown = 0.2f;
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0f / 800.0f;
    
    CABasicAnimation *liftAnimationDown = [CABasicAnimation animationWithKeyPath:@"transform"];
    liftAnimationDown.toValue = (id) [NSValue valueWithCATransform3D:t];
    liftAnimationDown.duration = durationDown;
    liftAnimationDown.fillMode = kCAFillModeForwards;
    liftAnimationDown.removedOnCompletion = NO;
    liftAnimationDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    liftAnimationDown.delegate = self;
    [liftAnimationDown setBeginTime:CACurrentMediaTime()+0.1];
    return liftAnimationDown;
}

@end
