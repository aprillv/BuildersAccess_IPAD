//
//  Login.h
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-1.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fViewController.h"
#import "CustomKeyboard.h"
#import "userInfo.h"
#import "MBProgressHUD.h"

@interface Login : fViewController<UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate> {
    CustomKeyboard *keyboard;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain)  UITextField         *usernameField;
@property (weak, nonatomic) IBOutlet UINavigationBar *aaa;
@property (nonatomic, retain)  UITextField         *passwordField;
//@property (nonatomic, retain)  UIButton            *checkButton;
@property (nonatomic, assign) bool                         ischecked;
@property (nonatomic, retain) NSString                     *pwd;
//@property(nonatomic, retain)  UIButton *dd1;
@property (retain, nonatomic) NSArray * pickerArray;
@property(nonatomic, retain) UIPickerView *ddpicker;

@end
