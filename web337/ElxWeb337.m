//
//  ElxWeb337.m
//  web337
//
//  Created by elex on 13-8-23.
//  Copyright (c) 2013年 elex. All rights reserved.
//

//keep
#import "ElxWeb337.h"
#import "ElxUser.h"
#import "ElxButton.h"
#import "ElxConfig.h"
#import "ElxFBLogin.h"

#import "ElxLoginView.h"
#import "ElxRegisterView.h"


//all dependencies
#import "ElxStrings.h"
#import "SZJsonParser.h"
#import "OHURLLoader.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

//weak link to Facebook
#ifdef SDK_FACEBOOK_ENABLE
//
#endif


//weak link to GameCenter
#ifdef SDK_GAMECENTER_ENABLE
#import <GameKit/GameKit.h>
#endif




static NSString* const HTTP = @"http";
static NSString* const HOST_WEB = @"web.337.com";
static NSString* const URL_LOGIN = @"/user/mobilelogin";
static NSString* const URL_REG = @"/user/mobileregister";
static NSString* const URL_CHECKLOGIN = @"/user/mobileucheck";



static NSString* const ELEX_337_UID_PREFIX = @"elex337_";
static NSString* const ELEX_337_UID = @"uid";
//用来指示当前用户的类型
static NSString* const ELEX_337_TYPE = @"type";
//337用户的登录信息，如果账号没有连接337将不会有loginkey
static NSString* const ELEX_337_LOGINKEY = @"loginkey";
static NSString* const ELEX_337_SESSION = @"elex_337_session";

typedef enum {
    ElxViewType_Login,
    ElxViewType_Register,
} ElxViewType;

typedef void (^ElxHttpSuccess)(NSObject *response,int httpStatusCode);
typedef void (^ElxHttpError)(ElxError *error);

@interface ElxWeb337()<MBProgressHUDDelegate,ElxViewEventDelegate>

@property (strong,nonatomic) ElxLoginHandler loginHandler;

@property (retain,nonatomic) UIView *main;

@property (retain,nonatomic) ElxBaseView *currentView;
@property (retain,nonatomic) ElxLoginView *loginView;
@property (retain,nonatomic) ElxRegisterView *registerView;

@property (retain, nonatomic) ElxUser * user;
@property (retain, nonatomic) MBProgressHUD * HUD;

@property (assign,nonatomic) ElxViewType type;

@property (assign,nonatomic) BOOL withCloseButton;

@property (assign,nonatomic) BOOL elementUp;

@end




@implementation ElxWeb337

BOOL inPortrait = YES;
BOOL localUserSetted = NO;

@synthesize loginHandler = _loginHandler;
@synthesize user = _user;
@synthesize type = _type;

@synthesize main = _main;

@synthesize loginView = _loginView;
@synthesize registerView = _registerView;
@synthesize HUD = _HUD;

@synthesize FacebookSupport = _FacebookSupport,GameCenterSupport = _GameCenterSupport;
@synthesize withCloseButton,elementUp;


#pragma mark - 第三方登录 Support
- (void)setFacebookSupport:(BOOL)s {
    NSLog(@"set Facebook Support! %d",s);
    _FacebookSupport = s;
    if(self.loginView){
        self.loginView.FacebookSupport = self.FacebookSupport;
    }
}

- (void)setGameCenterSupport:(BOOL)s {
    _GameCenterSupport = s;
    if(self.loginView){
        self.loginView.GameCenterSupport = self.GameCenterSupport;
    }
}

typedef void (^ThirdPartyCompleteHandler)(NSDictionary *obj, NSError *error);

#pragma mark - Facebook Login Support
//facebook related functions and definations:
static NSString *const FBPLISTDefaultReadPermissions = @"FacebookDefaultReadPermissions";
/**
 * 打开facebook授权时候 默认的权限设置是 basic_info,email .
 * 如果你想要自定义权限，可以在plist中设置 “FacebookDefaultReadPermissions”为类似“basic_info,email”字符串
 */
