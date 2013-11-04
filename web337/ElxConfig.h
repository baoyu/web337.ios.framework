//
//  ElxConfig.h
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//


#ifndef ElxWeb337_ElxConfig_h
#define ElxWeb337_ElxConfig_h

#define POPLISTVIEW_SCREENINSET_HEIGHT 140.
#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_INNER_HEIGHT 28.
#define POPLISTVIEW_HEADER_HEIGHT 50.

//上下左右的padding
#define COMMON_PADDING 6.0
//logo的高度
#define LOGO_IMAGE_HEIGHT 28

#define TEXTFIELD_SPACE 6

#define BUTTON_HEIGHT 33.0

#define INCELL_TEXTFIELD_HEIGHT 39.0

#define FACEBOOK_LOGIN_HEIGHT 32

#define PADDING 10.
#define RADIUS 5.

#define BUNDLE_PREFIX = @"web337.bundle/"

#define TEXTFIELD_SPACE 6
#define TEXTFIELD_SPACE_LAND 4

//#define LOGO_PADDING 10
#define LOGO_PADDING 6
#define LOGO_PADDING_LAND 5

#define ITEM_SPACE 6

#define iPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define PADDING_LEFT_CONST  (iPad ? 44.0f : 10.0f)
#define CHAR_SIZE_CONST  (iPad ? 15 : 14)

//次级按钮如果缩小 不是很漂亮
#define SECOND_BTN_FONT_DECREASE 0//2
#define SECOND_BTN_DECREASE 0//10

#ifdef NSTextAlignmentCenter // iOS6 and later
#   define kLabelAlignmentLeft      NSTextAlignmentLeft
#   define kLabelAlignmentRight     NSTextAlignmentRight
#else // older versions
#   define kLabelAlignmentLeft      UITextAlignmentLeft
#   define kLabelAlignmentRight     UITextAlignmentRight
#endif


#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ElxConfig : NSObject

//colors

/*!
 背景颜色
 */
+(UIColor *) colorBackground;
/*!
 遮罩颜色
 */
+(UIColor *) colorMask;
/*!
 主按钮高亮颜色
 */
+(UIColor *) colorBtnPrimaryHighlight;
/*!
 主按钮背景颜色
 */
+(UIColor *) colorBtnPrimary;
/*!
 次按钮高亮
 */
+(UIColor *) colorBtnDefaultHighlight;
/*!
 次按钮背景颜色
 */
+(UIColor *) colorBtnDefault;
/*!
 次按钮文字颜色
 */
+(UIColor *) colorTitle;
/*!
 忘记密码的颜色
 */
+(UIColor *) colorForgetPass;


//font


/*!
 忘记密码的字体
 */
+(UIFont *) fontForgetPass;
/*!
 主按钮字体
 */
+(UIFont *) fontBtnPrimary;
/*!
 次按钮字体
 */
+(UIFont *) fontBtnDefault;
/*!
 输入框字体
 */
+(UIFont *) fontTextfield;

@end