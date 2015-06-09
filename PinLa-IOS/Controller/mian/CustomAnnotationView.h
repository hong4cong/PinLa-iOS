//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by hongcong on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@protocol CustomAnnotationViewDelegate <NSObject>

- (void)closeAnn;
- (void)presentViewController:(UIViewController *)viewControllerToPresent;

@end

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, strong) NSArray* arr_imgs;

@property (nonatomic, assign) MainViewController* viewController;

@property (nonatomic, strong) UIButton*         btn_back;

@property (nonatomic,assign)MAMapView* mapView;

@property (nonatomic,assign)id<CustomAnnotationViewDelegate> customdelegate;

@property(nonatomic,strong)NSMutableArray* userList;

@property(nonatomic,strong)UILabel *title;

@property (nonatomic, assign) NSInteger  usersCount;

+ (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect;

@end
