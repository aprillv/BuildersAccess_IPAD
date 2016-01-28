//
//  ciaList.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "mainmenuaaa.h"

@interface ciaList : mainmenuaaa< UIAlertViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    UISearchBar *searchtxt;
}

@property (nonatomic, retain) NSMutableArray  *ciaListresult;

@property  int islocked;
@end
