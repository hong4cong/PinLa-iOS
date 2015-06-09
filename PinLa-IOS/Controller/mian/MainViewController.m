//
//  ViewController.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/12.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "MainViewController.h"
//#import "MainView.h"
#import "RENavigationController.h"
#import "HAlertView.h"
#import "LoginViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAPointAnnotation.h>
#import "ScanningPanelView.h"
#import "MessageViewController.h"
#import "AccountHandler.h"
#import "CustomAnnotationView.h"
#import "AllMACircle.h"
#import "UserStorage.h"
#import "HotspotHandler.h"
#import "CoordinateEntity.h"
#import "PieceHandler.h"
#import "HexagonOverlay.h"
#import "HexagonOverlayRenderer.h"
#import "UsersHexOverlay.h"
#import "UsersHexOverlayRenderer.h"
#import <MAMapKit/MAGeometry.h>
#import "MapSelectorGestureRecognizer.h"
#import "TradeHandler.h"
#import "HotspotPolyEntity.h"
#import "HotspotEntity.h"
#import "PolyUserEntity.h"
#import "PhysicalEntity.h"
#import "UITextField+ResignKeyboard.h"
#import <UIImageView+WebCache.h>
#import "ProfileViewController.h"
#import "CalloutOverlay.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "LTBounceSheet.h"
#import "BackpackViewController.h"

#define kCalloutViewMargin          -8

@interface MainViewController ()<MAMapViewDelegate,AMapSearchDelegate,CustomAnnotationViewDelegate,CLLocationManagerDelegate,UAModalPanelDelegate>
{
    MAMapView               *_mapView;
    AMapSearchAPI           *_search;
//    CLLocationManager*      _locationManager;
    
}

@property(nonatomic,strong)NSMutableArray* overlays;
@property(nonatomic, strong) NSMutableArray *arr_user;
@property(nonatomic, strong) NSMutableArray *arr_hotspot;
@property(nonatomic,strong)CalloutOverlay *popHexagonOverlay;
@property(nonatomic,assign)NSInteger    selectNum;
@property(nonatomic,strong)UIImageView  *updatesView;
@property(nonatomic,strong)UIButton * msgBtn;
@property(nonatomic,strong)UIButton * menuBtn;
@property(nonatomic,strong)UIButton * searchBtn;
@property(nonatomic,strong)UIButton * locationBtn;
@property(nonatomic,strong)HotspotPolyEntity* hotspotPolydata;
@property(nonatomic,strong)CustomAnnotationView *annotationView;
//@property(nonatomic,strong)MAUserLocation *userLocation;
@property(nonatomic,strong)UIImageView  *battery;
@property(nonatomic,strong)UILabel* lb_distance;
@property(nonatomic,strong)UILabel* lb_physicalTime;
@property(nonatomic,strong)UILabel* lb_radiiTime;
//@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,assign)NSInteger physicalTime;
@property(nonatomic,assign)NSInteger radiiTime;
@property(nonatomic,strong)NSTimer* countDownTimer;
@property(nonatomic,assign)CGPoint touchPoint;
@property(nonatomic,strong)UIView* nicknameSettingbgView;
@property(nonatomic,strong)UITextField* tf_nickname;
@property(nonatomic,strong)UIButton *btn_submit;
@property(nonatomic,strong)UIImageView  *avatarImageView;
@property(nonatomic,strong)CLLocation   *lastLocation;
@property(nonatomic,strong)MAPointAnnotation *locationAnn;
@property(nonatomic,assign)BOOL isRequestScanning;
@property(nonatomic,strong)UILabel* lb_geocode;
@property(nonatomic,assign)BOOL hasLocated;
@property(nonatomic,strong)AllMACircle *circleOverlay;
@property(nonatomic,strong)UIView* bgColorView;
@property(nonatomic,assign)BOOL  isStartCountDownTimer;
@property(nonatomic,assign)BOOL  isCanPickupPiece;

@property (nonatomic, strong) LTBounceSheet             *sheet;

@end

@implementation MainViewController

- (void)viewDidLoad {
    _isCanPickupPiece = YES;
    self.overlays = [NSMutableArray array];
    _arr_user = [NSMutableArray array];
    _arr_hotspot = [NSMutableArray array];
    
    [super viewDidLoad];
}

- (void)onCreate
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.mapType = MAMapTypeSatellite;
        _mapView.delegate = self;
        _mapView.scaleOrigin = CGPointMake(CGRectGetMaxX(self.view.frame) - 150, CGRectGetMaxY(self.view.frame) - 50);
        _mapView.userTrackingMode = MAUserTrackingModeNone;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        _mapView.zoomEnabled = NO;
        _mapView.zoomLevel = 15.5;
