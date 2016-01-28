//
//  requestpoemail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfPODetail.h"
#import "CustomKeyboard.h"

@interface requestpoemail :mainmenuaaa <UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
}


@property(copy, nonatomic) NSString *aemail;
@property(copy, nonatomic) NSString *idnum;
@property (retain, nonatomic) NSMutableArray * pickerArray;
@property(nonatomic, retain) UIPickerView *ddpicker;
@property int xtype;
@property bool isfromassign;
@property(nonatomic, retain)  UITextView *txtNote;


@property(copy, nonatomic) NSString *xxreason;
@property(copy, nonatomic) NSString *xxtotle;
@property(copy, nonatomic) NSString *xxdate;
@property(copy, nonatomic) NSString *xxstr;
@property(copy, nonatomic) NSString *xxnotes;
@property int fromforapprove;
@end
