//
//  requestedvpols.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "CustomKeyboard.h"

@interface requestedvpols : mainmenuaaa<UISearchBarDelegate, CustomKeyboardDelegate, UIAlertViewDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
}


@property  (retain, nonatomic) NSMutableArray* result;
@property  (retain, nonatomic) NSMutableArray* result1;
@property  int xtype;
@property  (retain, nonatomic) NSString* idproject;
@end