-(NSArray *)getFacebookReadPermissions{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *permission = [bundle objectForInfoDictionaryKey:FBPLISTDefaultReadPermissions];
    if(permission){
        return [permission componentsSeparatedByString: @","];
    }else{
        return @[@"basic_info",@"email"];
    }
}

/**
 * 取facebook用户资料
 *
 */
-(void)getFacebookUser:(ThirdPartyCompleteHandler)handler{
    Class FBSession = NSClassFromString(@"FBSession");
    Class FBRequest = NSClassFromString(@"FBRequest");
    
    if(!FBSession){
        return handler(nil,nil);
    }
    
    if ([[FBSession activeSession] isOpen] ) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(NSObject *connection, NSDictionary<NSObject> *user, NSError *error) {
             if (error) {
                 return handler(nil,error);
             }
             NSString *uid = [user objectForKey:@"id"];
             NSString *name = [user objectForKey:@"name"];
             NSString *email = [user objectForKey:@"email"];
             //解析结果
             NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:
                                  uid,@"uid",
                                  uid,@"identify_id",
                                  (name?name:@""),@"nickname",
                                  (email?email:@""),@"email",
                                  [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",uid],@"avatar",
                                  [NSNumber numberWithInt:ElxUser_FACEBOOK], ELEX_337_TYPE,
                                  nil];
             handler(obj,nil);
         }];
    }else{
        //
        handler(nil,nil);
    }
}

/**
 * facebook用户登录
 *
 */
-(void)facebookLogin{
    Class FBSession = NSClassFromString(@"FBSession");
    if(FBSession){
        
        //show hud
        self.HUD = [MBProgressHUD showHUDAddedTo:self.currentView animated:YES];
        self.HUD.delegate = self;
        
        [FBSession openActiveSessionWithReadPermissions:[self getFacebookReadPermissions]
                                           allowLoginUI:YES
                                      completionHandler: ^(NSObject *session,
                                                           int *status,
                                                           NSError *error) {
                                          if(error){
                                              //尝试重复登陆
                                              self.HUD.mode = MBProgressHUDModeText;
                                              self.HUD.detailsLabelText= [error localizedDescription];
                                              [self.HUD hide:YES afterDelay:3];
                                              return;
                                          }
                                          [self getFacebookUser:^(NSDictionary *obj, NSError *error){
                                              if(obj){
                                                  [self saveSession:obj];
                                                  self.loginHandler(self.user,nil);
                                                  [self.HUD hide:YES];
                                                  [self fadeOut];
                                              }else{
                                                  //尝试重复登陆
                                                  self.HUD.mode = MBProgressHUDModeText;
                                                  self.HUD.detailsLabelText= [error localizedDescription];
                                                  [self.HUD hide:YES afterDelay:3];
                                              }
                                          }];
                                      }];
        
    }
    
}
/*是否facebook用户登陆过
 *
 */
-(BOOL) hasFacebookLogin {
    Class FBSession = NSClassFromString(@"FBSession");
    if(FBSession){
        return (BOOL)[FBSession openActiveSessionWithReadPermissions:[self getFacebookReadPermissions] allowLoginUI:NO completionHandler:nil];
    }else{
        return NO;
    }
    
}

#pragma mark - GameCenter Login Support


#ifdef SDK_GAMECENTER_ENABLE
/**
 * 取gamecenter用户资料
 *
 */
-(NSDictionary *)getGameCenterUser{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if(localPlayer.authenticated){
        //解析结果
        return [NSDictionary dictionaryWithObjectsAndKeys:
                localPlayer.playerID,@"uid",
                localPlayer.playerID,@"identify_id",
                localPlayer.alias,@"nickname",
                [NSNumber numberWithInt:ElxUser_GAMECENTER], ELEX_337_TYPE,
                nil];
    }else{
        return nil;
    }
}

