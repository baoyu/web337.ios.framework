//
//  ElxConfig.m
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxConfig.h"

@implementation ElxConfig

//背景颜色
+(UIColor *) colorBackground{
    return [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
}
//遮罩颜色
+(UIColor *) colorMask{
    return [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.65f];
}


+(UIColor *) colorBtnPrimaryHighlight{
    return [UIColor colorWithRed:59/255.0f green:169/255.0f blue:11/255.0f alpha:1.0f];
}
+(UIColor *) colorBtnPrimary{
    return [UIColor colorWithRed:84/255.0f green:189/255.0f blue:16/255.0f alpha:1.0f];
}
+(UIColor *) colorBtnDefaultHighlight{
    return [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
}
+(UIColor *) colorBtnDefault{
    return [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
}
+(UIColor *) colorTitle{
    return [UIColor colorWithRed:122/255.0f green:121/255.0f blue:121/255.0f alpha:1.0f];
}

+(UIFont *) fontBtnPrimary{
    return [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST];;
}

+(UIFont *) fontBtnDefault{
    return [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST-SECOND_BTN_FONT_DECREASE];
}

//忘记密码的颜色
+(UIColor *) colorForgetPass{
    return [UIColor colorWithRed:237/255.0f green:106/255.0f blue:18/255.0f alpha:1.0f];
}
//忘记密码的字体
+(UIFont *) fontForgetPass{
    return [UIFont systemFontOfSize:12];
}

+(UIFont *) fontTextfield{
    return [UIFont fontWithName:@"HelveticaNeue" size:CHAR_SIZE_CONST];
}

@end
