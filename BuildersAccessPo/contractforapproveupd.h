//
//  contractforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfContractEntryItem.h"

@interface contractforapproveupd : mainmenuaaa{
    wcfContractEntryItem* result;
    int xtype;
    UITableView *ciatbview;
    UIScrollView *uv;
    UIView *subview;
    UIButton *btnNext;
}


@property(copy, nonatomic) NSString *oidcia;
@property(copy, nonatomic) NSString *atitle;
@property(copy, nonatomic) NSString *ocontractid;

@property int xfromtype;

@end