-(void)gameCenterLogin{
    
}
#endif


#pragma mark - initialization & cleaning up
- (id)init{
    NSLog(@"web337 sdk last modified date %lld",(long long)WEB337_SDK_LASTMODIFIED);
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    UIInterfaceOrientation _cOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(_cOrientation)) {
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    }
    
    //外部库加载策略
    

    if (self = [super initWithFrame:rect]) {
        
        //灰色遮罩
        self.backgroundColor = [ElxConfig colorMask];
        
        
        
        UIView *mainView = [[UIView alloc]initWithFrame:[self contentRectBy:rect]];
        
        mainView.backgroundColor = [ElxConfig colorBackground];
        mainView.layer.cornerRadius = RADIUS;
        
        self.main = [mainView autorelease];
        [self addSubview:self.main];
        
        CGRect viewFrame = CGRectMake(0, 0, self.main.frame.size.width, self.main.frame.size.height);
        
        ElxLoginView *loginView =[[ElxLoginView alloc]initWithFrame:viewFrame];
        ElxRegisterView *registerView =[[ElxRegisterView alloc]initWithFrame:viewFrame];
        
        self.loginView =  [loginView autorelease];
        self.registerView = [registerView autorelease];
        
        self.loginView.delegate = self;
        self.registerView.delegate = self;
        
    }
    
    //facebook
    if(NSClassFromString(@"FBSession")){
        self.FacebookSupport = YES;
    }else{
        self.FacebookSupport = NO;
    }
    
    //game center
    if(NO){
        self.GameCenterSupport = YES;
    }else{
        self.GameCenterSupport = NO;
    }
    
    
    return self;
}




-(void)dealloc {
    [_loginHandler release];
    [_user release];
    [_loginView release];
    [_registerView release];
    [_main release];
    [super dealloc];
}

#pragma mark - public methods implements
-(void)isLogin:(ElxIsLoginHandler)handler{
    //如果已经设置过用户，无论有或者无
    if(localUserSetted){
        handler(self.user);
        return;
    }
    
    NSDictionary *session = [self getSession];
    
    if(!session){
        handler(nil);
        return;
    }
    
    ElxUserType type = [[session objectForKey:ELEX_337_TYPE] intValue];
    
    if(type == ElxUser_FACEBOOK && self.FacebookSupport){
        //do with facebook
        BOOL success = [self hasFacebookLogin];
        if (success) {
            [self getFacebookUser:^(NSDictionary *obj, NSError *error){
                [self saveSession:obj];
                //saveSession will also save user
                handler(self.user);
            }];
        }else{
            handler(nil);
        }
        return;
    }
    
    
    //TODO 检查 session 类型，
    
    [self requestApi:URL_CHECKLOGIN withParam:session onSuccess:^(NSObject *response, int code) {
        if (code == 200) {
            NSObject *rsp = [SZJsonParser parseString:(NSString *) response];// obj will be an array or a dictionary
            NSDictionary *obj = nil;
            if([rsp respondsToSelector:@selector(objectForKey:)]){
                obj = (NSDictionary *)rsp;
            }
            [self saveSession:obj];
            //saveSession will also save user
            handler(self.user);
        } else {
            handler(nil);
        }
    } onError:^(ElxError * error){
        //check 是自动行为，即使网络请求失败无需清除session
        handler(nil);
    }];
    
}

//返回loginkey
-(NSString *)loginkey{
    return [[self getSession] objectForKey:ELEX_337_LOGINKEY];
}

//显示登录窗口
-(void)login:(ElxLoginHandler)handler{
    UIView *top = [[UIApplication sharedApplication] keyWindow];
    //UIWindow *currentWindow = [[[UIApplication sharedApplication] delegate] window];
    [self loginInView:top callback:handler];
}

