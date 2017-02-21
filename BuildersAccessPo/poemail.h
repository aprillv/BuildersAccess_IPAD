//
//  poemail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfPODetail.h"
#import "CustomKeyboard.h"

@interface poemail : mainmenuaaa<UITextViewDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UIButton *txtDate;
    bool isreleased;
    bool isDraftorForapprove;
    NSString *oldemail;
    NSString *oldStatus;
    wcfPODetail *pd;    UIButton *btnNext;
    UIScrollView *uv;
}

@property(copy, nonatomic) NSString *idpo1;
@property(copy, nonatomic) NSString *xmcode;
@property(nonatomic, retain)  UIButton *dd1;
@property(copy, nonatomic) NSString *idvendor;
@property (retain, nonatomic) NSMutableArray * pickerArray;
@property int xtype;
@property bool isfromassign;
@property(nonatomic, retain)  UITextView *txtNote;

@end
