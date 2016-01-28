//
//  bustoutdetail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfBustOutItem.h"

@interface bustoutdetail : mainmenuaaa{
    UIScrollView *uv;
    UIButton *dd1;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    UIDatePicker *pdate;
    UIButton *txtDate;
    UITextView *txtNote;
    UITextField *txtTotal;
    UIButton* loginButton1;
    UIButton* loginButton2;
    wcfBustOutItem *pd;
    UIImageView  *imageView;
    UIImage *myphoto;
    UIButton *btn1;
    UIButton *btnNext;
}

@property(nonatomic, retain) NSString *xidproject;
@property(nonatomic, retain) NSString *xidbustout;

@end