//在view中显示login窗口
-(void)loginInView:(UIView *)view callback:(ElxLoginHandler)handler{
    [self loginInView:view withCloseButton:NO callback:handler];
}

//在view中显示登陆窗口,withClose表示窗口是否包含关闭按钮
-(void)loginInView:(UIView *)view withCloseButton:(BOOL)withClose callback:(ElxLoginHandler)handler{
    self.type = ElxViewType_Login;
    self.loginHandler = handler;
    self.withCloseButton = withClose;
    //如果已有人登陆，那么就返回这个信息 不再打开窗口
    if(self.user){
        return handler(self.user,nil);
    }else{
        [self showInView:view animated:YES];
    }
}

//提供账号密码进行登录
-(void)loginWithUsername:(NSString *)_username password:(NSString *)_password callback:(ElxLoginHandler)handler{
    [self _loginWithUsername:_username password:_password callback:handler];
}

//在当前窗口中显示register
-(void)openRegister:(ElxLoginHandler)handler{
    UIView *currentWindow = [[UIApplication sharedApplication] keyWindow];
    //UIWindow *currentWindow = [[[UIApplication sharedApplication] delegate] window];
    [self openRegisterInView:currentWindow callback:handler];
}

//在view中显示登录窗口
-(void)openRegisterInView:(UIView *)view callback:(ElxLoginHandler)handler{
    [self openRegisterInView:view withCloseButton:NO callback:handler];
}

//在view中显示登录窗口,hasClose表示窗口是否包含关闭按钮
-(void)openRegisterInView:(UIView *)view withCloseButton:(BOOL)withClose callback:(ElxLoginHandler)handler{
    self.type = ElxViewType_Register;
    self.loginHandler = handler;
    self.withCloseButton = withClose;
    [self showInView:view animated:YES];
}

//提供账号名，密码，email进行注册
-(void)registerWithUsername:(NSString *)_username password:(NSString *)_password email:(NSString *) _email callback:(ElxLoginHandler)handler{
    [self _registerWithUsername:_username password:_password email:_email callback:handler];
}

//登出，同时清除session
-(void)logout{
    [self saveSession:nil];
}




#pragma mark - Button click Events

-(void)regButtonClicked:(UIButton*)button{
    if([self anyTextFieldIsBad]){
        return;
    }
    
    NSString *username = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Reg_Username]).text;
    NSString *password = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Reg_Password]).text;
    NSString *repassword = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Reg_RePassword]).text;
    NSString *email = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Reg_Email]).text;
    
    if(![password isEqualToString:repassword]){
        //NSString* message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"password_dont_match", STRING_TABLE, @"password dont match")];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[ElxStrings get:Elx_STR_password_dont_match] delegate:self cancelButtonTitle:[ElxStrings get:Elx_STR_ok] otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        alert.accessibilityIdentifier = @"0";
        [alert show];
        [alert release];
        return;
    }
    
    //show hud
    self.HUD = [MBProgressHUD showHUDAddedTo:self.currentView animated:YES];
    self.HUD.delegate = self;
    
    // 有更好的写法么？
    [self _registerWithUsername:username password:password email:email callback:^(ElxUser *user,ElxError *error) {
        if(user){
            //登陆成功 向外通知
            self.loginHandler(user,nil);
            [self.HUD hide:YES];
            [self fadeOut];
        }else{
            //尝试重复登陆
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.detailsLabelText= error.message;;
            [self.HUD hide:YES afterDelay:3];
        }
    }];
}

-(void)loginButtonClicked:(UIButton*)button{
    if([self anyTextFieldIsBad]){
        return;
    }
    
    NSString *username = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Login_Username]).text;
    NSString *password = ((UITextField *)[self.currentView viewWithTag:ElxInputCellType_Login_Password]).text;
    
    //show hud
    self.HUD = [MBProgressHUD showHUDAddedTo:self.currentView animated:YES];
    self.HUD.delegate = self;
    
    // 有更好的写法么？
    [self _loginWithUsername:username password:password callback:^(ElxUser *user,ElxError *error) {
        if(user){
            //登陆成功 向外通知
            self.loginHandler(user,nil);
            [self.HUD hide:YES];
            [self fadeOut];
        }else{
            //尝试重复登陆
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.detailsLabelText= error.message;;
            [self.HUD hide:YES afterDelay:3];
        }
    }];
}

