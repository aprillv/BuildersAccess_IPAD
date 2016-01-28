//
//  newpoqtyls.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface newpoqtyls : mainmenuaaa<UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIScrollView *uv;
    UIPopoverController *popoverController;
    CustomKeyboard *keyboard;
    UIButton *dd1;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    UIDatePicker *pdate;
    UIButton *txtDate;
    UITextView *txtNote;
    UITextField *txtTotal;
    
    UIImage *myphoto;
    UIButton *btn1;
    UIButton* loginButton;
    UIImageView  *imageView;
    UIButton *btnNext;
}

@property(nonatomic, retain) NSString *xidproject;
@property(nonatomic, retain) NSString *xidvendor;
@property(nonatomic, retain) NSString *xnvendor;
@property(nonatomic, retain) NSString *xidreason;
@property(nonatomic, retain) NSString *xnreason;

@end
