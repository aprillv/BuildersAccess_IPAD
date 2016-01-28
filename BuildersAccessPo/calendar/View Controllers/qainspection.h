//
//  qainspection.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface qainspection : mainmenuaaa<CustomKeyboardDelegate, UITextViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>{
    UIScrollView *uv;
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    UIButton *btnNext;
    MBProgressHUD * HUD;
}

@property(copy, nonatomic) NSString *idnumber;
@property int fromtype;
@end