-(void)closeButtonClicked:(UIButton*)button{
    self.loginHandler(nil,[ElxError code:@"0" message:@"user canceled."]);
    [self fadeOut];
}

-(void)switchFromLoginAndRegister:(UIButton*)button{
    //修改type
    if(self.type == ElxViewType_Login){
        self.type = ElxViewType_Register;
    }else{
        self.type = ElxViewType_Login;
    }
    //添加子view
    [self addTheRightSubView];
    //重绘
    [self redrawCurrentView];
}

#pragma mark - Notifications

- (void) orientationDidChange: (NSNotification *) note {
    //重新计算重绘区域
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.origin.x = 0;
    rect.origin.y = 0;
    switch([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            rect.size = CGSizeMake(rect.size.height, rect.size.width);
            inPortrait = NO;
            break;
        default:
            inPortrait = YES;
    }
    [self setFrame:rect];
    //重新计算中心圆角矩形区域
    CGRect mainFrame = [self contentRectBy:self.frame];
    self.main.frame = mainFrame;
    //重绘
    [self redrawCurrentView];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    if(!inPortrait && !iPad && !elementUp){
        float offset = self.main.frame.origin.y + self.currentView.separateLine.frame.origin.y;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:0
                         animations:^{
                             //self.tableView.transform = CGAffineTransformMakeTranslation (0, -offset);
                             self.currentView.transform = CGAffineTransformMakeTranslation (0, -offset);
                             self.main.transform = CGAffineTransformMakeTranslation (0, -offset);
                         }
                         completion:^(BOOL Finished){
                             elementUp = YES;
                         }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if(!inPortrait && !iPad && elementUp){
        
        float offset = 0;
        
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:0
                         animations:^{
                             self.currentView.transform = CGAffineTransformMakeTranslation (0, offset);
                             self.main.transform = CGAffineTransformMakeTranslation (0, offset);
                         }
                         completion:^(BOOL Finished){
                             elementUp = NO;
                         }];
    }
    /**/
}


#pragma mark - Private Methods




- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(orientationDidChange:)
                                                 name: UIApplicationDidChangeStatusBarOrientationNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [aView addSubview:self];
    
    [self addTheRightSubView];
    [self orientationDidChange:nil];
    
    if (animated) {
        [self fadeIn];
    }
}



-(void)redrawCurrentView{
    CGRect currentViewFrame = self.main.frame;
    currentViewFrame.size.height = self.main.superview.frame.size.height;
    //内部的frame必须足够大，以容纳所有的元素。否则只能看见不能点
    self.currentView.frame = currentViewFrame;
    float height = [self.currentView resizeAndGetHeightInPortrait:inPortrait];
    currentViewFrame.size.height = height;
    //调整高度
    CGRect mainF = self.main.frame;
    mainF.size.height = height;
    self.main.frame = currentViewFrame;
}

-(void)addTheRightSubView{
    if(self.currentView != nil){
        if( (self.type != ElxViewType_Login && [self.currentView isKindOfClass:[ElxLoginView class]]) || (self.type !=ElxViewType_Register && [self.currentView isKindOfClass:[ElxRegisterView class]])){
            //如果type和实际添加的类型不匹配 就移除
            [self.currentView removeFromSuperview];
        }
    }
    if(self.type == ElxViewType_Login){
        self.currentView = self.loginView;
    }else{
        self.currentView = self.registerView;
    }
    
    if([self.currentView superview] == nil){
        [self addSubview:self.currentView];
    }
}


