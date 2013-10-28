//
//  ElxStrings.m
//  SDKSample
//
//  Created by elex on 13-9-26.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import "ElxStrings.h"

@interface ElxStrings ()

@end

 static NSString *String_tw[] =
{
    @"tw",
    @"登入",
    @"免費註冊",
    @"提交",
    @"忘記密碼？",
    @"返回登錄",
    @"帳號",
    @"密碼",
    @"確認密碼",
    @"你的電子郵件",
    @"好的",
    @"請輸入%@",
    @"你的密碼不符.請再試一次。",
    @"使用FACEBOOK登入",
};

 static NSString *String_zh[] =
{
    @"zh",
    @"登录",
    @"注册",
    @"提交",
    @"忘记密码",
    @"返回登录",
    @"用户名",
    @"密码",
    @"确认密码",
    @"邮箱",
    @"好的",
    @"请输入%@",
    @"两次输入密码不一致",
    @"通过FACEBOOK登录",
};

 static NSString *String_en[] =
{
    @"en",
    @"Login",
    @"Sign Up",
    @"Submit",
    @"Forget",
    @"Login",
    @"Username",
    @"Password",
    @"Repassword",
    @"Email",
    @"Ok",
    @"Please input %@",
    @"Password don't match",
    @"Log in with Facebook",
};


typedef enum {
    Elx_Lang_unkonw,
    Elx_Lang_tw,
    Elx_Lang_zh,
    Elx_Lang_en,
} ElxLang;

@implementation ElxStrings

static ElxLang lang = Elx_Lang_unkonw;


+(void)guessLang{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [ElxStrings setLang:language];
}

+(void)setLang:(NSString *)language{
    if([language isEqualToString:@"zh-Hans"]){
        lang = Elx_Lang_zh;
    }else if([language isEqualToString:@"zh-Hant"]){
        lang = Elx_Lang_tw;
    }else{
        lang = Elx_Lang_en;
    }
}


+(NSString *)get:(ElxStringKey)key{    
    if(lang == Elx_Lang_unkonw){
        [ElxStrings guessLang];
    }

    switch (lang) {
        case Elx_Lang_zh:
            return String_zh[key];
            break;
        case Elx_Lang_tw:
            return String_tw[key];
            break;
        default:
            return String_en[key];
            break;
    }
}

@end