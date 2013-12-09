//
//  ElxXA.h
//  web337
//
//  Created by elex on 13-12-6.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElxXA : NSObject

/*!
 @method
 @abstract 给行云打log
 
 @param name 事件名称
 @param value 事件值
 */
+(void)action:(NSString *)name value:(NSString *)value;

+(void)action:(NSString *)name;

@end