//得到当前窗口尺寸
-(CGRect) contentRectBy:(CGRect)rect {
    return CGRectMake(POPLISTVIEW_SCREENINSET,
                      POPLISTVIEW_SCREENINSET - 18,//-5 是为了在landscape模式下 键盘不会挡住输入框
                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET,
                      rect.size.height - 2 * POPLISTVIEW_SCREENINSET); //not so high;
}

//保存登录用户登录凭证,obj包含完整的用户信息，但是我们不存。只取uid，和loginkey
-(void)saveSession:(NSDictionary  *)obj{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    //obj不为空，并且包含uid.
    if(!obj || ![obj objectForKey:ELEX_337_UID]){
        //clear user
        self.user = nil;
        //clear session
        [userData removeObjectForKey:ELEX_337_SESSION];
        [userData synchronize];
    }else{
        NSString *uid =[obj objectForKey:ELEX_337_UID];
        ElxUserType type = [[obj objectForKey:ELEX_337_TYPE] intValue];
        
        //如果 不知道 或者 没设置 用户类型，并且UID是以 elex337_开头的 那么设置用户类型为337
        if(ElxUser_UNKNOWN == type && [uid hasPrefix:ELEX_337_UID_PREFIX]){
            type = ElxUser_337;
        }
        
        //设置session
        NSMutableDictionary *session = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        uid,ELEX_337_UID,
                                        [NSNumber numberWithInt:type], ELEX_337_TYPE,
                                        nil];
        //尝试设置loginkey
        NSString *loginkey =[obj objectForKey:ELEX_337_LOGINKEY];
        if(loginkey){
            [session setValue:loginkey forKey:ELEX_337_LOGINKEY];
        }
        [userData setObject:session forKey:ELEX_337_SESSION];
        [userData synchronize];
        //set user
        self.user = [[[ElxUser alloc]initWithDict:obj]autorelease];
    }
    localUserSetted = YES;
}

//取用户session
-(NSDictionary *)getSession{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ELEX_337_SESSION];
}

//提供账号密码进行登录
-(void)_loginWithUsername:(NSString *)_username password:(NSString *)_password callback:(ElxLoginHandler)handler{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            _username,@"username",
                            _password,@"password",
                            nil];
    [self requestApi:URL_LOGIN withParam:params onSuccess:^(NSObject *response, int code) {
        ElxError *err = nil;
        NSDictionary *obj = nil;
        //handler result ,parse session or error
        if (code == 200) {
            NSObject *rsp = [SZJsonParser parseString:(NSString *) response];// obj will be an array or a dictionary
            if([rsp respondsToSelector:@selector(objectForKey:)]){
                obj = (NSDictionary *)rsp;
            }
            if(![obj objectForKey:@"uid"]){
                NSString * code = (NSString *)[obj objectForKey:@"error_code"];
                NSString * message = (NSString *)[obj objectForKey:@"error_description"];
                err = [ElxError code:code message:message];
            }
        } else {
            err = [ElxError code:[NSString stringWithFormat:@"%d",code] message:[NSString stringWithFormat:@"Bad server response code:%d",code]];
        }
        
        [self saveSession:obj];
        handler(self.user,err);
        
    } onError:^(ElxError * error){
        //login 网络失败时也需要清除 session
        [self saveSession:nil];
        handler(nil,error);
    }];
}

