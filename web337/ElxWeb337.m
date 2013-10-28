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
#import "ElxLoginInputCell.h"
#import "ElxButton.h"
#import "ElxConfig.h"
#import "ElxFBLogin.h"


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

@interface ElxWeb337()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>

@property (strong,nonatomic) ElxLoginHandler loginHandler;


@property (assign,nonatomic) ElxViewType type;
@property (retain,nonatomic) NSMutableArray *textFieldValues;
@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) UIView *headerView;
@property (retain, nonatomic) ElxUser * user;
@property (retain, nonatomic) UIColor * bgColor;
@property (retain, nonatomic) MBProgressHUD * HUD;

@property (assign,nonatomic) BOOL withCloseButton;

@end




@implementation ElxWeb337

BOOL needsRedraw = NO;
BOOL needsReload = NO;
BOOL needsReturnZero = NO;
BOOL inPortrait = YES;
BOOL localUserSetted = NO;
float buttomHeight = 0;

@synthesize loginHandler = _loginHandler;
@synthesize user = _user;
@synthesize type = _type;

@synthesize headerView = _headerView;
@synthesize tableView = _tableView;

@synthesize bgColor = _bgColor;
@synthesize textFieldValues = _textFieldValues;
@synthesize HUD = _HUD;

@synthesize FacebookSupport,GameCenterSupport,withCloseButton;


typedef void (^ThirdPartyCompleteHandler)(NSDictionary *obj, NSError *error);


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
        [FBSession openActiveSessionWithReadPermissions:[self getFacebookReadPermissions]
                                           allowLoginUI:YES
                                      completionHandler: ^(NSObject *session,
                                                           int *status,
                                                           NSError *error) {
                                          [self getFacebookUser:^(NSDictionary *obj, NSError *error){
                                              if(obj){
                                                  [self saveSession:obj];
                                                  self.loginHandler(self.user,nil);
                                                  [self fadeOut];
                                              }
                                          }];
                                      }];
        
    }
    
}
/*
 * 是否facebook用户登陆过
 */
-(BOOL) hasFacebookLogin {
    Class FBSession = NSClassFromString(@"FBSession");
    if(FBSession){
        return (BOOL)[FBSession openActiveSessionWithReadPermissions:[self getFacebookReadPermissions] allowLoginUI:NO completionHandler:nil];
    }else{
        return NO;
    }
 
}




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
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    UIInterfaceOrientation _cOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(_cOrientation)) {
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    }
    
    
    if (self = [super initWithFrame:rect]) {
        self.bgColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
        self.textFieldValues =  [NSMutableArray arrayWithObjects:@"TheZero",@"", @"", @"", @"", @"" , @"" ,nil];
        
        //灰色遮罩
        self.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.65f];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:[self contentRectBy:rect] style:UITableViewStylePlain];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.alwaysBounceVertical = NO;
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.layer.cornerRadius = RADIUS;
        tableView.separatorColor = [UIColor clearColor];
        
        self.tableView = [tableView autorelease];
        [self addSubview:self.tableView];
    }
    
    //外部库加载策略
    
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
    UIWindow *currentWindow = [[[UIApplication sharedApplication] delegate] window];
    [self loginInView:currentWindow callback:handler];
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
    UIWindow *currentWindow = [[[UIApplication sharedApplication] delegate] window];
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

#pragma mark - clicks events


-(void)switchFromLoginAndRegister:(UIButton*)button{
    if(self.type == ElxViewType_Register){
        self.type = ElxViewType_Login;
    }else{
        self.type = ElxViewType_Register;
    }
    [self redrawTableView];
}

-(void)regButtonClicked:(UIButton*)button{
    if([self anyTextFieldIsBad]){
        return;
    }
    
    NSString *username = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Reg_Username]).text;
    NSString *password = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Reg_Password]).text;
    NSString *repassword = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Reg_RePassword]).text;
    NSString *email = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Reg_Email]).text;
    
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
    self.HUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
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
    
    NSString *username = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Login_Username]).text;
    NSString *password = ((UITextField *)[self.tableView viewWithTag:ElxInputCellType_Login_Password]).text;
    
    //show hud
    self.HUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
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


#pragma mark - Private Methods
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
        UITextField *non_blank_field = (UITextField*)[self.tableView viewWithTag:i];
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
            [self clearTextFields];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(orientationDidChange:)
                                                 name: UIApplicationDidChangeStatusBarOrientationNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self orientationDidChange:nil];
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

//还没开始用
-(void) clearTextFields{
    int n = [self.textFieldValues count];
    for(int i=1;i<n;i++){
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:i];
        if(textField){
            textField.text = @"";
        }
        [self.textFieldValues replaceObjectAtIndex:i withObject:@""];
    }
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
        NSLog(@"(statusCode:%d)",httpStatusCode);
        _scb(loader.receivedString,httpStatusCode);
    } errorHandler:^(NSError *error) {
        NSLog(@"Error  %@",error);
        _ecb([ElxError fromNSError:error]);
    }];
    
    [url autorelease];
}




