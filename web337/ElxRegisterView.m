//
//  ElxRegisterView.m
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxRegisterView.h"
#import "ElxButton.h"

@interface ElxRegisterView()

@property (retain,nonatomic) UITextField *username;
@property (retain,nonatomic) UITextField *email;
@property (retain,nonatomic) UITextField *password;
@property (retain,nonatomic) UITextField *repassword;

@property (retain,nonatomic) ElxButton *submitButton;
@property (retain,nonatomic) ElxButton *backToLogin;

@end

@implementation ElxRegisterView

@synthesize username = _username;
@synthesize email = _email;
@synthesize password = _password;
@synthesize repassword = _repassword;

@synthesize submitButton = _submitButton;
@synthesize backToLogin = _backToLogin;


-(void)dealloc{
    [_backToLogin release];
    [_submitButton release];
    [_repassword release];
    [_password release];
    [_email release];
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


-(void)regButtonClicked:(UIButton*)button{
    if(self.delegate){
        [self.delegate regButtonClicked:button];
    }
}

-(void)switchFromLoginAndRegister:(UIButton*)button{
    if(self.delegate){
        [self.delegate switchFromLoginAndRegister:button];
    }
}

-(void)initialize{
    self.username = [self getUITextField:ElxInputCellType_Reg_Username];
    self.email = [self getUITextField:ElxInputCellType_Reg_Email];
    self.password = [self getUITextField:ElxInputCellType_Reg_Password];
    self.repassword = [self getUITextField:ElxInputCellType_Reg_RePassword];
    
    
    //注册
    ElxButton *submitButton = [ElxButton buttonWithType:UIButtonTypeCustom];
    
    [submitButton setTitle:[ElxStrings get:Elx_STR_submit] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[ElxConfig fontBtnPrimary]];
    
    [submitButton setBackgroundColor:[ElxConfig colorBtnPrimary]];
    [submitButton setHighlightColor:[ElxConfig colorBtnPrimaryHighlight]];
    [submitButton addTarget:self
                     action:@selector(regButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside
     ];
    self.submitButton = [submitButton autorelease];
    
    
    //config regButton
    ElxButton *backToLogin = [ElxButton buttonWithType:UIButtonTypeCustom];
    
    //title
    [backToLogin setTitle:[ElxStrings get:Elx_STR_back] forState:UIControlStateNormal];
    [backToLogin.titleLabel setFont:[ElxConfig fontBtnDefault]];
    [backToLogin setTitleColor:[ElxConfig colorTitle] forState:UIControlStateNormal];
    
    //color
    [backToLogin setBackgroundColor:[ElxConfig colorBtnDefault]];
    [backToLogin setHighlightColor:[ElxConfig colorBtnDefaultHighlight]];
    [backToLogin addTarget:self action:@selector(switchFromLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *lock =[UIImage imageNamed:@"web337.bundle/337_lefta.png"];
    [backToLogin setImage:lock  forState:UIControlStateNormal];
    [backToLogin putImageRight:NO];
    self.backToLogin = [backToLogin autorelease];
    
    
    [self addSubview:self.username];
    [self addSubview:self.email];
    [self addSubview:self.password];
    [self addSubview:self.repassword];
    
    [self addSubview:self.submitButton];
    [self addSubview:self.backToLogin];
}


-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait At:(float)top{
    top = [super resizeAndGetHeightInPortrait:inPortrait At:top];
    
    float
    tf_space = TEXTFIELD_SPACE,
    tf_width = self.frame.size.width - tf_space*2,
    tf_height = INCELL_TEXTFIELD_HEIGHT - tf_space;
    
    //top += tf_space;
    
    
    if(inPortrait){
        //first row
        top += tf_space;
        self.username.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        top+= tf_height;
        
        //second row
        top += tf_space;
        self.email.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        top+= tf_height;
        
        //third row
        top += tf_space;
        self.password.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        top+= tf_height;
        
        //fourth row
        top += tf_space;
        self.repassword.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        top+= tf_height;
        
    }else{
        tf_width = (self.frame.size.width - tf_space*3)/2;
        
        self.username.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        self.email.frame = CGRectMake(tf_space + tf_width + tf_space, top, tf_width, tf_height);
        top+= tf_height;
     
        top += tf_space;
        self.password.frame = CGRectMake(tf_space, top, tf_width, tf_height);
        self.repassword.frame = CGRectMake(tf_space + tf_width + tf_space, top, tf_width, tf_height);
        top+= tf_height;
    }
    
    float
    
    width = self.frame.size.width,
    btn_space = TEXTFIELD_SPACE,
    btn_width = (width - btn_space *2),
    btn_height = BUTTON_HEIGHT;
    
    top += TEXTFIELD_SPACE;
    
    self.submitButton.frame = CGRectMake(btn_space, top, btn_width, btn_height);
    top += btn_height;
    
    top += TEXTFIELD_SPACE;
    self.backToLogin.frame = CGRectMake(0, top, width, btn_height - SECOND_BTN_DECREASE);
    
    top += self.backToLogin.frame.size.height;
    
    [self makeRoundCornerFor:self.backToLogin];
    
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
