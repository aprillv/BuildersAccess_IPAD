//
//  vpoupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-22.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "wcfvpoDetail.h"

@interface vpoupd : mainmenuaaa<UIAlertViewDelegate, CustomKeyboardDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIScrollView *uv;
    CustomKeyboard *keyboard;
    UIButton *dd1;
    NSMutableArray * pickerArray;
//    UIPickerView *ddpicker;
//    UIDatePicker *pdate;
    UIButton *txtDate;
    UITextView *txtNote;
    UITextField *txtTotal;
   
    UIButton* loginButton1;
    UIButton* loginButton2;
    wcfvpoDetail *pd;
    UIImageView  *imageView;
    UIImage *myphoto;
    UIButton *btn1;
    UIButton *btnNext;
    UIPopoverController* popoverController;
}

@property(nonatomic, retain) NSString *xidproject;
@property(nonatomic, retain) NSString *xidvpo;


@end
