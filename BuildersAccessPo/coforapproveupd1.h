//
//  coforapproveupd1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "wcfUserCOEmail.h"

@interface coforapproveupd1 : mainmenuaaa<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    wcfUserCOEmail* result;
    UILabel *lbl0;
    UITableView *lbl1;
    int ctag;
    UIScrollView *uv;
     UIButton *btnNext;
    UILabel *lbl02;
}

@property(nonatomic, retain)  UIButton *dd1;
@property (retain, nonatomic) NSArray * pickerArray;
@property(nonatomic, retain) UIPickerView *ddpicker;

@property(copy, nonatomic) NSString *idcia;

@property(copy, nonatomic) NSString *idco1;
@property bool isfromapprove;
@property int xtype;

@property(copy, nonatomic) NSString *aattile;

@end
