//
//  ElxRegisterView.h
//  web337
//
//  Created by elex on 13-10-30.
//  Copyright (c) 2013年 337. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElxButton.h"
#import "ElxBaseView.h"

@interface ElxRegisterView : ElxBaseView

@property (retain,nonatomic) UITextField *username;
@property (retain,nonatomic) UITextField *email;
@property (retain,nonatomic) UITextField *password;
@property (retain,nonatomic) UITextField *repassword;

@property (retain,nonatomic) ElxButton *submitButton;
@property (retain,nonatomic) ElxButton *backToLogin;

@end
