//
//  ElxUser.h
//  web337
//
//  Created by elex on 13-8-23.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @typedef ElxUserType enum
 
 @abstract
 用户类型定义
 
 @discussion
 用户可能通过登陆页面从多个渠道完成登陆信息， 可以通过ElxUser.type来判断具体渠道
 */
typedef enum {
    /*! 未知类型 或程序bug造成的 未设定值 */
    ElxUser_UNKNOWN,
    /*! 337官网用户 */
    ElxUser_337,
    /*! facebook登录用户 */
    ElxUser_FACEBOOK,
} ElxUserType;

/*!
 @class ElxUser
 
 @abstract
 ElxUser 用户结构
 */
@interface ElxUser : NSObject

/*! @abstract uid */
@property (copy,nonatomic) NSString *uid;
/*! @abstract same as uid */
@property (copy,nonatomic) NSString *identify_id;
/*! @abstract username, 如果不是337用户则没有此信息 */
@property (copy,nonatomic) NSString *username;
/*! @abstract nickname */
@property (copy,nonatomic) NSString *nickname;
/*! @abstract gender */
@property (copy,nonatomic) NSString *gender;
/*! @abstract birthday */
@property (copy,nonatomic) NSString *birthday;
/*! @abstract avatar */
@property (copy,nonatomic) NSString *avatar;
/*! @abstract language */
@property (copy,nonatomic) NSString *language;
/*! @abstract loginkey  @discussion 337用户登陆之后会有loginkey，可与337服务器端进行登录验证 */
@property (copy,nonatomic) NSString *loginkey;
/*! @abstract email */
@property (copy,nonatomic) NSString *email;
/*! @abstract email address is verified 1->YES, 0->NO */
@property (copy,nonatomic) NSString *emailverify;

/*! @abstract country */
@property (copy,nonatomic) NSString *country;
/*! @abstract phone */
@property (copy,nonatomic) NSString *phone;
/*! @abstract fromgame */
@property (copy,nonatomic) NSString *fromgame;

/*! @abstract vip level */
@property (copy,nonatomic) NSString *level;
/*! @abstract 是否vip */
@property (assign,nonatomic) int vip;
/*! @abstract vip过期时间 */
@property (assign,nonatomic) int vipendtime;
/*! @abstract 用户类型 @see ElxUserType  */
@property (assign,nonatomic) ElxUserType type;

-(id)initWithDict:(NSDictionary*)dict;
@end
