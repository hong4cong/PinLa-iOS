//
//  PasscodePopView.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/2/28.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasscodePopView;

typedef enum : NSUInteger {
    TYPE_PASSCODEPOP_SET,
    TYPE_PASSCODEPOP_REINPUT,
    TYPE_PASSCODEPOP_CHECK,
} PasscodePopType;

@protocol PasscodePopDelegate <NSObject>

- (void)passcodePopView:(PasscodePopView *)popView cancelBtn:(id)sender;

- (void)passcodeDidFinish:(PasscodePopView*)popView;

@end

@interface PasscodePopView : UIView

@property(nonatomic,strong)NSString*            title;
@property(nonatomic,strong)NSString*            message;
@property(nonatomic,strong)NSString*            passcode;

@property(nonatomic,assign)NSInteger            type;

@property(nonatomic,assign)id<PasscodePopDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title Message:(NSString*) message delegate:(id /*<PasscodePopDelegate>*/)delegate;
- (void)show;
- (void)dismiss;
- (void)update;

@end
