//
//  ElxError.h
//  web337
//
//  Created by elex on 13-8-30.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const CODE_UNKNOWN = @"10000";
/*!
 @class ElxError
 
 @abstract
 ElxError 错误信息
 */
@interface ElxError : NSObject

/*! @abstract 错误码 */
@property (copy,nonatomic) NSString * code;
/*! @abstract 错误信息 */
@property (copy,nonatomic) NSString *message;
/*!
 @method
 
 @abstract web337的错误定义 code+message
 @param code code
 @param message message
 */
+(id)code:(NSString *)code message:(NSString *)message;
/*!
 @method
 
 @abstract 将NSError转化成 web337错误
 @param error error
 */
+(id)fromNSError:(NSError *)error;
/*!
 @method
 
 @abstract 错误描述 
 @return 错误描述
 */
- (NSString *)description;



@end