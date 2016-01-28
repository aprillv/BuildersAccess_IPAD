//
//  favorite.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "mainmenuaaa.h"

@interface favorite : mainmenuaaa< UISearchBarDelegate,CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UITableView *tbview;
    UISearchBar *searchBar;
}

@end
