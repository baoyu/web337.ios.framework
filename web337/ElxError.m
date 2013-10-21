//
//  ElxError.m
//  web337
//
//  Created by elex on 13-8-30.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import "ElxError.h"

@implementation ElxError

const int NS_ERROR_CODE_BASE = 10000;
const int NS_ERROR_CODE_CANCEL = 0;
@synthesize code = _code;
@synthesize message = _message;

+(id)code:(NSString *)c message:(NSString *)m{
    return [[ElxError alloc]initWithCode:c message:m];
    //return [[[ElxError alloc]initWithCode:c message:m]autorelease];
}

+(id)fromNSError:(NSError *)e{
    return [[ElxError alloc] initwithNSError:e];
//    return [[[ElxError alloc] initwithNSError:e]autorelease];
}


-(id)initWithCode:(NSString *)c message:(NSString *)m {
    if (self = [super init]) {
        _code = (c==nil)?CODE_UNKNOWN:c;
        _message = (m==nil)?[NSString stringWithFormat:@"Unknown error with code %@",_code]:m;
        return self;
    }
    return nil;
}

-(id)initwithNSError:(NSError *)e {
    if (self = [super init]) {
        _code = [NSString stringWithFormat:@"%ld",NS_ERROR_CODE_BASE + (long)e.code];
        _message = [e localizedDescription];
        return self;
    }
    return nil;
    
    
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Code:%@ Message:%@", self.code, self.message];
}

-(void)dealloc {
    [_code release];
    [_message release];
    [super dealloc];
}

@end