#pragma mark - orientation event
- (void) orientationDidChange: (NSNotification *) note {
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
            ;
    }
    
    [self setFrame:rect];
    [self changeTheTableViewOrientation:inPortrait];
    [self setNeedsDisplay];
}

- (void) changeTheTableViewOrientation:(BOOL)portrait{
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:1];
    self.tableView.frame = [self contentRectBy:self.frame];
    [self redrawTableView];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    if(!inPortrait && !iPad){
        float offset = [self tableView:self.tableView heightForHeaderInSection:0] + self.tableView.frame.origin.y;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:0
                         animations:^{
                             self.tableView.transform = CGAffineTransformMakeTranslation (0, -offset);
                         }
                         completion:nil];
    }

    
    /*
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(rect, self.textView.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, self.textView.frame.origin.y - (keyboardSize.height - self.textView.frame.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    }
    */
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(!inPortrait && !iPad){
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:0
                     animations:^{
                             self.tableView.transform = CGAffineTransformMakeTranslation (0, 0);
                     }
                     completion:nil];
    }
    /*
     UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
     */
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[self.HUD removeFromSuperview];
    //	[self.HUD release];
    self.HUD = nil;
}

#pragma mark - Tableview datasource & delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return INCELL_TEXTFIELD_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //section 0 has username and password input textField
    if(needsReturnZero){
        return 0;
    }

    int number = 0;
    if(section == 0){
        if(self.type == ElxViewType_Login){
            number = 2;
        }else{
            number = 4;
        }
        //如果是landscape的话 一行两列
        if(!inPortrait){
            number = number/2;
        }
    }
    return number;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.bgColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *LoingCellIdentifier = @"LoginInputCell";
    NSString *RegCellIdentifier = @"RegInputCell";
    
    ElxLoginInputCell *cell = (ElxLoginInputCell *)[tableView dequeueReusableCellWithIdentifier:(self.type == ElxViewType_Login?LoingCellIdentifier:RegCellIdentifier)];
    if (cell == nil)
    {
        cell = [[ElxLoginInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(self.type == ElxViewType_Login?LoingCellIdentifier:RegCellIdentifier)];
        //onclick style
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.inCellTextFieldDelgeate = self;
        [cell autorelease];
    }
    
    //cell 的frame在第一次进行的时候 是不正确的。不知道原因，影响到后面的绘图
    if(cell.frame.size.width != self.tableView.frame.size.width){
        needsReload = YES;
    }
    
    //放在这里确保每次都要重新配置一下cell
    if(self.type == ElxViewType_Login){
        [cell configureLoginAtIndexPath:indexPath defaultValues:self.textFieldValues inPortrait:inPortrait];
    }else{
        [cell configureRegAtIndexPath:indexPath defaultValues:self.textFieldValues inPortrait:inPortrait];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //顶部padding + logo高度 + logo下的padding + 一个线 + 一半的Textfield空白，另一半由Textfield控制
    //CGRect bgRect = CGRectInset(self.contentView.bounds, TEXTFIELD_SPACE, TEXTFIELD_SPACE/2); 这是创建TextField的时候
    return COMMON_PADDING + LOGO_IMAGE_HEIGHT + COMMON_PADDING + 1 + TEXTFIELD_SPACE/2;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView * customSectionView = [[UIView alloc] init];
    UIImage *logoImg = [UIImage imageNamed:@"web337.bundle/337logo.png"];
    UIImageView *logoIV = [[UIImageView alloc]init];
    UIView * line = [[UIView alloc]init];
                           
    customSectionView.backgroundColor = self.bgColor;

    float
    x = COMMON_PADDING,
    y = COMMON_PADDING,
    w = logoImg.size.width,
    h = logoImg.size.height;
    
    logoIV.frame = CGRectMake(x,y,w,h);
    logoIV.image = logoImg;
    [customSectionView addSubview:[logoIV autorelease]];
    
    if(self.withCloseButton){
        UIImage *close = [UIImage imageNamed:@"web337.bundle/337_close.png"];
        UIImageView *closeIV = [[UIImageView alloc]init];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClicked:)];
        singleTap.numberOfTapsRequired = 1;
        closeIV.userInteractionEnabled = YES;
        [closeIV addGestureRecognizer:singleTap];
        x = self.tableView.frame.size.width - COMMON_PADDING - close.size.width;
        closeIV.frame = CGRectMake(x,y,close.size.width,close.size.height);
        closeIV.image = close;
        [customSectionView addSubview:[closeIV autorelease]];
    }

    
    
    x = 0;
    y += h + y;
    w = self.tableView.frame.size.width;
    h = 1;
    
    line.frame = CGRectMake(x,y,w,h);
    line.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
    [customSectionView addSubview:[line autorelease]];

    return [customSectionView autorelease];
}



- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.type == ElxViewType_Login){
        float add = 0;

        if(!self.FacebookSupport && !self.GameCenterSupport){
            add += FACEBOOK_LOGIN_HEIGHT + TEXTFIELD_SPACE;
        }

        if(inPortrait){
            return 113 -add - SECOND_BTN_DECREASE;
        }else{
            return 116 -add - SECOND_BTN_DECREASE;
        }
    }else{
        return 78.0 - SECOND_BTN_DECREASE;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section != 0){
        return nil;
    }
    if(needsReload){
        [self fixTableView];
        needsReload = NO;
    }
    if(needsReturnZero){
        //说明已经清除过
        needsReturnZero = NO;
    }

    UIView *view = nil;
    float buttomFix = 0;
    if(self.type == ElxViewType_Register){
        view =  [self tableView:tableView viewForFooterInSectionForRegister:section];
        buttomFix = 2;
    }else{
        view =  [self tableView:tableView viewForFooterInSectionForLogin:section];
    }
    
    UIView *lastButton = [[view subviews] lastObject];
    CGRect tmpFrame = lastButton.frame;
    //加一个圆角底边
    UIView *roundCorner = [[UIView alloc]initWithFrame:CGRectMake(0.0, tmpFrame.origin.y + tmpFrame.size.height - RADIUS, tmpFrame.size.width, 2 * RADIUS)];
    roundCorner.backgroundColor = lastButton.backgroundColor;
    roundCorner.layer.cornerRadius = RADIUS;
    [view addSubview:[roundCorner autorelease]];

    view.backgroundColor = self.bgColor;
    
    //md, login->reg->login->切到横屏->reg 可重现问题。 只要重绘一下就行了。以后再搞
    if(needsRedraw){
        needsRedraw = NO;
        [self redrawTableView];
    }
    [view bringSubviewToFront:lastButton];
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSectionForRegister:(NSInteger)section {
    //提交 回退
	UIView * customSectionView =[[UIView alloc] init ];
    

    //注册
    ElxButton *submitButton = [ElxButton buttonWithType:UIButtonTypeCustom];
    //回退
	ElxButton * backToLogin = [ElxButton buttonWithType:UIButtonTypeCustom];
    
    
    float
    space = TEXTFIELD_SPACE,
    widthAll = self.tableView.frame.size.width,
    widthElement = (widthAll - space *2),
    height = BUTTON_HEIGHT,
    nextRowTop = inPortrait?(space/2):space;
    
    
    submitButton.frame = CGRectMake(space, nextRowTop, widthElement, height);
    nextRowTop += space + height;
    backToLogin.frame = CGRectMake(0, nextRowTop, widthAll, height - SECOND_BTN_DECREASE);
    
    
    //common setups
    //[regButton setTitle:NSLocalizedStringFromTable(@"submit", STRING_TABLE, @"submit button textt") forState:UIControlStateNormal];
    [submitButton setTitle:[ElxStrings get:Elx_STR_submit] forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor colorWithRed:84/255.0f green:189/255.0f blue:16/255.0f alpha:1.0f]];
    [submitButton setHighlightColor:[UIColor colorWithRed:59/255.0f green:169/255.0f blue:11/255.0f alpha:1.0f]];
    [submitButton addTarget:self
                  action:@selector(regButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside
     ];
    submitButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST];
    [customSectionView addSubview:submitButton];
    
    
    [backToLogin setTitle:[ElxStrings get:Elx_STR_back] forState:UIControlStateNormal];
    [backToLogin setBackgroundColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f]];
    //因为下面挂个圆角矩形，所以不做高亮变色了
    //[regButton setHighlightColor:[UIColor colorWithRed:176/255.0f green:189/255.0f blue:189/255.0f alpha:1.0f]];
    [backToLogin setHighlightColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f]];
    [backToLogin addTarget:self action:@selector(switchFromLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
    backToLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST-SECOND_BTN_FONT_DECREASE];
    
    UIImage *lock =[UIImage imageNamed:@"web337.bundle/337_lefta.png"];
    [backToLogin setImage:lock  forState:UIControlStateNormal];
    
    CGFloat spacing = 5;
    backToLogin.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    backToLogin.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    [customSectionView addSubview:backToLogin];
    
    

    
    return [customSectionView autorelease];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSectionForLogin:(NSInteger)section {
    //输入框底部的 记住我、忘记密码、注册登录等
	UIView * customSectionView = [[UIView alloc] init ];
    
    //注册+后退
    ElxButton *loginButton = [ElxButton buttonWithType:UIButtonTypeCustom];
    ElxButton *regButton = [ElxButton buttonWithType:UIButtonTypeCustom];

    
    //facebook login button
    ElxFBLogin *fbLogin = nil;
    
    float
    space = TEXTFIELD_SPACE,
    widthAll = self.tableView.frame.size.width,
    widthElement = (widthAll - space *2),
    height = BUTTON_HEIGHT,
    nextRowTop = inPortrait?(space/2):space;
    
    
    loginButton.frame = CGRectMake(space, nextRowTop, widthElement, height);
    nextRowTop += space + height;
    
    //facebook 登录按钮
    if(self.FacebookSupport){
        fbLogin = [[ElxFBLogin alloc]init];
        [fbLogin.button addTarget:self
                           action:@selector(facebookLogin)
                 forControlEvents:UIControlEventTouchUpInside];
        fbLogin.frame = CGRectMake(space, nextRowTop, widthElement , FACEBOOK_LOGIN_HEIGHT);
        nextRowTop += space + FACEBOOK_LOGIN_HEIGHT;
        [customSectionView addSubview:[fbLogin autorelease]];
    }
    
    regButton.frame = CGRectMake(0, nextRowTop, widthAll, height - SECOND_BTN_DECREASE);
    //config loginButton
    [loginButton setBackgroundColor:[UIColor colorWithRed:84/255.0f green:189/255.0f blue:16/255.0f alpha:1.0f]];
    [loginButton setHighlightColor:[UIColor colorWithRed:59/255.0f green:169/255.0f blue:11/255.0f alpha:1.0f]];
    [loginButton setTitle:[ElxStrings get:Elx_STR_login]forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST];
    
    [regButton setTitle:[ElxStrings get:Elx_STR_register] forState:UIControlStateNormal];
    [regButton setBackgroundColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f]];
    //因为下面挂个圆角矩形，所以不做高亮变色了
    [regButton setHighlightColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f]];
    [regButton addTarget:self action:@selector(switchFromLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
    regButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST-SECOND_BTN_FONT_DECREASE];
    
    UIImage *lock =[UIImage imageNamed:@"web337.bundle/337_righta.png"];
    [regButton setImage:lock  forState:UIControlStateNormal];
    
    regButton.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., lock.size.width);
    
    CGFloat spacing = 5;
    regButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    regButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    [customSectionView addSubview:loginButton];
    [customSectionView addSubview:regButton];

    return [customSectionView autorelease];
}



