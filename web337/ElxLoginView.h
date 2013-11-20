//
//  ElxLoginView.h
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElxBaseView.h"
#import "ElxButton.h"
#import "ElxFBLogin.h"

@interface ElxLoginView : ElxBaseView

@property (assign,nonatomic) BOOL FacebookSupport;
@property (assign,nonatomic) BOOL GameCenterSupport;

@property (retain,nonatomic) UITextField *username;
@property (retain,nonatomic) UITextField *password;

@property (retain,nonatomic) ElxButton *loginButton;
@property (retain,nonatomic) ElxButton *regButton;
@property (retain,nonatomic) ElxButton *forgetPass;

@property (retain,nonatomic) ElxFBLogin *fbLogin;

@end
