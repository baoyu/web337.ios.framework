//
//  ElxLoginInputCell.m
//  web337
//
//  Created by elex on 13-8-26.
//  Copyright (c) 2013年 elex. All rights reserved.
//

// http://uicolor.org/ for colors


#import "ElxLoginInputCell.h"
#import "ElxStrings.h"
#import <QuartzCore/QuartzCore.h>
#import "ElxConfig.h"

static NSString* const FORGETPASSWORD_URL = @"http://account.337.com/%@/pass/forgetPassword";
//static NSString* const STRING_TABLE = @"ElxStrings";

@implementation ElxLoginInputCell

@synthesize inCellTextFieldDelgeate;

static NSMutableArray *container = nil;

+(void)removeAllTextfields
{
    for (UIView *view in container) {
        [view removeFromSuperview];
    }
    [container removeAllObjects];
}

-(NSMutableArray *)getContainer{
    if (container == nil)
    {
        container = [[NSMutableArray alloc]init];
    }
    return container;
}

-(void)addToContainer:(UITextField *)_textfield{
    [[self getContainer]addObject:_textfield];
}

-(void)forgetPassword:(UIButton*)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:FORGETPASSWORD_URL,    [ElxStrings get:Elx_STR_lang] ] ]];
}

-(UITextField *)getUITextField:(int)tag defaultValues:(NSMutableArray *) arr{

    CGRect bgRect = CGRectInset(self.contentView.bounds, TEXTFIELD_SPACE, TEXTFIELD_SPACE/2);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:bgRect];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //textField.enablesReturnKeyAutomatically = YES;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //textField.textAlignment = UITextAlignmentCenter;
    
    //textField.font = [UIFont systemFontOfSize: CHAR_SIZE_CONST];
    
    
//    textField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:CHAR_SIZE_CONST];
    textField.font = [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST];
    
    textField.delegate = inCellTextFieldDelgeate;
    //cbdcf6
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f].CGColor;
    
    textField.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 6, bgRect.size.height)] autorelease];
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
            
            float pad = 2.0;

            UIImage *lockImage = [UIImage imageNamed:@"web337.bundle/337_lock.png"];

            UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(0, (bgRect.size.height - lockImage.size.height)/2, lockImage.size.width, lockImage.size.height)];
            lock.image = lockImage;
            
            
            UILabel *forgetPassLabel =  [[UILabel alloc]init];
            forgetPassLabel.textColor = [UIColor colorWithRed:237/255.0f green:106/255.0f blue:18/255.0f alpha:1.0f];
            forgetPassLabel.text = [ElxStrings get:Elx_STR_forget];
            forgetPassLabel.font = [UIFont systemFontOfSize:12];
            [forgetPassLabel sizeToFit];
            CGRect lbFrame = forgetPassLabel.frame;
            forgetPassLabel.frame = CGRectMake(lockImage.size.width+pad, (bgRect.size.height - lbFrame.size.height)/2, lbFrame.size.width+pad, lbFrame.size.height);

            CGRect rvFrame = CGRectMake(0, 0, lockImage.size.width + forgetPassLabel.frame.size.width + 1 + 2*pad, bgRect.size.height);
            UIView *rightView = [[UIView alloc]initWithFrame:rvFrame];

            UITapGestureRecognizer *tapGesture =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPassword:)] autorelease];
            [rightView addGestureRecognizer:tapGesture];
            
            
            [rightView addSubview:[lock autorelease]];
            [rightView addSubview:[forgetPassLabel autorelease]];

            textField.rightView = [rightView autorelease];
            textField.rightViewMode = UITextFieldViewModeAlways;

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
            return nil;
            break;
    }
    [textField setText:[arr objectAtIndex:tag]];

    [self addToContainer:textField];
    return [textField autorelease];
}

-(void)configureRegAtIndexPath:(NSIndexPath *)indexPath defaultValues:(NSMutableArray *) arr inPortrait:(BOOL) p
{
    if(indexPath.section == 0){
        if(p){
            UITextField *textField = nil;
            int tag = ElxInputCellType_Reg_Username;
            textField = [self getUITextField:indexPath.row + tag defaultValues:arr];
            [self.contentView addSubview:textField] ;
        }else{            
            UITextField *left = nil;
            UITextField *right = nil;
            int tag = ElxInputCellType_Reg_Username;
            
            if(indexPath.row == 0){
                left = [self getUITextField:tag+0 defaultValues:arr];
                right = [self getUITextField:tag+1 defaultValues:arr];
            }
            if(indexPath.row == 1){
                left = [self getUITextField:tag+2 defaultValues:arr];
                right = [self getUITextField:tag+3 defaultValues:arr];
            }
            CGSize size = self.contentView.frame.size;

            /*
            float widthFix = 1;
            float h = size.height - TEXTFIELD_SPACE/2;
            float w = (size.width - TEXTFIELD_SPACE *3)/2;
            left.frame = CGRectMake(TEXTFIELD_SPACE, TEXTFIELD_SPACE/2, w-widthFix, h);
            right.frame = CGRectMake(TEXTFIELD_SPACE*2 + w -widthFix, TEXTFIELD_SPACE/2, w+widthFix, h);
            */
            
            float h = size.height - TEXTFIELD_SPACE/2;
            float w = (size.width - TEXTFIELD_SPACE *3)/2;
            left.frame = CGRectMake(TEXTFIELD_SPACE, TEXTFIELD_SPACE/2, w, h);
            right.frame = CGRectMake(TEXTFIELD_SPACE*2 + w, TEXTFIELD_SPACE/2, w, h);
            
            [self.contentView addSubview:left];
            [self.contentView addSubview:right];
        }

    }
}

-(void)configureLoginAtIndexPath:(NSIndexPath *)indexPath defaultValues:(NSMutableArray *) arr inPortrait:(BOOL) p;
{
    if(indexPath.section == 0){
        if(p){
            UITextField *textField = nil;
            int tag = ElxInputCellType_Login_Username;
            textField = [self getUITextField:indexPath.row + tag defaultValues:arr];
            [self.contentView addSubview:textField] ;
        }else{
            UITextField *left = nil;
            UITextField *right = nil;
            int tag = ElxInputCellType_Login_Username;
            
            left = [self getUITextField:tag+0 defaultValues:arr];
            right = [self getUITextField:tag+1 defaultValues:arr];
            
            CGSize size = self.contentView.frame.size;
            
            /*
            float widthFix = 1;
            float h = size.height - TEXTFIELD_SPACE/2;
            float w = (size.width - TEXTFIELD_SPACE *3)/2;
            left.frame = CGRectMake(TEXTFIELD_SPACE, TEXTFIELD_SPACE/2, w-widthFix, h);
            right.frame = CGRectMake(TEXTFIELD_SPACE*2 + w -widthFix, TEXTFIELD_SPACE/2, w+widthFix, h);
            */
            
            float h = size.height - TEXTFIELD_SPACE/2;
            float w = (size.width - TEXTFIELD_SPACE *3)/2;
            left.frame = CGRectMake(TEXTFIELD_SPACE, TEXTFIELD_SPACE/2, w, h);
            right.frame = CGRectMake(TEXTFIELD_SPACE*2 + w, TEXTFIELD_SPACE/2, w, h);
            
            [self.contentView addSubview:left];
            [self.contentView addSubview:right];
        }
        
    }
}

- (void)dealloc {
    inCellTextFieldDelgeate = nil;
    [super dealloc];
}
@end
