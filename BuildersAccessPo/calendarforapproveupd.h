//
//  calendarforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "wcfCalendarEntryItem.h"
#import "MBProgressHUD.h"

@interface calendarforapproveupd : mainmenuaaa<UITextViewDelegate, UITextFieldDelegate, CustomKeyboardDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>{
    UITextField *txtSubject;
    UITextField *txtLocation;
    UITextField *txtContractNm;
    UITextField *txtPhone;
    UITextField *txtMobile;
    UITextField *txtemail;
    UIButton *txtDate;
    UIButton *txtStart;
    UIButton *txtEnd;
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    UITextField *txtcharge;
    
    UIActionSheet* actionSheet;
     NSArray * pickerArrayStart;
     NSArray * pickerArrayEnd;
    
    UIDatePicker *pdate;
    UIPickerView *pstart;
    UIPickerView *pend;
    wcfCalendarEntryItem* result;
    MBProgressHUD *HUD;
    UIButton *btnNext;
    UIScrollView *uv;
    
}
@property(copy, nonatomic) NSString *idnumber;
@property int xmtype;

@end
