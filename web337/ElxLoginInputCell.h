//
//  ElxLoginInputCell.h
//  web337
//
//  Created by elex on 13-8-26.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface ElxLoginInputCell : UITableViewCell

@property (nonatomic,assign) id<UITextFieldDelegate> inCellTextFieldDelgeate;

+(void)removeAllTextfields;

-(void)configureRegAtIndexPath:(NSIndexPath *)indexPath defaultValues:(NSMutableArray *) arr inPortrait:(BOOL) p;

-(void)configureLoginAtIndexPath:(NSIndexPath *)indexPath defaultValues:(NSMutableArray *) arr inPortrait:(BOOL) p;

@end


