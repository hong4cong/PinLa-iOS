//
//  APIConfig.h
//  ZLYCARE
//  API信息
//  Created by Ryan on 14-4-14.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************SERVER API***************/

//TEST_SERVER 用来区分 测试网与正式网
#define TEST_SERVER
#ifdef TEST_SERVER
#define SERVER_HOST @"test.interface.pinla.today"
#else
#define SERVER_HOST @"interface.pinla.today"
#endif

//HTTP_PROTOCOL 用来区分 http与https
//#define HTTPS_PROTOCOL
#ifdef HTTPS_PROTOCOL
#define SERVER_PROTOCOL @"https://"
#else
#define SERVER_PROTOCOL @"http://"
#endif
 //INTERNAL_TARGETS 用来区分 企业账号(internal)与公司账号(official) 公司账号用来发布appStroe版本
#ifdef INTERNAL_TARGETS
#define API_CHECK_VERSION @"/iOSVersion-internal.json"
#else
#define API_CHECK_VERSION @"/iOSVersion.json"
#endif

//API VERSION
#define API_VERSION @"/v1"

#define API_LICENCE @"/info/licence.html"


/****************************用户相关******************************/
//软件升级
#define API_IOS_VERSION @"/system/ios_version"

#define API_IOS_LANUNCH @"/system/get_loading_pic"

//用户注册
#define API_USER_REGISTER @"/user/register"

//获取注册验证码
#define API_USER_VERIFY @"/user/verify"

//修改昵称-头像
#define API_USER_MODIFY_USERINFO @"/user/modify_userinfo"

//忘记密码获取手机验证码
#define API_USER_PASSWORD_VERIFY @"/user/password_verify"

//忘记密码提交验证
#define API_USER_PASSWORD_VERIFY_CONFIRM @"/user/password_verify_confirm"

//忘记密码修改密码
#define API_USER_PASSWORD_MODIFY @"/user/password_modify"

//用户登录
#define API_USER_LOGIN @"/user/login"

//用户登出
#define API_USER_LOGOUT @"/user/logout"

//同步背包
#define API_USER_GET_BACKPACK @"/user/get_backpack"

//同步卡包及使用记录
#define API_USER_GET_CARDPACK @"/user/get_cardpack"

//获取用户动态
#define API_USER_GET_DYNAMIC @"/user/get_dynamic"

//关注用户
#define API_USER_FOLLOWER_USER @"/user/follower_user"

//取消关注用户
#define API_USER_UNFOLLOWER_USER @"/user/unfollower_user"

//获取关注用户
#define API_USER_GET_FOLLOWERS @"/user/get_followers"

//反馈
#define API_SYSTEM_FEEDBACK @"/system/feedback"

//根据uuid 获取用户信息
#define API_GET_USERINFO @"/user/get_userinfo"

//上传通讯录
#define API_POST_ASSOCIATE @"/user/associate_user"

//登录验证
#define API_LOGIN_VERiIFY @"/user/login_verify"

//获取用户信息
#define API_GET_MESSAGE @"/user/get_message"

//删除信息
#define API_DELETE_MESSAGE @"/user/del_message"
/****************************热点相关******************************/
//获取周边热点  同时用户和热点一起下来
#define API_HOTSPOT_GET_HOTSPOT @"/hotspot/get_hotspot"
//获取周边热点  同时用户和热点一起下来
#define API_HOTSPOT_GET_HOTSPOT_LIST @"/hotspot/get_hotspot_list"

/****************************碎片相关******************************/
//获取周边热点  同时用户和热点一起下来
#define API_PIECE_GET_PIECE @"/piece/get_piece"

//拾取碎片 请求
#define API_PIECE_GET_PICKUP @"/piece/get_pickup"

//摧毁碎片
#define API_PIECE_DESTROY @"/piece/unpiece"

//摧毁碎片
#define API_PROP_DESTROY @"/piece/unprop"

//合成道具
#define API_PROP_MAKE_PROP @"/prop/make_prop"

//道具换券
#define API_PROP_MAKE_CARD @"/prop/make_card"

//碎片详情
#define API_PIECE_DETAIL @"/piece/get_hold_piece"

/****************************交易相关******************************/
//内购上传记录
#define API_TRADE_BUY_RECORD @"/trade/buy_record"

//获取自己的发起卖交易列表
#define API_TRADE_GET_TRADEINFO_SELL @"/trade/get_me_trade_sell_info"

//获取自己的参与买交易列表
#define API_TRADE_GET_TRADEINFO_BUY @"/trade/get_me_trade_buy_info"

//获取其他用户交易列表
#define API_TRADE_GET_OTHER_TRADEINFO @"/trade/get_other_trade_sell_info"

//获取详细交易信息
#define API_TRADE_GET_BUYINFO @"/trade/get_trade_detail_info"

//机主碎片买单
#define API_TRADE_BUY @"/trade/trade_buy"

//机主碎片买单取消
#define API_TRADE_UNBUY @"/trade/untrade_buy"

//机主碎片卖单
#define API_TRADE_SELL @"/trade/trade_sell"


//机主碎片卖单取消
#define API_TRADE_UNSELL @"/trade/untrade_sell"

//机主碎片卖单确认，拒绝
#define API_TRADE_SELL_CONFIRM @"/trade/trade_sell_confirm"

/****************************内购相关******************************/
//商品列表
#define API_STORE_GOODS_LSIT  @"/store/goods_list"

//购买成功的回调
#define API_STORE_BUY_CONFIRM  @"/store/buy_confirm"


