//
//  AddRelationView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelationCell.h"

@protocol AddRelationViewDelegate <NSObject>

- (void)addRelationFromContactAction:(id)sender;
- (void)addRelationFromWchatAction:(id)sender;
- (void)searchAction:(id)sender;

@end

@interface AddRelationView : UIView

@property (nonatomic, weak) id<AddRelationViewDelegate> delegate;

@property (nonatomic, strong) UITextField       *tf_UID;
@property (nonatomic, strong) RelationCell      *v_user;
@property (nonatomic, strong) UIButton          *btn_search;
@property (nonatomic, strong) UIButton          *btn_addFromContact;
@property (nonatomic, strong) UIButton          *btn_addFromWchat;
@property (nonatomic, strong) UILabel           *lb_memo;
@property (nonatomic, strong) UIView            *v_background;
@property (nonatomic, strong) UIView            *bg_color;
@end
