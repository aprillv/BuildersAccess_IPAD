//
//  bustoutupg.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface bustoutupg : mainmenuaaa<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    UIScrollView *uv;
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
    UIPickerView *ddpicker;
     UIButton *btnNext;
}
@property (nonatomic, retain) NSString *xidproject;
@property (nonatomic, retain) NSString *xidcontract;
@property(copy, nonatomic) NSString *xidnum;
@property(nonatomic, retain)NSString *atitle;
@property int xtype;


@end
