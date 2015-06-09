//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
#import <UIImageView+WebCache.h>
static CGRect oldframe;

@interface SJAvatarBrowser ()

@property(nonatomic,strong)UIImage *oldImage;
@property(nonatomic,strong)UIImageView* oldImageView;

@end

@implementation SJAvatarBrowser

- (void)showImage:(UIImageView *)avatarImageView newImage:(NSString*)newImageStr {
    self.oldImageView = avatarImageView;
    self.oldImage = avatarImageView.image;
    
    UIImage *image = avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:newImageStr] placeholderImage:_oldImage];
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame=CGRectMake(0, 0, image.size.width, image.size.height);
//        imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

 - (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        _oldImageView.image = _oldImage;
        [backgroundView removeFromSuperview];
    }];
}
@end