//        _mapView.showsUserLocation = YES;
        [_mapView addGestureRecognizer:[self selectorGestureRecognizer]];
        [self.view addSubview:_mapView];
        
        _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
        _search.delegate = self;
    }
    
    self.bgColorView = [[UIView alloc]initWithFrame:self.view.frame];
    self.bgColorView.backgroundColor = [[UIColor colorWithHexString:@"#001912"] colorWithAlphaComponent:0.8];
    self.bgColorView.userInteractionEnabled = NO;
    self.bgColorView.hidden = YES;
    [self.view addSubview:self.bgColorView];
    
//    [self initLocationManager];
    [self initMainImageBg];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(12, 25, 40, 40);
    [self.menuBtn addTarget:(RENavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.menuBtn setImage:[UIImage imageNamed:@"side_menu"] forState:UIControlStateNormal];
    [self.view addSubview:self.menuBtn];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(20, CGRectGetHeight(self.view.frame) - 37 - 24, 37, 37);
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBtn setImage:[UIImage imageNamed:@"img_scan"] forState:UIControlStateNormal];
    [self.view addSubview:self.searchBtn];
    
    self.msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.msgBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40 -12, 30, 40, 40);
    [self.msgBtn addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.msgBtn setImage:[UIImage imageNamed:@"img_message"] forState:UIControlStateNormal];
    [self.view addSubview:self.msgBtn];
    
    _avatarImageView = [[HexagonView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 80 - 8 -12, 25, 50, 50) image:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    [self.view addSubview:_avatarImageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarInvoked:)];
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:gesture];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40 -12, CGRectGetHeight(self.view.frame) - 33 - 24  - 10, 40, 40);
    [self.locationBtn addTarget:self action:@selector(locationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:[UIImage imageNamed:@"img_location_btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.locationBtn];
    
    UIImageView* scaleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_scale_icon"]];
    scaleImageView.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 80 - 20, CGRectGetHeight(self.view.frame) - 25 - 12 - 5, 40, 20);
    [self.view addSubview:scaleImageView];
    
    self.lb_geocode = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 150 - 55 - 5, CGRectGetMidY(scaleImageView.frame) - 20, 150, 15)];
    self.lb_geocode.font = [UIFont systemFontOfSize:10];
    self.lb_geocode.textColor = [UIColor whiteColor];
    self.lb_geocode.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.lb_geocode];
    
    _updatesView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 10, 10)];
    _updatesView.image = [UIImage imageNamed:@"img_redicon"];
    _updatesView.hidden = YES;
    [self.msgBtn addSubview:_updatesView];
    
    _battery = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame)+6, CGRectGetMinY(self.searchBtn.frame)+18, 36, 16)];
    _battery.image = [UIImage imageNamed:@"img_battery_0"];
    [self.view addSubview:_battery];
    
    _lb_physicalTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 35, 12)];
    _lb_physicalTime.font = [UIFont systemFontOfSize:11];
    _lb_physicalTime.textColor = [UIColor blackColor];
    _lb_physicalTime.textAlignment = NSTextAlignmentCenter;
    [_battery addSubview:_lb_physicalTime];
    
    _lb_distance = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame)+6, CGRectGetMinY(self.searchBtn.frame) + 2, 35, 13)];
    _lb_distance.font = [UIFont systemFontOfSize:12];
    _lb_distance.textColor = [UIColor whiteColor];
    _lb_distance.text = @"0.2km";
    [self.view addSubview:_lb_distance];
    
    _lb_radiiTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_distance.frame)+3, CGRectGetMinY(self.searchBtn.frame) + 4, 35, 12)];
    _lb_radiiTime.font = [UIFont systemFontOfSize:8];
    _lb_radiiTime.textColor = [UIColor colorWithHexString:@"#839A94"];
    _lb_radiiTime.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_lb_radiiTime];
    
    self.circleOverlay = [AllMACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.99, 116.481584) radius:5000000];
    [_mapView addOverlay:self.circleOverlay];
    
    if ([UserStorage userNickName] == nil || [[UserStorage userNickName] isEqual:@""]) {
        [self popNicknameSetting];
    }
    
    if ([UserStorage hotspotPolyEntity]) {
        self.hotspotPolydata = [UserStorage hotspotPolyEntity];
        [self AddMapOverlays];
        
        if ([UserStorage userCoordinate]) {
            CoordinateEntity* entity = [UserStorage userCoordinate];
            _lastLocation = [[CLLocation alloc]initWithLatitude:entity.lat longitude:entity.lng];
            
            if (_locationAnn) {
                [_mapView removeAnnotation:_locationAnn];
            }
            _locationAnn = [[MAPointAnnotation alloc] init];
            _locationAnn.coordinate = _lastLocation.coordinate;
            [_mapView addAnnotation:_locationAnn];

            
            [self locationBtnAction];
        }
    }else{
        _mapView.showsUserLocation = YES;
    }
    
    //初始化actionsheet
    [self setupActionSheet];
    self.sheet.hidden = YES;
}

