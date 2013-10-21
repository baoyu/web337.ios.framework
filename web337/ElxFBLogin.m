//
//  ElxFBLogin.m
//  ElxWeb337
//
//  Created by elex on 13-10-16.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import "ElxFBLogin.h"
#import "ElxStrings.h"

// The design calls for 16 pixels of space on the right edge of the button
static const float kButtonEndCapWidth = 16.0;
// The button has a 12 pixel buffer to the right of the f logo
//static const float kButtonPaddingWidth = 12.0;
static const float kButtonPaddingWidth = 9.0;

static CGSize g_buttonSize;

// Forward declare our label wrapper that provides shadow blur
@interface ElxFBShadowLabel : UILabel

@end



@implementation ElxFBLogin

@synthesize
label = _label,
button = _button;





- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [_label release];
    [_button release];
    [super dealloc];
}



- (void)initialize {
    // the base class can cause virtual recursion, so
    // to handle this we make initialize idempotent
    if (self.button) {
        return;
    }
    
    // setup view
    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;
    
    // setup button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];

    
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // We want to make sure that when we stretch the image, it includes the curved edges and drop shadow
    // We inset enough pixels to make sure that happens
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(3.0, 28.0, 3.0, 3.0);
    //UIImage *image = [[UIImage imageNamed:@"facebook" ] resizableImageWithCapInsets:imageInsets];
    
    UIImage *image = [[UIImage imageNamed:@"web337.bundle/FBLoginViewButtonE.png" ] resizableImageWithCapInsets:imageInsets];
    
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    
    
    
    /*
    image = [[UIImage imageNamed:@"fbicon" ] resizableImageWithCapInsets:imageInsets];
    [self.button setBackgroundImage:image forState:UIControlStateHighlighted];
    */

    
    
    
    [self addSubview:self.button];
    
    // Compute the text size to figure out the overall size of the button
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    float textSizeWidth = [[ElxStrings get:Elx_STR_fblogin] sizeWithFont:font].width;

    // We make the button big enough to hold the image, the text, the padding to the right of the f and the end cap
    g_buttonSize = CGSizeMake(image.size.width + textSizeWidth + kButtonPaddingWidth + kButtonEndCapWidth, image.size.height);
    
    // add a label that will appear over the button
    self.label = [[[ElxFBShadowLabel alloc] init] autorelease];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
#ifdef __IPHONE_6_0
    self.label.textAlignment = NSTextAlignmentCenter;
#else
    self.label.textAlignment = UITextAlignmentCenter;
#endif
    self.label.backgroundColor = [UIColor clearColor];
    
    self.label.font = font;
    self.label.textColor = [UIColor whiteColor];
    
    self.label.text = [ElxStrings get:Elx_STR_fblogin];

    
    [self addSubview:self.label];
    // We force our height to be the same as the image, but we will let someone make us wider
    // than the default image.
    CGFloat width = MAX(self.frame.size.width, g_buttonSize.width);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              width, image.size.height);
    self.frame = frame;
    
    CGRect buttonFrame = CGRectMake(0, 0, width, image.size.height);
    self.button.frame = buttonFrame;
    
    // This needs to start at an x just to the right of the f in the image, the -1 on both x and y is to account for shadow in the image
    self.label.frame = CGRectMake(image.size.width - kButtonPaddingWidth - 1, -0, width - (image.size.width - kButtonPaddingWidth) - kButtonEndCapWidth, image.size.height);
    //self.label.backgroundColor = [UIColor greenColor];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(g_buttonSize.width, g_buttonSize.height);
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"
@end

@implementation ElxFBShadowLabel

- (void) drawTextInRect:(CGRect)rect {
    CGSize myShadowOffset = CGSizeMake(0, -1);
    CGFloat myColorValues[] = {0, 0, 0, .3};
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
    CGContextSetShadowWithColor (myContext, myShadowOffset, 1, myColor);
    
    [super drawTextInRect:rect];
    
    CGColorRelease(myColor);
    CGColorSpaceRelease(myColorSpace);
    
    CGContextRestoreGState(myContext);}

@end

