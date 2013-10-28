//
//  ElxConfig.h
//  ElxWeb337
//
//  Created by elex on 13-10-15.
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

#define SECOND_BTN_FONT_DECREASE 2
#define SECOND_BTN_DECREASE 10

#ifdef NSTextAlignmentCenter // iOS6 and later
#   define kLabelAlignmentLeft      NSTextAlignmentLeft
#   define kLabelAlignmentRight     NSTextAlignmentRight
#else // older versions
#   define kLabelAlignmentLeft      UITextAlignmentLeft
#   define kLabelAlignmentRight     UITextAlignmentRight
#endif


#endif
