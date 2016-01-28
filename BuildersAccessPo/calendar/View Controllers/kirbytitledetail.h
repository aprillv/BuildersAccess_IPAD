//
//  kirbytitledetail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-6-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
@class wcfCalendarEntryItem;

@interface kirbytitledetail : fathercontroller< UIAlertViewDelegate>{
   
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
    wcfCalendarEntryItem* result;
    
    UIView *uv;
    UITableView *phone;
//    UIButton*  btnNext;
}
@property(copy, nonatomic) NSString *idnumber;


@end
