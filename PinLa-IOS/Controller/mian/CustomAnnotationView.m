//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "HexagonView.h"
#import "HotspotCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ProfileViewController.h"

#define kWidth  150.f
#define kHeight 10.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  30.f
#define kPortraitHeight 30.f

#define kCalloutWidth   304.0
#define kCalloutHeight  300.0

static NSString *kcellIdentifier = @"collectionCellID";

@interface CustomAnnotationView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray    *arr_single;
@property (nonatomic, strong) NSMutableArray    *arr_double;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            NSInteger count = [self calculateSections:_usersCount];
            
            if(count>5){
                count = 5;
            }
            
            NSInteger height = 144 + (count - 1)*55;
            
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, height)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize = CGSizeMake(kCalloutWidth,CGRectGetHeight(self.calloutView.frame) - 40);
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            
            _title = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, CGRectGetWidth(self.calloutView.frame) - 60, 20)];
            _title.backgroundColor = [UIColor clearColor];
            _title.textColor = [UIColor whiteColor];
            _title.font = [UIFont systemFontOfSize:13];
            [self.calloutView addSubview:_title];
            
            self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.calloutView.frame) - 42, 0, 40, 40)];
            [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            [self.calloutView addSubview:self.btn_back];
            
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_title.frame)+3, CGRectGetWidth(self.calloutView.frame), CGRectGetHeight(self.calloutView.frame) - 40 - 5)collectionViewLayout:flowLayout];
            [self.collectionView registerClass:[HotspotCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
            self.collectionView.backgroundColor = [UIColor clearColor];
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            
            [self.calloutView addSubview:self.collectionView];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

- (void)goBack:(id)sender
{
    [_customdelegate closeAnn];
}

- (void)tapAction
{
    
}

- (void)setUserList:(NSMutableArray *)userList
{
    [_userList removeAllObjects];
    [_arr_single removeAllObjects];
    [_arr_double removeAllObjects];
    _userList = userList;
    
    int num = 0;
    for(int i = 0; i < _userList.count; i){
        if (num%2 == 0) {
            NSMutableArray* arr = [NSMutableArray array];
            for (int j = 0; j < 4; j++) {
                if (_userList.count > i) {
                    UserEntity* entity = [_userList objectAtIndex:i];
                    [arr addObject:entity];
                    i++;
                }else{
                    break;
                }
            }
            [_arr_single addObject:arr];
        }else{
            NSMutableArray* arr = [NSMutableArray array];
            for (int j = 0; j < 3; j++) {
                if (_userList.count > i) {
                    UserEntity* entity = [_userList objectAtIndex:i];
                    [arr addObject:entity];
                    i++;
                }else{
                    break;
                }
            }
            [_arr_double addObject:arr];
        }
        num++;
    }
    
    [self.collectionView reloadData];
}

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//{
//    CGPoint hitPoint = [calloutView convertPoint:point fromView:self];
//    if ([calloutView pointInside:hitPoint withEvent:event])
//    {
//        return calloutView;
//    }
//    return [super hitTest:point withEvent:event];
//}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _arr_single = [NSMutableArray array];
        _arr_double = [NSMutableArray array];
        
        self.bounds = CGRectMake(0.f, 0.f, kHeight, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPortraitWidth, kPortraitHeight)];
        self.portraitImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:self.portraitImageView];
        
    }
    
    return self;
}

+ (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark -CollectionView datasource & delegate
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _arr_single.count + _arr_double.count;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section%2 == 0) {
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_single objectAtIndex:index];
        return arr.count;
    }else{
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_double objectAtIndex:index];
        
        return arr.count;
    }
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(72, 72);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section%2 == 1) {
        if (section == ([self numberOfSectionsInCollectionView:collectionView] - 1 )) {
            return UIEdgeInsetsMake(-15, 44, 0, 44);
        }
        
        return UIEdgeInsetsMake(-15, 44, -15, 44);
    }else{
        return UIEdgeInsetsMake(5, 8, 5, 8);
    }
    //分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    //重用cell
    HotspotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    
    if (section%2 == 0) {
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_single objectAtIndex:index];
        UserEntity* entity = [arr objectAtIndex:row];
        [cell contentDataWithEntity:entity];
    }else{
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_double objectAtIndex:index];
        UserEntity* entity = [arr objectAtIndex:row];
        [cell contentDataWithEntity:entity];
    }
    return cell;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    UserEntity* entity;
    if (section%2 == 0) {
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_single objectAtIndex:index];
        entity = [arr objectAtIndex:row];
    }else{
        NSInteger index = section/2;
        NSMutableArray* arr = [_arr_double objectAtIndex:index];
        entity = [arr objectAtIndex:row];
    }
    
    ProfileViewController* vc = [[ProfileViewController alloc]init];
    vc.profileType = ProfileTypeOthers;
    vc.entity = entity;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.customdelegate presentViewController:navigationController];
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)calculateSections:(NSInteger)count
{
    if (count < 7) {
        if (count > 4) {
            return 2;
        }else{
            return 1;
        }
    }
    
    NSInteger quotient = count/7;
    NSInteger remainder = count%7;
    
    if(remainder == 0){
        return quotient * 2;
    }
    
    if (quotient % 2 == 1) {
        if (remainder > 4) {
            return quotient*2 + 2;
        }else{
            return quotient*2 + 1;
        }
        
    }else{
        if (remainder > 3) {
            return quotient*2 + 2;
        }else{
            return quotient*2 + 1;
        }
    }
    
    return 0;
}

@end
