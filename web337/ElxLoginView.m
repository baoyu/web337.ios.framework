//
//  ElxLoginView.m
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxLoginView.h"
#import "ElxButton.h"
#import "ElxFBLogin.h"

@interface ElxLoginView()


@property (retain,nonatomic) UITextField *username;
@property (retain,nonatomic) UITextField *password;

@property (retain,nonatomic) ElxButton *loginButton;
@property (retain,nonatomic) ElxButton *regButton;
@property (retain,nonatomic) ElxButton *forgetPass;

@property (retain,nonatomic) ElxFBLogin *fbLogin;
@end




@implementation ElxLoginView

static NSString* const FORGETPASSWORD_URL = @"http://account.337.com/%@/pass/forgetPassword";

@synthesize username = _username;
@synthesize password = _password;

@synthesize loginButton = _loginButton;
@synthesize regButton = _regButton;
@synthesize forgetPass = _forgetPass;
@synthesize fbLogin = _fbLogin;

@synthesize FacebookSupport = _FacebookSupport,GameCenterSupport = _GameCenterSupport;

-(void)dealloc{
    [_fbLogin release];
    [_forgetPass release];
    [_regButton release];
    [_loginButton release];
    [_password release];
    [_username release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        // Initialization code
    }
    return self;
}

-(void)loginButtonClicked:(UIButton*)button{
    if(self.delegate){
        [self.delegate loginButtonClicked:button];
    }
}

-(void)switchFromLoginAndRegister:(UIButton*)button{
    if(self.delegate){
        [self.delegate switchFromLoginAndRegister:button];
    }
}

-(void)facebookLogin:(UIButton*)button{
    if(self.delegate){
        [self.delegate facebookLogin];
    }
}

-(void)forgetPassword:(UIButton*)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:FORGETPASSWORD_URL,[ElxStrings get:Elx_STR_lang] ] ]];
}

-(void)initialize{
    self.username = [self getUITextField:ElxInputCellType_Login_Username];
    self.password = [self getUITextField:ElxInputCellType_Login_Password];
    
    //config loginButton
    ElxButton *loginButton = [ElxButton buttonWithType:UIButtonTypeCustom];
    //title
    [loginButton setTitle:[ElxStrings get:Elx_STR_login]forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[ElxConfig fontBtnPrimary]];
    //color
    [loginButton setBackgroundColor:[ElxConfig colorBtnPrimary]];
    [loginButton setHighlightColor:[ElxConfig colorBtnPrimaryHighlight]];
    
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    //config regButton
    ElxButton *regButton = [ElxButton buttonWithType:UIButtonTypeCustom];
    //title
    [regButton setTitle:[ElxStrings get:Elx_STR_register] forState:UIControlStateNormal];
    [regButton.titleLabel setFont:[ElxConfig fontBtnDefault]];
    [regButton setTitleColor:[ElxConfig colorTitle] forState:UIControlStateNormal];
    
    //color
    [regButton setBackgroundColor:[ElxConfig colorBtnDefault]];
    [regButton setHighlightColor:[ElxConfig colorBtnDefaultHighlight]];
    [regButton addTarget:self action:@selector(switchFromLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *rightArrow =[UIImage imageNamed:@"web337.bundle/337_righta.png"];
    [regButton setImage:rightArrow  forState:UIControlStateNormal];
    [regButton putImageRight:YES];
    
    
    ElxButton *forgetPass = [ElxButton buttonWithType:UIButtonTypeCustom];

    //title,后面留个空格 很好看
    [forgetPass setTitle:[NSString stringWithFormat:@"%@ ",[ElxStrings get:Elx_STR_forget]] forState:UIControlStateNormal];
    [forgetPass setTitleColor:[ElxConfig colorForgetPass] forState:UIControlStateNormal];
    [forgetPass.titleLabel setFont:[ElxConfig fontForgetPass]];
    
    [forgetPass addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *lock =[UIImage imageNamed:@"web337.bundle/337_lock.png"];
    [forgetPass setImage:lock  forState:UIControlStateNormal];
    [forgetPass.titleLabel sizeToFit];
    
    CGSize textSize =[[[forgetPass titleLabel]text]sizeWithFont:[[forgetPass titleLabel] font]];
    
    CGSize imageSize =forgetPass.imageView.image.size;
    float width = imageSize.width + textSize.width + 3;
    CGRect rvFrame = CGRectMake(0, 0, width, INCELL_TEXTFIELD_HEIGHT);
    forgetPass.frame = rvFrame;
    self.password.rightView = forgetPass;
    self.password.rightViewMode = UITextFieldViewModeAlways;
    
    
    
    self.loginButton = [loginButton autorelease];
    self.regButton = [regButton autorelease];
    self.forgetPass = [forgetPass autorelease];
    
    [self addSubview:self.username];
    [self addSubview:self.password];
    
    [self addSubview:self.loginButton];
    [self addSubview:self.regButton];
}





-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait At:(float)top{
    top = [super resizeAndGetHeightInPortrait:inPortrait At:top];
    
    float
    tf_space = TEXTFIELD_SPACE,
    tf_width = self.frame.size.width,
    tf_height = INCELL_TEXTFIELD_HEIGHT;
    
    top += TEXTFIELD_SPACE/2;
    
    
    if(inPortrait){
        //first row
        CGRect rowFrame = CGRectMake(0, top, tf_width, tf_height);
        self.username.frame = CGRectInset(rowFrame, tf_space, tf_space/2);
        top+= tf_height;
        //second row
        rowFrame.origin.y += tf_height;
        self.password.frame = CGRectInset(rowFrame, tf_space, tf_space/2);
        top+= tf_height;
    }else{
        //first row, first colum
        CGRect rowFrame = CGRectMake(0, top, tf_width/2 + tf_space/2, tf_height);
        self.username.frame = CGRectInset(rowFrame, tf_space, tf_space/2);
        //first row, second colum
        rowFrame.origin.x += tf_width/2 - tf_space/2;
        self.password.frame = CGRectInset(rowFrame, tf_space, tf_space/2);
        top+= tf_height;
    }

    float
    width = self.frame.size.width,
    btn_space = TEXTFIELD_SPACE,
    btn_width = (width - btn_space *2),
    btn_height = BUTTON_HEIGHT;
    
    top += TEXTFIELD_SPACE;
    
    self.loginButton.frame = CGRectMake(btn_space, top, btn_width, btn_height);
    top += btn_height;
    
    
    //facebook 登录按钮
    if(self.FacebookSupport){
        //facebook 登录按钮lazy初始化
        if(self.fbLogin == nil){
            ElxFBLogin *fbLogin = [[ElxFBLogin alloc]init];
            [fbLogin.button addTarget:self
                               action:@selector(facebookLogin:)
                     forControlEvents:UIControlEventTouchUpInside];
            self.fbLogin = [fbLogin autorelease];
            [self addSubview:self.fbLogin];
        }
        top += TEXTFIELD_SPACE;
        self.fbLogin.frame = CGRectMake(btn_space, top, btn_width , FACEBOOK_LOGIN_HEIGHT);
        top += FACEBOOK_LOGIN_HEIGHT;
    }else{
        self.fbLogin.frame = CGRectMake(0, 0, 0 , 0);
    }
    
    top += TEXTFIELD_SPACE;
    self.regButton.frame = CGRectMake(0, top, width, btn_height - SECOND_BTN_DECREASE);
    
    top += self.regButton.frame.size.height;
    
    if(inPortrait){
        
    }else{
        
    }
    

    
    [self makeRoundCornerFor:self.regButton];
    
    return top;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
@end
