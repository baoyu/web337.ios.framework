//
//  ElxWeb337.h
//  web337
//
//  Created by elex on 13-8-23.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ElxUser.h"
#import "ElxError.h"

/*!
 @typedef
 
 @abstract ElxLoginHandler 登陆或注册方法的回调函数。函数接收两个参数：当登陆\注册成功时，ElxUser为用户信息，ElxError为nil；反之ElxUser为nil,ElxError中包含失败原因。
 */
typedef void (^ElxLoginHandler)(ElxUser *user,ElxError *error);

/*!
 @typedef
 
 @abstract ElxIsLoginHandler 判断是否登陆的回调函数。如果用户登陆，则包含用户信息，否则为nil
 
 @discussion [ElxWeb337 isLogin:] 方法在调用后有可能进行远端的验证，因此是否登陆不能立即返回，需要用回调方式
 */
typedef void (^ElxIsLoginHandler)(ElxUser *user);



/*!
 @class ElxWeb337
 
 @abstract
 ElxWeb337 提供用户登陆、注册的方法
 */
@interface ElxWeb337 : UIView

/*! @abstract 值为YES时会打印日志信息，包括SDK内所有的网络请求 可用来调试 */
@property (assign,nonatomic) BOOL debug;

/*! @abstract 值为YES时打开Facebook登陆的支持 */
@property (assign,nonatomic,setter=setFacebookSupport:) BOOL FacebookSupport;

/*! @abstract 值为YES时打开GameCenter登陆的支持 */
@property (assign,nonatomic,setter=setGameCenterSupport:) BOOL GameCenterSupport;

/*! @abstract referer for analytic */
@property (retain,nonatomic) NSString *referer;
/*!
 @method
 
 @abstract 检查用户登陆的方法
 
 @discussion
 如果用户曾经登陆，则会在回调方法中传入此用户的信息，否则会返回nil。
 此方法会与web.337.com进行一次验证，因此请尽可能早的调用此方法
 
 @param handler 回调方法
 */
-(void)isLogin:(ElxIsLoginHandler)handler;

/*!
 @method
 
 @abstract 返回loginkey
 
 @discussion
 loginkey是337用户登陆的凭证，当用户登陆之后(可能通过login系列方法，或者注册方法)会自动在本地存储loginkey
 如果需要对用户进行二次验证，可从游戏服务器端提交用户的UID和loginkey，具体方法为：
 https://web.337.com/user/mobileucheck?uid={$uid}&loginkey={$loginkey}
 
 需要注意的是，loginkey只在用户为337用户的时候才能够得到。
 如果用户类型为facebook登陆，或gamecenter类型登陆的话。请通过相应方法获得登陆key自行验证
 
 @param handler 回调方法
 */
-(NSString *)loginkey;

/*!
 @method
 @deprecated deprecated in 1.0.1
 @abstract 在当前窗口中显示Login。
 @discussion 这个方法在工作的时候，可能会出现UI布局错误，因此请使用 loginInView 方法
 
 @param handler 回调函数
 */
-(void)login:(ElxLoginHandler)handler;

/*!
 @method
 @abstract 在view中显示登陆窗口
 @discussion 如果在用户已经登陆的情况下继续调用loginInView方法，则不会有效果。你可以通过调用logout方法清除登陆信息或 loginWithUsername:password:callback 来替换新的登陆信息
 
 @param view 添加到的View
 @param handler 回调函数
 */
-(void)loginInView:(UIView *)view callback:(ElxLoginHandler)handler;

/*!
 @method
 @abstract 在view中显示登陆窗口
 @discussion 如果在用户已经登陆的情况下继续调用loginInView方法，则不会有效果。你可以通过调用logout方法清除登陆信息或 loginWithUsername:password:callback 来替换新的登陆信息
 
 @param view 添加到的View
 @param withClose 是否包含关闭按钮
 @param handler 回调函数
 */
-(void)loginInView:(UIView *)view withCloseButton:(BOOL)withClose callback:(ElxLoginHandler)handler;
 
/*!
 @method
 @abstract 后台使用用户名密码进行登陆。成功会返回用户信息，失败返回错误
 
 @param username 用户名
 @param password 密码
 @param handler 回调函数
 */
-(void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(ElxLoginHandler)handler;

/*!
 @method
 @deprecated deprecated in 1.0.1
 @abstract 直接打开注册的方法。
 @discussion 这个方法在工作的时候，可能会出现UI布局错误，因此请使用 openRegisterInView 方法
 
 @param handler 回调函数
 */
-(void)openRegister:(ElxLoginHandler)handler;

/*!
 @method
 @abstract 将注册窗口添加到view上
 
 @param view 目标view
 @param handler 回调函数
 */
-(void)openRegisterInView:(UIView *)view callback:(ElxLoginHandler)handler;

/*!
 @method
 @abstract 将注册窗口添加到view上
 
 @param view 目标view
 @param withClose YES会在窗口上提供关闭按钮，NO则不提供
 @param handler 回调函数
 */
-(void)openRegisterInView:(UIView *)view withCloseButton:(BOOL)withClose callback:(ElxLoginHandler)handler;

/*!
 @method
 @abstract 提供账号，密码，邮件地址进行注册，成功会返回用户信息，失败返回错误
 
 @param username 用户名(仅支持数字和字母)
 @param password 密码
 @param email 邮件地址
 @param handler 回调函数
 */
-(void)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *) email callback:(ElxLoginHandler)handler;
/*!
 @method
 @abstract 登出，同时清除session
 */
-(void)logout;

@end

#define WEB337_IOS_SDK_VERSION @"1.0.4"
