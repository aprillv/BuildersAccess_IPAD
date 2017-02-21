//
//  contractforapproveupd1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "wcfKeyValueItem.h"

@interface contractforapproveupd1 : mainmenuaaa<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    wcfKeyValueItem* result;
    UILabel *lbl0;
    UITableView *lbl1;
    UIButton *dd1;
    NSArray * pickerArray;
    UIPickerView *ddpicker;
    int ctag;
    UIScrollView *uv;
    UIButton *btnNext;
}
@property(copy, nonatomic) NSString *atitle;

@property(copy, nonatomic) NSString *idcia;
@property(copy, nonatomic) NSString *idcontract1;
@property(copy, nonatomic) NSString *idproject;
@property(copy, nonatomic) NSString *projectname;

@property int xtype;

@end
