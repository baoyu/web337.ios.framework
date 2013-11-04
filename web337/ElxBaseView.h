//
//  ElxBaseView.h
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElxConfig.h"
#import "ElxStrings.h"

/*!
 @typedef ElxLoginInputCellType enum
 
 @abstract
 用来给每个输入框编号
 
 @discussion
 对页面中的输入框进行初始化，通过传入不同的编号以构造不同类型的界面元素。同时也提供了从UIView中得到输入框的序号。
 */

typedef enum {
    /*! 无意义的一个初始编号0，表示元素的SuperView */
    ElxInputCellType_UI,
    /*! 登陆界面->用户名 */
    ElxInputCellType_Login_Username,
    /*! 登陆界面->密码 */
    ElxInputCellType_Login_Password,
    /*! 注册界面->用户名 */
    ElxInputCellType_Reg_Username,
    /*! 注册界面->电子邮件 */
    ElxInputCellType_Reg_Email,
    /*! 注册界面->密码 */
    ElxInputCellType_Reg_Password,
    /*! 注册界面->重复输入的密码 */
    ElxInputCellType_Reg_RePassword,
} ElxLoginInputCellType;


@protocol ElxViewEventDelegate <NSObject>

@optional

-(void)switchFromLoginAndRegister:(UIButton*)button;
-(void)regButtonClicked:(UIButton*)button;
-(void)loginButtonClicked:(UIButton*)button;
-(void)closeButtonClicked:(UIButton*)button;
-(void)facebookLogin:(UIButton*)button;

@end




@interface ElxBaseView : UIView

@property (retain,nonatomic) UIView *separateLine;

@property (assign,nonatomic) BOOL withCloseButton;

@property (assign,nonatomic) id<ElxViewEventDelegate> delegate;

-(void)makeRoundCornerFor:(UIView *)v;

-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait;

-(float)resizeAndGetHeightInPortrait:(BOOL)inPortrait At:(float)top;

-(UITextField *)getUITextField:(int)tag;

@end