-(void)_registerWithUsername:(NSString *)_username password:(NSString *)_password email:(NSString *) _email callback:(ElxLoginHandler)handler{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            _username,@"username",
                            _password,@"password",
                            _email,@"email",
                            nil];
    [self requestApi:URL_REG withParam:params onSuccess:^(NSObject *response, int code) {
        ElxError *err = nil;
        NSDictionary *obj = nil;
        
        if (code == 200) {
            NSObject *rsp = [SZJsonParser parseString:(NSString *) response];// obj will be an array or a dictionary
            if([rsp respondsToSelector:@selector(objectForKey:)]){
                obj = (NSDictionary *)rsp;
            }
            if(![obj objectForKey:@"uid"]){
                NSString * code = (NSString *)[obj objectForKey:@"error_code"];
                NSString * message = (NSString *)[obj objectForKey:@"error_description"];
                err = [ElxError code:code message:message];
            }
        } else {
            err = [ElxError code:[NSString stringWithFormat:@"%d",code] message:[NSString stringWithFormat:@"Bad server response code:%d",code]];
        }
        
        [self saveSession:obj];
        handler(self.user,err);
        
    } onError:^(ElxError * error){
        //login 网络失败时也需要清除 session
        [self saveSession:nil];
        handler(nil,error);
    }];
    
}

-(BOOL)anyTextFieldIsBad {
    int from = 0,to = 0;
    
    if(self.type == ElxViewType_Login){
        from = ElxInputCellType_Login_Username;
        to = ElxInputCellType_Login_Password;
    }else{
        from = ElxInputCellType_Reg_Username;
        to = ElxInputCellType_Reg_RePassword;
    }
    for (int i = from; i <= to ; i++) {
        UITextField *non_blank_field = (UITextField*)[self.currentView viewWithTag:i];
        NSString *textInField = non_blank_field.text;
        
        if(!(textInField && textInField.length)){
            NSString* message = [NSString stringWithFormat:[ElxStrings get:Elx_STR_required_field_empty],non_blank_field.placeholder];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:[ElxStrings get:Elx_STR_ok] otherButtonTitles:nil,nil];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            alert.accessibilityIdentifier = [NSString stringWithFormat:@"%d",i];
            [alert show];
            [alert release];
            return YES;
        }
    }
    
    return NO;
}

- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut {
    [UIView animateWithDuration:.35 animations:^{
        //this line cause the UI mess,and I don't know why yet
        //self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self removeFromSuperview];
        }
    }];
}




// helper function: get the string form of any object
-(NSString *)toString:(id) object {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
-(NSString *)urlEncode:(id)object {
    NSString *string = [self toString:object];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

-(NSString*) urlEncodedString:(NSDictionary *)_params {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in _params) {
        id value = [_params objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

-(void)requestApi:(NSString *)_uri withParam:(NSDictionary *)_params onSuccess:(ElxHttpSuccess)_scb onError:(ElxHttpError)_ecb{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    UIDevice *d = [UIDevice currentDevice];
    
    NSDictionary *sdkParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              bundleIdentifier,@"source",
                              [d systemVersion],@"version",
                              [d model],@"model",
                              [d systemName],@"system",
                              [ElxStrings get:Elx_STR_lang],@"language",
                              nil];
    
    NSURL* url = [[NSURL alloc]initWithScheme:HTTP host:HOST_WEB path:[NSString stringWithFormat:@"%@?%@&%@",_uri,[self urlEncodedString:_params],[self urlEncodedString:sdkParam]]];
    
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    OHURLLoader* loader = [OHURLLoader URLLoaderWithRequest:req];
    
    NSLog(@"calling %@",url);
    [loader startRequestWithCompletion:^(NSData* receivedData, NSInteger httpStatusCode) {
        NSLog(@"%@",loader.receivedString);
        NSLog(@"(statusCode:%ld)",(long)httpStatusCode);
        _scb(loader.receivedString,httpStatusCode);
    } errorHandler:^(NSError *error) {
        NSLog(@"Error  %@",error);
        _ecb([ElxError fromNSError:error]);
    }];
    
    [url autorelease];
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[self.HUD removeFromSuperview];
    //	[self.HUD release];
    self.HUD = nil;
}




#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *index = alertView.accessibilityIdentifier;
    UITextField *active = (UITextField *)[self.currentView viewWithTag:[index intValue]];
    [active becomeFirstResponder];
}



@end
