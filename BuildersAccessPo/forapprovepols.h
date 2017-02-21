//
//  forapprovepols.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface forapprovepols: mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate, UIAlertViewDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}
@property  (retain, nonatomic) NSMutableArray* result;
@property  (retain, nonatomic) NSMutableArray* result1;
@property  (retain, nonatomic) NSString* atitle;
@property int mxtype;
@end
