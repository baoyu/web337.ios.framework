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


/*
 * To use facebook ,just uncomment the follow line
 * Install facebook ios framework, and setup all necessaries
 *
 *
 */
#define SDK_FACEBOOK_ENABLE 1

//To use GameCenter ,just uncomment the follow line, not support yet!
//#define SDK_GAMECENTER_ENABLE 1


typedef void (^ElxLoginHandler)(ElxUser *user,ElxError *error);
typedef void (^ElxIsLoginHandler)(ElxUser *user);

@interface ElxWeb337 : UIView

@property (assign,nonatomic) BOOL FacebookSupport;
@property (assign,nonatomic) BOOL GameCenterSupport;

/*
 * 检查用户登陆的方法:
 * 如果用户曾经登陆，则会在回调方法中传入此用户的信息，否则会返回nil。
 * 此方法会与web.337.com进行一次验证，因此请尽可能早的调用此方法
 */
-(void)isLogin:(ElxIsLoginHandler)handler;

/*
 * 返回loginkey:
 * loginkey是337用户登陆的凭证，当用户登陆之后(可能通过login系列方法，或者注册方法)会自动在本地存储loginkey
 * 如果需要对用户进行二次验证，可从游戏服务器端提交用户的UID和loginkey。
 */
-(NSString *)loginkey;

//在当前窗口中显示Login
-(void)login:(ElxLoginHandler)handler;

//在view中显示登陆窗口
-(void)loginInView:(UIView *)view callback:(ElxLoginHandler)handler;

//提供账号密码进行登录，成功会返回用户信息，失败返回错误
-(void)loginWithUsername:(NSString *)u password:(NSString *)pass callback:(ElxLoginHandler)handler;

//在当前窗口中显示register
-(void)register:(ElxLoginHandler)handler;

//在view中显示登录窗口
-(void)registerInView:(UIView *)view callback:(ElxLoginHandler)handler;

//提供账号，密码，邮件地址进行注册，成功会返回用户信息，失败返回错误
-(void)registerWithUsername:(NSString *)_username password:(NSString *)_password email:(NSString *) _email callback:(ElxLoginHandler)handler;

//登出，同时清除session
-(void)logout;

@end
