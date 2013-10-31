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

//self.tableView viewWithTag tag0 是tableview本身，所以需要占位
typedef enum {
    ElxInputCellType_Table_View,
    ElxInputCellType_Login_Username,
    ElxInputCellType_Login_Password,
    ElxInputCellType_Reg_Username,
    ElxInputCellType_Reg_Email,
    ElxInputCellType_Reg_Password,
    ElxInputCellType_Reg_RePassword,
} ElxLoginInputCellType;


//self.tableView viewWithTag tag0 是tableview本身，所以需要占位
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