//- (void)initLocationManager
//{
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        [AppUtils errorAlert:nil message:LOCATION_ACCESS_NOTICE];
//        return;
//    }
//    
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    [_locationManager startUpdatingLocation];
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
//    {
//        //设置定位权限 仅ios8有意义
//        [_locationManager requestWhenInUseAuthorization];// 前台定位
//    }
//}

- (void)initMainImageBg
{
    UIImageView* topleft = [[UIImageView alloc]initWithFrame:CGRectMake(8, 25, 15, 23)];
    topleft.image = [UIImage imageNamed:@"img_main_topleft"];
    [self.view addSubview:topleft];
    
    UIImageView* topmiddle = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 23)/2, 25, 24, 13)];
    topmiddle.image = [UIImage imageNamed:@"img_main_topmiddle"];
    [self.view addSubview:topmiddle];
    
    UIImageView* topright = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 15 - 8), 25, 15, 23)];
    topright.image = [UIImage imageNamed:@"img_main_topright"];
    [self.view addSubview:topright];
    
    UIImageView* leftmiddle = [[UIImageView alloc]initWithFrame:CGRectMake(8, (CGRectGetHeight(self.view.frame) - 30)/2, 10, 30)];
    leftmiddle.image = [UIImage imageNamed:@"img_main_leftmiddle"];
    [self.view addSubview:leftmiddle];
    
    UIImageView* rightmiddle = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 10 - 8), (CGRectGetHeight(self.view.frame) - 30)/2, 10, 30)];
    rightmiddle.image = [UIImage imageNamed:@"img_main_rightmiddle"];
    [self.view addSubview:rightmiddle];
    
    UIImageView* downleft = [[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.view.frame) - 23 - 20, 15, 23)];
    downleft.image = [UIImage imageNamed:@"img_main_downleft"];
    [self.view addSubview:downleft];
    
    UIImageView* downmiddle = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 23)/2, CGRectGetHeight(self.view.frame) - 13 - 20, 24, 13)];
    downmiddle.image = [UIImage imageNamed:@"img_main_downmiddle"];
    [self.view addSubview:downmiddle];
    
    UIImageView* downright = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 15 - 8), CGRectGetHeight(self.view.frame) - 23 - 20, 15, 23)];
    downright.image = [UIImage imageNamed:@"img_main_downright"];
    [self.view addSubview:downright];
}

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
//    [_mapView removeOverlay:_circleOverlay];
    _mapView.delegate = nil;
    _search.delegate = nil;
}

- (void)AddMapOverlays{
    if (self.overlays.count) {
        [_mapView removeOverlays:self.overlays];
        [self.overlays removeAllObjects];
    }
    
    for (int i = 0; i < self.hotspotPolydata.hotspot_list.count; i++) {
        HotspotEntity* entity = [self.hotspotPolydata.hotspot_list objectAtIndex:i];
        
        HexagonOverlay *overlay = [[HexagonOverlay alloc]initWithCenter:CLLocationCoordinate2DMake(entity.coordinate.lat, entity.coordinate.lng) radius:100];
        overlay.hotspot_level = entity.hotspot_level;
        
        [self.overlays addObject:overlay];
    }
    
    for (int i = 0; i < self.hotspotPolydata.user_list.count; i++) {
        PolyUserEntity* entity = [self.hotspotPolydata.user_list objectAtIndex:i];
        
        UsersHexOverlay *overlay = [[UsersHexOverlay alloc]initWithCenter:CLLocationCoordinate2DMake(entity.coordinate.lat, entity.coordinate.lng) radius:100];
        overlay.text = [NSString stringWithFormat:@"%ld",entity.user_num];
        overlay.entity = entity;
        [self.overlays addObject:overlay];
    }
    
    [_mapView addOverlays:self.overlays];
//    CLLocation *location = _mapView.userLocation.location;
//    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location.coordinate, 400*4, 400*4);
}

