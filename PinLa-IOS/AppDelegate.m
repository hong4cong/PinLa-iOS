//
//  AppDelegate.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/2.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "MenuViewController.h"
#import "RENavigationController.h"
#import "MainViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <XGPush/XGPush.h>
#import <XGPush/XGSetting.h>
#import "LoginViewController.h"
#import "AddressBookViewController.h"
#import "UserStorage.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "UpdateHandler.h"
#import "VersionEntity.h"
#import "ZWIntroductionViewController.h"
#import <UIImageView+WebCache.h>
#import "VerifyPhoneNumberViewController.h"
#import "LoadingEntity.h"

@interface AppDelegate ()<REFrostedViewControllerDelegate,ZWIntroductionViewControllerDelegate>

@property (strong, nonatomic) UIImageView *lunchView;
@property (nonatomic, assign) BOOL  isShowPic;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //设置导航栏和状态栏背景色
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    //设置navigationbar上返回按钮和barbutton的字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置navigationbar标题的字体和颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:18.0], NSFontAttributeName, nil]];
    [UINavigationBar appearance].shadowImage = [UIImage imageWithColor:[UIColor redColor] andSize:CGSizeMake(0.5f, 0.5f)];
    
    //设置statusBar为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //友盟
    [MobClick startWithAppkey:@"555985e9e0f55acf68003002" reportPolicy:BATCH channelId:nil];
    
    [MAMapServices sharedServices].apiKey = @"f5eaba3700f42bd6b2763e547d1a187f";
    [ShareSDK registerApp:@"789ab91a8af4"];
    
    [self initializePlatShareWithOptions:launchOptions];
    [self initializePlatXGWithOptions:launchOptions];
    //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc] init]];
    //    self.window.rootViewController = nav;
    if (![UserStorage isFirstLogin]) {
        NSArray *arr = @[@"page_one",@"page_two", @"page_three",@"page_four"];
        NSArray *arr_bg = nil;
        
        ZWIntroductionViewController *vc_zw = [[ZWIntroductionViewController alloc]initWithCoverImageNames:arr backgroundImageNames:arr_bg];
        if ([UserStorage isLogin]) {
            [vc_zw.view addSubview:vc_zw.btn_experience];
            [vc_zw.btn_login removeFromSuperview];
            [vc_zw.btn_register removeFromSuperview];
        }else{
            [vc_zw.view addSubview:vc_zw.btn_login];
            [vc_zw.view addSubview:vc_zw.btn_register];
            [vc_zw.btn_experience removeFromSuperview];
        }
        vc_zw.delegate = self;
        self.window.rootViewController = vc_zw;
    }else{
        [self setViewForApp];
    }
    [self initLaunchScreen];

    return YES;
}

- (void)initLaunchScreen
{
    _lunchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height)];
    
    _lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:_lunchView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:_lunchView.frame];
    _lunchView.image = [UIImage imageNamed:@"img_launch"];
    [_lunchView addSubview:imageV];
    imageV.backgroundColor = [UIColor clearColor];
    [self.window bringSubviewToFront:_lunchView];
    _isShowPic = NO;
    [self performSelector:@selector(stopLoadingPic) withObject:nil afterDelay:0.5];
    [UpdateHandler getLanunchPicWithType:2 Prepare:^{
        
    } Success:^(NSArray* obj) {
        
        if (obj.count) {
            LoadingEntity * data = [obj firstObject];
            [imageV sd_setImageWithURL:[NSURL URLWithString:data.pic_url] placeholderImage:[UIImage imageNamed:@"img_launch"]];
            if (data.carousel_time && ![data.carousel_time isEqualToString:@""]) {
                _isShowPic = YES;
                [NSTimer scheduledTimerWithTimeInterval:[data.carousel_time doubleValue] target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
            }else{
                _isShowPic = NO;
                [self removeLun];
            }
        }
    } failed:^(NSInteger statusCode, id json) {
        _isShowPic = NO;
    }];
}

- (void)stopLoadingPic
{
    if (!_isShowPic) {
        [self removeLun];
    }
}

-(void)removeLun
{
    [_lunchView removeFromSuperview];
}

- (void)setRootView{
    [self setViewForApp];
    [UserStorage saveFirstLoginStatus:YES];
}