-(void)redrawTableView{
    //需要把textfield都主动删掉 否则成为焦点的时候会有问题
    [ElxLoginInputCell removeAllTextfields];
    [self.tableView reloadData];
}

/**
 * tableView 在增加Cell的时候 首次增加的cell UI不正常。经过验证cell在从IOScache中取回时情况正常。
 * 因此修改思路为，当添加cell的时候 检查是否应该修正。如果需要修正 在渲染footer的时候触发。（因为UI重绘是异步操作，因此暂时只能放在这里）
 * 修正的过程为主动触发table的reload，然后设置cell数量为0，这样可以将cell清空，然后设置cell数量为正常，重绘。即可
 */
-(void)fixTableView{
    if(needsReload){
        needsReturnZero = YES;
        [self.tableView reloadData];
        [ElxLoginInputCell removeAllTextfields];
        [self.tableView reloadData];
    }
}


#pragma mark - UITextField delegate

//This code is for fix the problem when user input
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //仅仅支持输入ascii字符
    if(![string canBeConvertedToEncoding:NSASCIIStringEncoding]){
        return NO;
    }
    //如果是密码,那OK
    if(textField.secureTextEntry){
        return YES;
    }
    //如果等于空格,那么不允许
    return ![string isEqualToString:@" "];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //如果返回类型是Done则返回
    if(textField.returnKeyType == UIReturnKeyDone){
        [textField resignFirstResponder];
    }else{
        int nextTag = textField.tag + 1;
        UITextField *nextTextField = (UITextField *)[self.tableView viewWithTag:nextTag];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = [UIColor colorWithRed:141/255.0f green:216/255.0f blue:255/255.0f alpha:1.0f].CGColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f].CGColor;
    //把输入完的字符串保留起来，以免cell被换出内存丢失已经输入的字符串
    [self.textFieldValues replaceObjectAtIndex:textField.tag withObject:textField.text];
}
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *index = alertView.accessibilityIdentifier;
    UITextField *active = (UITextField *)[self.tableView viewWithTag:[index intValue]];
    [active becomeFirstResponder];
}

-(void)dealloc {
    [_loginHandler release];
    [_textFieldValues release];
    [_tableView release];
    [_headerView release];
    [_user release];
    [_bgColor release];
    [super dealloc];
}

@end
