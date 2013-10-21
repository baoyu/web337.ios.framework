//
//  ElxStrings.h
//  SDKSample
//
//  Created by elex on 13-9-26.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Elx_STR_lang,
    Elx_STR_login,
    Elx_STR_register,
    Elx_STR_submit,
    Elx_STR_forget,
    Elx_STR_back,
    Elx_STR_p_username,
    Elx_STR_p_password,
    Elx_STR_p_repassword,
    Elx_STR_p_email,
    Elx_STR_ok,
    Elx_STR_required_field_empty,
    Elx_STR_password_dont_match,
    Elx_STR_fblogin,
} ElxStringKey;

@interface ElxStrings : NSObject

+(void)setLang:(NSString *)lang;

+(NSString *)get:(ElxStringKey)key;

@end



