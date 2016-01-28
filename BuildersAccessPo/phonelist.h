//
//  phonelist.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface phonelist : mainmenuaaa<UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate >{
    CustomKeyboard *keyboard;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (retain, nonatomic)UITableView *tbview;

@property BOOL isfrommainmenu;
@end
