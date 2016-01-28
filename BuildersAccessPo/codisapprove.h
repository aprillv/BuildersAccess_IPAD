//
//  codisapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface codisapprove : mainmenuaaa<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    UIButton *btnNext;
}
@property(nonatomic, retain)  UIButton *dd1;
@property(nonatomic, retain)  NSString *xemail;
@property(nonatomic, retain)  NSString *xmsg;
@property(retain, nonatomic) NSArray * pickerArray;
@property(nonatomic, retain) UIPickerView *ddpicker;

@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *calendardata;
@property BOOL disapprove;
@end
