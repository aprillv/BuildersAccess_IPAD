//
//  calendarforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface calendarforapprove : mainmenuaaa<CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}

@property int mxtype;
@property (retain, nonatomic) NSMutableArray *rtnlist;

@property (retain, nonatomic)UITableView *tbview;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@property(copy, nonatomic) NSString *masterciaid;
@end
