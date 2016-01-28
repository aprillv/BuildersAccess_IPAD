//
//  bustoutls.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfArrayOfStartPackItem.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface bustoutls : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate>{
    CustomKeyboard *keyboard;
//    UIScrollView *uv;
    NSMutableArray* result1;
    NSMutableArray* result;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    int currentpage;
    int pageNo;
    UIButton *btnNext;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSString *masterciaid;

@end
