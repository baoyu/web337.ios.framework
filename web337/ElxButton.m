//
//  ElxButton.m
//  SDKSample
//
//  Created by elex on 13-9-25.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import "ElxButton.h"

@interface ElxButton()

@property (retain,nonatomic) UIColor *normal;
@property (retain,nonatomic) UIColor *highlight;
@property (assign,nonatomic) BOOL imgPosRight;

@end

@implementation ElxButton

const int LB_IMG_PAD = 3;

@synthesize imgPosRight;

#pragma mark Settings

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.normal = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}

- (void)setHighlightColor:(UIColor *)backgroundColor {
    self.highlight = backgroundColor;
}

#pragma mark Actions

- (void)didTapButtonForHighlight:(UIButton *)sender {
    [super setBackgroundColor:self.highlight];
}

- (void)didUnTapButtonForHighlight:(UIButton *)sender {
    [super setBackgroundColor:self.normal];
}

#pragma mark Initialization

- (void)setupButton {
    [self addTarget:self action:@selector(didTapButtonForHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpOutside];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (void)putImageRight:(BOOL)right{
    imgPosRight = right;
}

- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    if(self.imageView.image != Nil){
        UIImageView *imageView = [self imageView];
        UILabel *label = [self titleLabel];

        CGRect imageFrame = imageView.frame;
        CGRect labelFrame = label.frame;
        CGRect btnFrame = self.frame;
        
        
        if(imgPosRight){
            float w = btnFrame.size.width,
            lw = labelFrame.size.width,
            iw = imageFrame.size.width;
            labelFrame.origin.x = (w - (lw + iw + LB_IMG_PAD))/2;
            imageFrame.origin.x = labelFrame.origin.x + lw + LB_IMG_PAD;
        }else{
            float w = btnFrame.size.width,
            lw = labelFrame.size.width,
            iw = imageFrame.size.width;
            imageFrame.origin.x = (w - (lw + iw + LB_IMG_PAD))/2;
            labelFrame.origin.x = imageFrame.origin.x + iw + LB_IMG_PAD;
        }
        imageView.frame = imageFrame;
        label.frame = labelFrame;
    }
}

-(void)dealloc{
    [_normal release];
    [_highlight release];
    [super dealloc];
}
@end