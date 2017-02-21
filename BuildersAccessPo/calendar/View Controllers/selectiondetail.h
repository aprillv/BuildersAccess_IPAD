//
//  selectiondetail.h
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fViewController.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@class wcfCalendarEntryItem;

@interface selectiondetail : fViewController<UITextViewDelegate, UITextFieldDelegate, CustomKeyboardDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>{
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
@end