- (void)showScanningPanel:(NSArray*) arr_data
{
    ScanningPanelView* panel = [[ScanningPanelView alloc]initWithFrame:self.view.bounds];
    panel.delegate = self;
    panel.arr_data = arr_data;
    //panel.closeButton.hidden = YES;
    //    panel.delegate = self;
    panel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
    };
    
    panel.onActionPressed = ^(UAModalPanel* panel) {
    };
    [panel.closeButton removeFromSuperview];
    [self.view addSubview:panel];
    [panel showFromPoint:[_searchBtn center]];
}

- (void)showFullBackageAlert
{
    self.sheet.hidden = NO;
    self.sheet.shown = NO;
    [self.sheet toggle];
}


- (void)actionSheetHidden:(UITapGestureRecognizer *)tap{
    [SVProgressHUD dismiss];
    [self.sheet hide];
    
    self.sheet.hidden = YES;
}
- (void)setupActionSheet{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:1000 bgColor:[UIColor colorWithWhite:0 alpha:0.85]];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetHeight(self.sheet.frame)-195, 306, 44)];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.text = @"背包已满，是否继续？";
    lb_title.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.font = [UIFont systemFontOfSize:FONT_SIZE+5];
    [self.sheet addView:lb_title];
    
    UIButton * option1 = [self produceButtonWithTitle:@"继续扫描"];
    [option1 setBackgroundImage:[UIImage imageNamed:@"img_sheet_top"] forState:UIControlStateNormal];
    option1.tag = 10001;
    option1.frame=CGRectMake(7, CGRectGetHeight(self.sheet.frame)-151, 306, 44);
    [self.sheet addView:option1];
    
    UIButton * option2 = [self produceButtonWithTitle:@"整理背包"];
    [option2 setBackgroundImage:[UIImage imageNamed:@"img_sheet_bottom"] forState:UIControlStateNormal];
    option2.tag = 10002;
    option2.frame=CGRectMake(7, CGRectGetHeight(self.sheet.frame)-105, 306, 44);
    [self.sheet addView:option2];
    
    UIButton * cancel = [self produceButtonWithTitle:@"取消"];
    [cancel setBackgroundImage:[UIImage imageNamed:@"img_sheet_middle"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    cancel.tag = 10003;
    cancel.frame=CGRectMake(7, CGRectGetHeight(self.sheet.frame)-53, 306, 44);
    [self.sheet addView:cancel];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:FONT_SIZE+5];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionSheetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)actionSheetButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
        {
            _isCanPickupPiece = NO; //跳过拾取
            
            [self searchAction:nil];
        }
            break;
            
        case 10002:
        {
            [self searchAction:nil];

            [self gotoBackageViewController];
        }
            break;
            
        case 10003:
        {
            
        }
            break;
            
        default:
            return;
    }
    [self actionSheetHidden:nil];
}

#pragma mark - request method
- (void)reqestHotspot:(CLLocationCoordinate2D)coordinate
{
    if (![UserStorage userId]) {
        [SVProgressHUD dismiss];
        return;
    }
    CoordinateEntity* entity = [[CoordinateEntity alloc]init];
    entity.city_code = [UserStorage citycode] ? [UserStorage citycode] : @"";
    entity.lat = coordinate.latitude;
    entity.lng = coordinate.longitude;
    
    [HotspotHandler getHotspotWithUserId:[UserStorage userId] coordinate:entity prepare:^{
        if (_isCanPickupPiece) {
            self.bgColorView.hidden = NO;
        }else{
            self.bgColorView.hidden = YES;
        }
        _isCanPickupPiece = YES;
    } success:^(id obj) {
        self.hotspotPolydata = (HotspotPolyEntity*)obj;
        
        [UserStorage saveHotspotPolyEntity:_hotspotPolydata];
        
        [self AddMapOverlays];
        [self performSelector:@selector(actionSheetHidden:) withObject:nil afterDelay:1];
        
    } failed:^(NSInteger statusCode, id json) {
    }];
}

