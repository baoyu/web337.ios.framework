//
//  ElxXA.m
//  web337
//
//  Created by elex on 13-12-6.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxXA.h"
#import "ElxWeb337.h"
#import "OHURLLoader.h"

#define XA_URL @"http://xa.xingcloud.com/v4/web337/123456?action=ios"

@implementation ElxXA

+(void)action:(NSString *)name value:(NSString *)value{
    [ElxXA send:[NSString stringWithFormat:@"%@,%@",name,value ]];
}

+(void)action:(NSString *)name{
    [ElxXA send:[NSString stringWithFormat:@"%@",name]];
}

+(void)send:(NSString *)event{
    NSString *version = [WEB337_IOS_SDK_VERSION stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *targetUrl = [NSString stringWithFormat:@"%@.%@.%@",XA_URL,version,event];
    //NSLog(@"targetUrl: %@",targetUrl);
    NSURL* url = [[NSURL alloc]initWithString:targetUrl];
    NSURLRequest* req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    OHURLLoader* loader = [OHURLLoader URLLoaderWithRequest:req];
    [loader startRequestWithCompletion:nil errorHandler:nil];
    [url autorelease];
    
}


@end