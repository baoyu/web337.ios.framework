//
//  ElxBaseView.m
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxBaseView.h"

@interface ElxBaseView()<UITextFieldDelegate>

@property (retain,nonatomic) UIImageView *logo;
@property (retain,nonatomic) UIImageView *close;


@end

@implementation ElxBaseView

@synthesize withCloseButton = _withCloseButton;
@synthesize logo = _logo;
@synthesize close = _close;
@synthesize separateLine = _separateLine;

@synthesize delegate = _delegate;

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
        long nextTag = textField.tag + 1;
        UITextField *nextTextField = (UITextField *)[self viewWithTag:nextTag];
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
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeHeader];
    }
    return self;
}

-(void)closeButtonClicked:(UIButton*)button{
    if(self.delegate){
        [self.delegate closeButtonClicked:button];
    }
}

-(void)initializeHeader{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];

    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"web337.bundle/337logo.png"]];
    
    if(self.withCloseButton || YES){
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClicked:)];
        singleTap.numberOfTapsRequired = 1;
        
        UIImageView *close = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"web337.bundle/337_close.png"]];
        close.userInteractionEnabled = YES;
        [close addGestureRecognizer:[singleTap autorelease]];
        self.close = [close autorelease];
    }
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
    
    
    
    
    
    
    self.logo = [logo autorelease];
    self.separateLine = [line autorelease];
    
    
    [self addSubview:self.logo];
    [self addSubview:self.close];
    [self addSubview:self.separateLine];
}


-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait{
    return [self resizeAndGetHeightInPortrait:inPortrait At:0];
}

-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait At:(float)top{
    float
    x = COMMON_PADDING,
    y = COMMON_PADDING + top,
    w = self.logo.frame.size.width,
    h = self.logo.frame.size.height;
    
    self.logo.frame = CGRectMake(x,y,w,h);
    
    if(self.close){
        x = self.frame.size.width - COMMON_PADDING - self.close.frame.size.width;
        self.close.frame = CGRectMake(x,y,self.close.frame.size.width,self.close.frame.size.height);
    }
    x = 0;
    y += h + y;
    w = self.frame.size.width;
    h = 1;
    
    self.separateLine.frame = CGRectMake(x,y,w,h);

    return y+h;
}


-(UITextField *)getUITextField:(int)tag{
    UITextField *textField = [[UITextField alloc] init];
    
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [ElxConfig fontTextfield];
    textField.backgroundColor = [UIColor whiteColor];
    //边框
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f].CGColor;
    
    //左侧的空白
    textField.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 6, 6)] autorelease];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView.userInteractionEnabled = NO;//    this line of code is really fucking important!
    
    
    textField.tag = tag;
    
    switch (tag) {
        case ElxInputCellType_Login_Username:
            textField.placeholder = [ElxStrings get:Elx_STR_p_username];
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyNext;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        case ElxInputCellType_Login_Password:
            textField.placeholder = [ElxStrings get:Elx_STR_p_password];
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            break;
        case ElxInputCellType_Reg_Username:
            textField.placeholder = [ElxStrings get:Elx_STR_p_username];
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        case ElxInputCellType_Reg_Email:
            textField.placeholder = [ElxStrings get:Elx_STR_p_email];
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        case ElxInputCellType_Reg_Password:
            textField.placeholder = [ElxStrings get:Elx_STR_p_password];
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.secureTextEntry = YES;
            break;
        case ElxInputCellType_Reg_RePassword:
            textField.placeholder = [ElxStrings get:Elx_STR_p_repassword];
            textField.returnKeyType = UIReturnKeyDone;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.secureTextEntry = YES;
            break;
        default:
            [textField release];
            return nil;
            break;
    }
    
    [textField setDelegate:self];
    return [textField autorelease];
}


-(void)makeRoundCornerFor:(UIView *)v{
    //增加两个圆角在底部
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:v.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    v.layer.mask = maskLayer;
    [maskLayer release];
}

-(void)dealloc{

    [_logo release];
    [_close release];
    [_separateLine release];
    [super dealloc];
}
@end
