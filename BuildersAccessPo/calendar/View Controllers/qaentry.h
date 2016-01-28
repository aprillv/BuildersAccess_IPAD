//
//  qaentry.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfCalendarQA.h"


@interface qaentry : mainmenuaaa< UIAlertViewDelegate>{
    
    UITextField *txtSubject;
    UITextField *txtLocation;
    UITextField *txtContractNm;
    UITextField *txtPhone;
    UITableView *Mobile;
    UITableView *Email;
    UIButton *txtDate;
    UIButton *txtStart;
    UIButton *txtEnd;
    UITextView *txtNote;
    UITextField *txtcharge;
    
    UIActionSheet* actionSheet;
    NSArray * pickerArrayStart;
    NSArray * pickerArrayEnd;
    
    UIDatePicker *pdate;
    UIPickerView *pstart;
    UIPickerView *pend;
wcfCalendarQA* result;
    
    UIScrollView *uv;
    UITableView *phone;
    UIButton*  btnNext;
}
@property(copy, nonatomic) NSString *idnumber;
@property int fromtype;
@end
