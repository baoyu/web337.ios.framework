//
//  ElxUser.h
//  web337
//
//  Created by elex on 13-8-23.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ElxUser_UNKNOWN,
    ElxUser_337, //默认类型 337官网用户
    ElxUser_FACEBOOK,//facebook登录用户
    ElxUser_FACEBOOK337,//表示facebook登录用户，同时授权了游戏app和337app. 目前只要用于占位
    ElxUser_GAMECENTER,//ios gamecenter用户
} ElxUserType;

@interface ElxUser : NSObject
//uid
@property (copy,nonatomic) NSString *uid;
@property (copy,nonatomic) NSString *identify_id;
//username
@property (copy,nonatomic) NSString *username;
//display name
@property (copy,nonatomic) NSString *nickname;
@property (copy,nonatomic) NSString *gender;
@property (copy,nonatomic) NSString *birthday;
@property (copy,nonatomic) NSString *avatar;

@property (copy,nonatomic) NSString *language;
@property (copy,nonatomic) NSString *loginkey;

@property (copy,nonatomic) NSString *email;
//email address is verified 1->YES, 0->NO
@property (copy,nonatomic) NSString *emailverify;

@property (copy,nonatomic) NSString *country;
@property (copy,nonatomic) NSString *phone;
@property (copy,nonatomic) NSString *fromgame;
//vip相关
@property (copy,nonatomic) NSString *level;
@property (assign,nonatomic) int vip;
@property (assign,nonatomic) int vipendtime;
//用户类型
@property (assign,nonatomic) ElxUserType type;

-(id)initWithDict:(NSDictionary*)dict;
@end
