//
//  contractforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface contractforapprove : mainmenuaaa<CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;

@property (retain, nonatomic)UITableView *tbview;
@property (retain, nonatomic) NSMutableArray *rtnlist1;

@end
