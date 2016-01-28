//
//  poassembly.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface poassembly : mainmenuaaa< UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UISearchBar *searchtxt;
    UIButton *btnNext;
    UIScrollView *uv;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;

@property (retain, nonatomic)UITableView *tbview;

@property (retain, nonatomic)NSString *idproject;
@property (retain, nonatomic)NSString *idmaster;
@property int xtype;
@property  int islocked;
@end
