//
//  coforapprovecials.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface coforapprovecials : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    NSMutableArray* result1;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    UIButton *btnNext;
}

@property(copy, nonatomic) NSString *mastercia;
@property  (retain, nonatomic) NSMutableArray* result;

@end
