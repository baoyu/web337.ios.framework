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

@end

@implementation ElxButton

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

-(void)dealloc{
    [_normal release];
    [_highlight release];
    [super dealloc];
}
@end