//
//  PinLaDefines.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/8.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#ifndef PinLa_IOS_PinLaDefines_h
#define PinLa_IOS_PinLaDefines_h

#define NAVIGATIONBAR_VER_HEIGHT 64

//倒计时时间（秒）
#define MAX_TIMEREMAINING 60

//-------------------------------config file---------------------------
#define DOCUMENT_FOLDER     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define LOGIN_HISTORY_FILE     @"loginHistoryFile.plist"


//-------------------------------通知----------------------------
#define NOTI_ALIPAY_STATE       @"NOTI_ALIPAY_STATE"
#define NOTI_VERSION_UPDATE     @"NOTI_VERSION_UPDATE"      //版本更新通知
#define NOTI_LOGIN_SUCCESS      @"NOTI_LOGIN_SUCCESS"
#define NOTI_LOGOUT             @"NOTI_LOGOUT"
#define NOTI_REFRESH_WITH_SELECTED_TEMPLATE  @"NOTI_REFRESH_WITH_SELECTED_TEMPLATE"
#define NOTI_SYNTHETIC_SUCCESS  @"NOTI_SYNTHETIC_SUCCESS" //合成成功

#define NOTI_TRADE_CONFIRM_SUCCESS             @"NOTI_TRADE_CONFIRM_SUCCESS"
#define NOTI_TRADE_CANCEL_SUCCESS              @"NOTI_TRADE_CANCEL_SUCCESS"
#define NOTI_BACKPACK_RELOAD                   @"NOTI_BACKPACK_RELOAD"

#define NOTI_PICKUP_PIECE_SUCCESS              @"NOTI_PICKUP_PIECE_SUCCESS"
//-------------------------------UI defines----------------------------
#define FONT_SIZE  15

#define FONT_SIZE_CONTENT  13

#define LINE_HEIGHT (1/[UIScreen mainScreen].scale)

//-------------------------------UI color------------------------------
#define COLOR_LINE_GRAY             @"#666666"
#define COLOR_BACKGROUND            @"#f6f6f6"
#define COLOR_BACKGROUND_GRAY       @"#f6f6f6"
#define COLOR_TEXT_GRAY             @"#a6aaa9"
#define COLOR_TEXT_MAIN             @"#1badf8"
#define COLOR_BUTTON_MAIN           @"#ff7736"
#define COLOR_PRICE_ORANGE          @"#ff7736"
#define COLOR_BUTTON_TOUCH          @"#E3E3E3"
#define COLOR_TEXT_DEEP             @"#666666"
#define COLOR_YELLOW_BACKGROUND     @"#F5D328"
#define COLOR_BLUE                  @"#2BFEBB"
#define COLOR_LINE_1                @"#818181"
#define COLOR_MAIN                  @"#00FFB9"

//--------------------color text
#define COLOR_TEXT_LARGER           @"#E6E6E6"

//--------------------color line
#define COLOR_LINE_BLUE             @"#2CFEBB"

//-------------------------------UI layout-------------------------------------
#define MARGIN_LEFT         12
#define MARGIN_RIGHT        12
#define MARGIN_TOP          16
#define MARGIN_BOTTOM       12

//-------------------------------BROKER UI color------------------------------
#define COLOR_TEXT_HARDGRAY         @"#53585F"
#define COLOR_TEXT_LIGHTGRAY        @"#A6AAA9"
#define COLOR_BUTTON_LIGHTGRAY      @"#E3E0E3"
#define COLOR_MAIN_BLUE             @"#1BADF8"
#define COLOR_MAIN_ORANGE           @"#FF7736"

#define COLOR_MAIN_GREEN            @"#00CD95"

//分页加载页数
#define PAGESIZE 20

//-------------------------------文案-------------------------------------
//error信息提示
#define TEXT_NETWORK_ERROR @"网络异常，请检查网络连接"
#define TEXT_SERVER_NOT_RESPOND @"服务器或网络异常,请稍后重试"


//------------------------------DATE FORMATTER-----------------------------------
#define DATE_FORMATTER_DEFAULT      @"yyyy-MM-dd HH:mm"
#define DATE_FORMATTER_ONLYDATE     @"yyyy年MM月dd日"

#define LOCATION_ACCESS_NOTICE              @"请打开系统设置中\"隐私→定位服务\"，允许\"拼啦\"使用您的位置。"

#endif