- (void)reqestHotspotList:(NSArray*)userIdList
{
    [HotspotHandler getHotspotListWithUserId:[UserStorage userId] userIdList:userIdList prepare:^{
        
    } success:^(id obj) {
        NSArray* userList = (NSArray*)obj;
        [_annotationView setUserList:[NSMutableArray arrayWithArray:userList]];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

- (void)reqestPiece:(CLLocationCoordinate2D)coordinate
{
    CoordinateEntity* entity = [[CoordinateEntity alloc]init];
    entity.city_code = [UserStorage citycode];
    entity.lat = coordinate.latitude;
    entity.lng = coordinate.longitude;
    
//    entity.lat = 39.99634;
//    entity.lng = 116.48048;
    
    [PieceHandler getPieceWithUserId:[UserStorage userId] coordinate:entity prepare:^{
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        NSArray* arr_data = (NSArray*)obj;
        [self showScanningPanel:arr_data];
        [self reqestHotspot:_lastLocation.coordinate];
        [self requestPhysical];
    } failed:^(NSInteger statusCode, NSString* json) {
        if (json) {
            
            NSRange range = [json rangeOfString:@"背包已满"];
            if(range.length){
                [SVProgressHUD dismiss];
                
                [self showFullBackageAlert];
            }else{
                [SVProgressHUD showErrorWithStatus:json];
            }
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)requestPhysical
{
    [AccountHandler loginVerifyWithUserId:[UserStorage userId] prepare:^{
    } success:^(id obj) {
        PhysicalEntity * entity = (PhysicalEntity *)obj;
        [UserStorage savePhysical:entity.physical];
        [UserStorage savePhysicalTime:entity.physical_time];
        [UserStorage saveRadii:entity.radii];
        [UserStorage saveRadiiTime:entity.radii_time];
        [self updatePhysical];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

- (void)updatePhysical
{
    NSInteger physical = [UserStorage physical];
    _physicalTime = [UserStorage physicalTime];
    NSInteger radii = [UserStorage radii];
    _radiiTime = [UserStorage radiiTime];
    
    _lb_distance.text = [NSString stringWithFormat:@"%.1fkm",(float)(radii/1000.0)];
    
    if(_radiiTime){
        _lb_radiiTime.hidden = NO;
    }else{
        _lb_radiiTime.hidden = YES;
    }
    
    self.searchBtn.enabled = YES;
    if (physical > 5) {
        _battery.image = [UIImage imageNamed:@"img_battery_6"];
        _lb_physicalTime.text = [NSString stringWithFormat:@"%ld+",physical];
        _lb_physicalTime.textColor = [UIColor blackColor];
    }else if (physical == 5){
        _battery.image = [UIImage imageNamed:@"img_battery_5"];
        _lb_physicalTime.text = @"";
        _lb_physicalTime.textColor = [UIColor grayColor];
    }else if (physical == 4){
        _battery.image = [UIImage imageNamed:@"img_battery_4"];
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime];
        _lb_physicalTime.textColor = [UIColor grayColor];
    }else if (physical == 3){
        _battery.image = [UIImage imageNamed:@"img_battery_3"];
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime];
        _lb_physicalTime.textColor = [UIColor grayColor];
    }else if (physical == 2){
        _battery.image = [UIImage imageNamed:@"img_battery_2"];
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime];
        _lb_physicalTime.textColor = [UIColor grayColor];
    }else if (physical == 1){
        _battery.image = [UIImage imageNamed:@"img_battery_1"];
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime];
        _lb_physicalTime.textColor = [UIColor grayColor];
    }else if (physical == 0){
        self.searchBtn.enabled = NO;
        _battery.image = [UIImage imageNamed:@"img_battery_0"];
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime];
        _lb_physicalTime.textColor = [UIColor grayColor];
    }
    
    [self startCountDownTimer];
}

-(void)timeFireMethod{
    _isStartCountDownTimer = YES;
    
    if ([UserStorage physicalTime] == 0 && [UserStorage physical] >= 5) {
        [self updatePhysical];
    }else{
        _lb_physicalTime.text = [AppUtils timeMinutesFormatted:_physicalTime--];
        if(_physicalTime <= 0){
            [UserStorage savePhysicalTime:0];
            [UserStorage savePhysical:[UserStorage physical]+1];
            [self requestPhysical];
        }
    }
    
    if ([UserStorage radiiTime] == 0) {
        _lb_radiiTime.text = @"";
    }else{
       _lb_radiiTime.text = [AppUtils timeHourFormatted:_radiiTime--];
        
        if (_radiiTime <= 0) {
            [UserStorage saveRadiiTime:0];
        }
    }
}

- (void)startCountDownTimer
{
    if (!_isStartCountDownTimer) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        if(_countDownTimer){
            [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)stopCountDownTimer
{
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        _isStartCountDownTimer = NO;
    }
}

-(void)initLeftBarView
{
    UIButton * btnAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAvatar.frame = CGRectMake(0, 0, 25, 25);
    [btnAvatar setBackgroundImage:[UIImage imageNamed:@"img_avatar_icon"] forState:UIControlStateNormal];
    [btnAvatar addTarget:(RENavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnAvatar];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserStorage userIcon]] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    [self requestPhysical];
//    [self.delegate addMenuPanGesture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.delegate removeMenuPanGesture];
}


#pragma mark - internal
- (void)searchAction:(id)sender
{
    _isRequestScanning = YES;
    [SVProgressHUD showWithStatus:@"正在扫描"];
    _mapView.showsUserLocation = YES;
//    [_locationManager startUpdatingLocation];
    _hasLocated = NO;
}

- (void)showMsg
{
    MessageViewController* vc = [[MessageViewController alloc]init];
    vc.title = @"消息";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoBackageViewController
{
    BackpackViewController* backVC = [[BackpackViewController alloc]init];
    [self.navigationController pushViewController:backVC animated:YES];

}

- (void)locationBtnAction
{
    if(_lastLocation.coordinate.latitude > 0){
        if (_locationAnn) {
            [_mapView removeAnnotation:_locationAnn];
        }
        
        _locationAnn = [[MAPointAnnotation alloc] init];
        _locationAnn.coordinate = _lastLocation.coordinate;
        [_mapView addAnnotation:_locationAnn];
        
        [_mapView setCenterCoordinate:_lastLocation.coordinate animated:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CGRect rootRect = CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y + 80, _mapView.frame.size.width, _mapView.frame.size.height - 100);;
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(rootRect, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [CustomAnnotationView offsetToContainRect:frame inRect:rootRect];
            
            CGPoint theCenter = CGPointMake(_mapView.center.x, _mapView.center.y);
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

- (void)saveCoordinate
{
    [self locationBtnAction];
    CoordinateEntity* entity = [[CoordinateEntity alloc]init];
    entity.city_code = [UserStorage citycode];
    entity.lat = _lastLocation.coordinate.latitude;
    entity.lng = _lastLocation.coordinate.longitude;
    
    [UserStorage saveCoordinateEntity:entity];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    if (_hasLocated) {
        return;
    }

    if(!_lastLocation){
        self.lastLocation = userLocation.location;
        
    }else{
        BOOL isEqual = [self CLLocationCoordinateEqual:userLocation.location.coordinate coordinate2:_lastLocation.coordinate];
        if (!isEqual) {
            self.lastLocation = userLocation.location;
        }else{
            if (_isRequestScanning) {
                self.lastLocation = userLocation.location;
            }
        }
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    _mapView.showsUserLocation = NO;
   [SVProgressHUD showErrorWithStatus:@"定位失败"];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        view.enabled = NO;
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor redColor];
        pre.strokeColor = [UIColor redColor];
        pre.image = [UIImage imageNamed:@"img_location"];
        pre.lineWidth = 0;
        pre.showsAccuracyRing = NO;
        [_mapView updateUserLocationRepresentation:pre];
    }
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutOverlay class]]){
        static NSString *poiIdentifier = @"CustomAnnotationViewIdentifier";
        HexagonOverlay* overlay = (HexagonOverlay*)annotation;
//        _annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
//        if (_annotationView == nil)
//        {
//            
//        }
//        _annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        _annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        _annotationView.calloutOffset = CGPointMake(0, 8);
        _annotationView.usersCount = overlay.user_id.count;
        _annotationView.customdelegate = self;
        _annotationView.portrait = nil;
        _annotationView.canShowCallout = NO;
        [_annotationView setSelected:YES];
        _annotationView.title.text = [NSString stringWithFormat:@"目标位置%ld位活动玩家",overlay.user_id.count];
        [self reqestHotspotList:overlay.user_id];
        
        return _annotationView;
    }else if([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *locationReuseIndetifier = @"locationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:locationReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationReuseIndetifier];
        }
        
        annotationView.canShowCallout               = NO;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.image = [UIImage imageNamed:@"img_location"];
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if([overlay isKindOfClass:[AllMACircle class]]){
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth   = 2.f;
        circleRenderer.fillColor   = [[UIColor colorWithHexString:@"#001912"] colorWithAlphaComponent:0.8];
        
        return circleRenderer;
    }else if ([overlay isKindOfClass:[UsersHexOverlay class]]){
        UsersHexOverlay* userOverlay = (UsersHexOverlay*)overlay;
        UsersHexOverlayRenderer *hexagonRenderer = [[UsersHexOverlayRenderer alloc] initWithOverlay:overlay];
        hexagonRenderer.text = userOverlay.text;
        
        hexagonRenderer.lineWidth   = 1.f;
        
        return hexagonRenderer;
    }
    else if ([overlay isKindOfClass:[HexagonOverlay class]])
    {
        HexagonOverlayRenderer *hexagonRenderer = [[HexagonOverlayRenderer alloc] initWithOverlay:overlay];
        
        hexagonRenderer.lineWidth   = 1.f;
        hexagonRenderer.fillColor   = [UIColor clearColor];
        NSInteger hotspot_level = ((HexagonOverlay*)overlay).hotspot_level;
        if (hotspot_level == 3) {
            hexagonRenderer.strokeColor = [[UIColor colorWithHexString:@"#009A70"] colorWithAlphaComponent:0.8];
        }else if (hotspot_level == 2){
            hexagonRenderer.strokeColor = [[UIColor colorWithHexString:@"#009A70"] colorWithAlphaComponent:0.6];
        }else {
            hexagonRenderer.strokeColor = [[UIColor colorWithHexString:@"#009A70"] colorWithAlphaComponent:0.3];
        }
        
        return hexagonRenderer;
    }
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        AMapReGeocode* regeocode = response.regeocode;
        
        NSString* address = @"";
        if (regeocode.addressComponent.city && ![regeocode.addressComponent.city isEqual:@""]) {
            address = [NSString stringWithFormat:@"%@*%@",regeocode.addressComponent.province,regeocode.addressComponent.city];
        }else{
            address = [NSString stringWithFormat:@"%@*%@",regeocode.addressComponent.province,regeocode.addressComponent.district];
        }
        [UserStorage saveCitycode:regeocode.addressComponent.citycode];
        self.lb_geocode.text = address;
    }
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [_search AMapReGoecodeSearch:regeo];
}

#pragma mark - GestureRecognizer

- (MapSelectorGestureRecognizer *)selectorGestureRecognizer {
    MapSelectorGestureRecognizer *selectorGestureRecognizer = [[MapSelectorGestureRecognizer alloc] init];
    
    selectorGestureRecognizer.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:_mapView];
        
        //NSLog(@"_mapView.overlays.count = %d",_mapView.overlays.count);
    };
    selectorGestureRecognizer.touchesMovedCallback = ^(NSSet * touches, UIEvent * event) {
//        if (_popHexagonOverlay) {
//            [_mapView removeAnnotation:_popHexagonOverlay];
//            _popHexagonOverlay = nil;
//            self.selectNum = 0;
//        }
    };
    selectorGestureRecognizer.touchesEndedCallback = ^(NSSet * touches, UIEvent * event) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:_mapView];
//        NSLog(@"touchPoint x = %d y = %d",touchPoint.x, touchPoint.y);
        
        CLLocationCoordinate2D coord = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
        MAMapPoint mapPoint = MAMapPointForCoordinate(coord);
        
        for (int i = 0; i < _mapView.annotations.count; i++) {
            id overlay = [_mapView.annotations objectAtIndex:i];
            if ([overlay isKindOfClass:[CalloutOverlay class]])
            {
                CustomAnnotationView *ann = (CustomAnnotationView*)[_mapView viewForAnnotation:overlay];
                
                CGPoint mPoint = [touch locationInView:ann];
                BOOL inside = [ann pointInside:mPoint withEvent:event];
                if(inside){
                    return ;
                }
            }
        }
        
        for (int i = 0;i<_mapView.overlays.count;i++)
        {
            id overlay = [_mapView.overlays objectAtIndex:i];
            if ([overlay isKindOfClass:[UsersHexOverlay class]])
            {
                UsersHexOverlay *hexOverlay = (UsersHexOverlay*) overlay;
                MAOverlayRenderer* view = [_mapView rendererForOverlay:hexOverlay];
                if ([view isKindOfClass:[UsersHexOverlayRenderer class]])
                {
                    UsersHexOverlayRenderer *rendererView = (UsersHexOverlayRenderer*) view;
                    BOOL isInRect = MAMapRectContainsPoint([rendererView.overlay boundingMapRect], mapPoint);
                    if (isInRect) {
                        MAMapPoint point = [rendererView mapPointForPoint:rendererView.firstPoint];
                        CLLocationCoordinate2D coordinate1 = MACoordinateForMapPoint(point);
                        [self closeAnn];
                        
                        self.popHexagonOverlay = [[CalloutOverlay alloc]initWithCenter:coordinate1 radius:200];
                        _popHexagonOverlay.user_id = hexOverlay.entity.user_id;
                        [_mapView addAnnotation:_popHexagonOverlay];
                        
                        MAAnnotationView *annotation = [_mapView viewForAnnotation:_popHexagonOverlay];
                        
                        [self mapView:_mapView didSelectAnnotationView:annotation];
//                        [_mapView setCenterCoordinate:coordinate1 animated:YES];
                        self.selectNum = i;
                        
//                        NSLog(@"hit!");
                    } else {
//                        NSLog(@"miss!");
                        
                        if (self.selectNum == i) {
                            [self closeAnn];
                        }
                        
                    }
                }
            }
        }
    };
    
    return selectorGestureRecognizer;
}

