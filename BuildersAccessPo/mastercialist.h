//
//  mastercialist.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"
#import "mainmenuaaa.h"

@interface mastercialist : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    MBProgressHUD *HUD;
    UISearchBar * searchtxt;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@property int type;
@property (retain, nonatomic) NSString *atitle;
@end
