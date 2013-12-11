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

static NSString *String_ko[] =
{
    @"ko",
    @"로그인",//login
    @"회원가입",//signup
    @"확인",//submit
    @"비밀번호 찾기",//forget
    @"돌아가기",//login
    @"아이디",//username
    @"비밀번호",//password
    @"비밀번호 확인",//repassword
    @"이메일",//email
    @"확인",//ok
    @"%@을(를) 입력하세요.",
    @"비밀번호가 일치하지 않습니다.",
    @"페이스북으로 로그인하기",
};

typedef enum {
    Elx_Lang_unkonw,
    Elx_Lang_tw,
    Elx_Lang_zh,
    Elx_Lang_ko,
    Elx_Lang_en,
} ElxLang;

@implementation ElxStrings

static ElxLang lang = Elx_Lang_unkonw;


+(void)guessLang{
    NSArray *langs = [NSLocale preferredLanguages];
    if([langs count] == 0){
        return [ElxStrings setLang:@"en"];
    }else{
        NSString * language = [langs objectAtIndex:0];
        return [ElxStrings setLang:language];
    }    
}

+(void)setLang:(NSString *)language{
    if([language isEqualToString:@"zh-Hans"]){
        lang = Elx_Lang_zh;
    }else if([language isEqualToString:@"zh-Hant"]){
        lang = Elx_Lang_tw;
    }else if([language isEqualToString:@"ko"]){
        lang = Elx_Lang_ko;
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
        case Elx_Lang_ko:
            return String_ko[key];
            break;
        default:
            return String_en[key];
            break;
    }
}

@end