- (void)avatarInvoked:(id)sender
{
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL) CLLocationCoordinateEqual:(CLLocationCoordinate2D) coordinate1 coordinate2:(CLLocationCoordinate2D) coordinate2 {
    
    return (coordinate1.latitude == coordinate2.latitude) && (coordinate1.longitude == coordinate2.longitude);
}

-(void)closeAnn
{
    if (_popHexagonOverlay) {
        [_mapView removeAnnotation:_popHexagonOverlay];
        _popHexagonOverlay = nil;
        self.selectNum = 0;
//        [_annotationView setSelected:NO];
//        [_annotationView removeFromSuperview];
//        _annotationView = nil;
    }

}

-(void)presentViewController:(UIViewController *)viewControllerToPresent
{
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)popNicknameSetting
{
    self.nicknameSettingbgView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_nicknameSettingbgView];
    
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(8, 154, 304, 138)];
    contentView.backgroundColor = [UIColor blackColor];
    [_nicknameSettingbgView addSubview:contentView];
    
    self.tf_nickname = [[UITextField alloc] initWithFrame:CGRectMake(12, 30,304 - 24, 30)];
    self.tf_nickname.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIColor *color = [UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY];
    self.tf_nickname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的昵称" attributes:@{NSForegroundColorAttributeName:color}];
    [self.tf_nickname setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
    self.tf_nickname.font = [UIFont systemFontOfSize:16];
    self.tf_nickname.adjustsFontSizeToFitWidth = YES;
    self.tf_nickname.textColor = color;
    self.tf_nickname.keyboardType = UIKeyboardTypeDefault;
    self.tf_nickname.keyboardAppearance = UIKeyboardAppearanceDark;
    self.tf_nickname.returnKeyType = UIReturnKeyDone;
    [self.tf_nickname setNormalInputAccessory];
    [contentView addSubview:self.tf_nickname];
    
    [contentView addSubview:[AppUtils addLineWithFrame:CGRectMake(12, 60, 304 - 24, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
    
    self.btn_submit = [[UIButton alloc]initWithFrame:CGRectMake(12, 70,304 - 24,45)];
    [self.btn_submit.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE + 4]];
    [self.btn_submit setTitle:@"提交" forState:UIControlStateNormal];
    UIImage *imageBack = [UIImage imageNamed:@"button_background"];
    imageBack = [imageBack stretchableImageWithLeftCapWidth:floorf(imageBack.size.width/2) topCapHeight:floorf(imageBack.size.height/2)];
    [self.btn_submit setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    [self.btn_submit setBackgroundImage:imageBack forState:UIControlStateNormal];
    [self.btn_submit addTarget:self action:@selector(nicknameSettingAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.btn_submit];
}

- (void)dismissNicknameSetting{
    [self.nicknameSettingbgView removeFromSuperview];
    self.nicknameSettingbgView = nil;
}

- (void)nicknameSettingAction
{
    NSString* nickname = nil;
    if (!_tf_nickname.text) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }else{
        nickname = _tf_nickname.text;
    }
    
    [AccountHandler modifyUserInfoWithNickname:nickname avatarData:@"" userSign:@"NULL" prepare:^{
        
    } success:^(id obj) {
        [UserStorage saveUserNickName:nickname];
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [self dismissNicknameSetting];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

- (void)dealloc{
    [self clearMapView];
    
    [self stopCountDownTimer];
}

#pragma mark - location delegate

- (void)setLastLocation:(CLLocation *)lastLocation
{
//    [_locationManager stopUpdatingLocation];
    _mapView.showsUserLocation = NO;
    
    if (_hasLocated) {
        return;
    }

    _lastLocation = lastLocation;
    _hasLocated = YES;
    if (_isRequestScanning) {
        
        if (_isCanPickupPiece) {
            [self reqestPiece:_lastLocation.coordinate];
        }else{
            [self reqestHotspot:_lastLocation.coordinate];
        }
    }else{
        if (![UserStorage hotspotPolyEntity]){
            _isCanPickupPiece = NO;
            [self reqestHotspot:_lastLocation.coordinate];
        }
        
    }
    [self locationBtnAction];
    [self saveCoordinate];
    [self searchReGeocodeWithCoordinate:lastLocation.coordinate];
}

#pragma mark - UAModalPanelDelegate
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel{
    self.bgColorView.hidden = YES;
}

@end