- (void)setViewForApp{
    RENavigationController *navigationController = nil;
    MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    [UserStorage saveSwithStatus:NO];
    if (![UserStorage isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        navigationController = [[RENavigationController alloc] initWithRootViewController:vc];
        vc.delegate = navigationController;
    }else{
        MainViewController *vc = [[MainViewController alloc] init];
        navigationController = [[RENavigationController alloc] initWithRootViewController:vc];
        vc.delegate = navigationController;
    }
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.blurTintColor = [UIColor blackColor];
    frostedViewController.menuViewSize = CGSizeMake(230, 0);
    frostedViewController.limitMenuViewSize = YES;
    frostedViewController.delegate = self;
    //    frostedViewController.panGestureEnabled = NO;
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    
    [self checkNewVersion];
}

- (void)goToLoginView{
    [UserStorage saveFirstLoginStatus:YES];
    [self setViewForApp];
}

- (void)goToRegisterView{
    [UserStorage saveFirstLoginStatus:YES];
    RENavigationController *navigationController = nil;
    MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    [UserStorage saveSwithStatus:NO];
    VerifyPhoneNumberViewController *vc = [[VerifyPhoneNumberViewController alloc] init];
    vc.isFirstView = YES;
    vc.type = REGISTER;
    navigationController = [[RENavigationController alloc] initWithRootViewController:vc];
    vc.delegate = navigationController;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.blurTintColor = [UIColor blackColor];
    frostedViewController.menuViewSize = CGSizeMake(230, 0);
    frostedViewController.limitMenuViewSize = YES;
    frostedViewController.delegate = self;
    //    frostedViewController.panGestureEnabled = NO;
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
}

- (void)initializePlatXGWithOptions:(NSDictionary *)launchOptions{
    
    // 信鸽
    
    //    fixed me 信鸽关联
    [XGPush startApp:2200109642 appKey:@"IJL97AP29R3R"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        NSLog(@"asasasasasasas");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];

}

- (void)initializePlatShareWithOptions:(NSDictionary *)launchOptions{
    //初始化新浪，在新浪微博开放平台上申请应用
//    [ShareSDK connectSinaWeiboWithAppKey:@"2871458136" appSecret:@"9377d7491a24d1dfe767273ffd118ca1" redirectUri:@"http://www.baidu.com" weiboSDKCls:[WeiboSDK class]];
    //上面的方法会又客户端跳客户端，没客户端条web.
    //初始化微信，微信开放平台上注册应用
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    //    //连接QQ应用
    //    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    //连接QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"1104473583"
                           appSecret:@"nfjjPHPuGo7IEUcp"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark 信鸽

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //    //删除推送列表中的这一条
    //    [XGPush delLocalNotification:notification];
    //    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    UIUserNotificationType allowedTypes = [notificationSettings types];
    DLog(@"%lu",allowedTypes);
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
//        UIAlertView *alertField = [[UIAlertView alloc]initWithTitle:@"获取设备信息失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertField show];
    };
    
    //设置推送账号
    if([UserStorage userId] && ![[UserStorage userId] isEqual:@""]){
        [XGPush setAccount:[NSString stringWithFormat:@"%@",[UserStorage userId]]];
    }
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    NSString *aaa = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"aaaaaaaa  ===   %@",aaa);
    
    //回调版本示例
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
        NSLog(@"收到消息");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //完成之后的处理,打开app时调用
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)checkNewVersion
{
    /**
     *  检测新版本
     */
    [UpdateHandler checkAppVersionWithPrepare:^{
        
    } Success:^(id obj) {
        VersionEntity* baseEntity = (VersionEntity*)obj;
        NSString *localVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleVersion"];
        
        if ([localVersion intValue] < [baseEntity.minCode intValue]) {
            //需要强制升级
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                            message:baseEntity.desc
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"升级", nil];
            alert.tag = 1001;
            [alert show];
        }else{
            //选择升级
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                            message:baseEntity.desc
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"升级", nil];
            alert.tag = 1002;
            [alert show];
        }
        
        //升级服务URL
//        self.str_updateURL = baseEntity.updateURL;
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString*)json];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//#if INTERNAL_TARGETS
//    //企业版升级链接
//    NSString *updateURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.str_updateURL];
//#else
    //AppStore升级链接
    NSString *updateURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"992327623"];
//#endif
    
    DLog(@"Update URL:%@",updateURL);
    if(alertView.tag == 1001){
        //强制升级
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
    }else{
        //选择升级
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
        }
    }
}

#pragma mark - REFrostedViewControllerDelegate
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didHideMenuViewController");
}

@end
