//
//  forapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "mainmenuaaa.h"

@interface forapprove : mainmenuaaa{
    int xtype;
    NSString *potitle;
    UITableView *tbview;
    UIButton *btnNext;
}
@property (retain, nonatomic) NSMutableArray *rtnlist;

@property(copy, nonatomic) NSString *mastercia;

@end
