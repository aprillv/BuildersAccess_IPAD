//
//  projectls.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-11.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface projectls : mainmenuaaa<UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UISearchBar *searchtxt;
    UIButton *btnNext;
}

@property (retain, nonatomic) NSString *atitle;
@property (retain, nonatomic)UITableView *tbview;
@property  int islocked;
@property BOOL isfrommainmenu;
@end
