//
//  forapprovepocials.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"
#import "wcfArrayOfKeyValueItem.h"

@interface forapprovepocials : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}

@property  (retain, nonatomic) NSMutableArray* result;
@property  (retain, nonatomic) NSMutableArray* result1;
@property int mxtype;
@property(copy, nonatomic) NSString *masterciaid;
@property(copy, nonatomic) NSString *atitle;

@end
