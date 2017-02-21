//
//  vpopendinglsViewController.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-22.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface vpopendinglsViewController : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    NSMutableArray* result1;
    NSMutableArray *result;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    UIButton *btnNext;
}

@property (nonatomic, retain) NSString *idproject;

@end
