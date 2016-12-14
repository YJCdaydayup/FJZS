//
//  StringConstants.h
//  RenRenApp
//
//  Created by RichyLeo on 15/8/31.
//  Copyright (c) 2015年 RL. All rights reserved.
//

#ifndef RenRenApp_StringConstants_h
#define RenRenApp_StringConstants_h

// 导航条的高度
#define NAV_BAR_HEIGHT  64
// Tabbar的高度
#define TABBAR_HEIGHT   49

/**
 *  当前的App版本
 */
#define kAppVersion (1.0)

/**
 *  当前系统版本
 */
#define kSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

/**
 *  当前屏幕大小
 */
#define kScreenBounds ([[UIScreen mainScreen] bounds])
// 获取屏幕的宽高
#define Wscreen   [UIScreen mainScreen].bounds.size.width
#define Hscreen   [UIScreen mainScreen].bounds.size.height

//App代理类
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

//获取导航条和tabbar的高度
#define statusHeights   [[UIApplication sharedApplication] statusBarFrame].size.height
#define navigationHeight  self.navigationController.navigationBar.frame.size.height


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/**
 *  第一次启动App的Key
 */
#define kAppFirstLoadKey @"kAppFirstLoadKey"

/**
 *  持久化定义
 */
#define KUSERDEFAUL [NSUserDefaults standardUserDefaults]

/**
 *  调试模式的标签
 */
#define DEBUG_FLAG

// RGB色值
#define RGB_COLOR(r, g, b, al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]

// 获取设备版本
#define IOS_7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0

/**
 *  如果是调试模式，QFLog就和NSLog一样，如果不是调试模式，QFLog就什么都不做
 *  __VA_ARGS__ 表示见面...的参数列表
 */
#ifdef DEBUG_FLAG
#define QFLog(fmt, ...) NSLog(fmt, __VA_ARGS__)
#else
#define QFLog(fmt, ...)
#endif

#endif
