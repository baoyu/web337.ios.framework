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

@property (copy,nonatomic) NSString * code;
@property (copy,nonatomic) NSString *message;

//web337的错误定义 code+message
+(id)code:(NSString *)c message:(NSString *)m;
//将NSError转化成 web337错误
+(id)fromNSError:(NSError *)e;

- (NSString *)description;



@end