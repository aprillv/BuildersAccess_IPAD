//
//  suggestforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface suggestforapprove : mainmenuaaa<CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
    UISearchBar *searchBar;
    UIButton *btnNext;
    UIScrollView *sv;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (retain, nonatomic)UITableView *tbview;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@property(copy, nonatomic) NSString *masterciaid;


@end
