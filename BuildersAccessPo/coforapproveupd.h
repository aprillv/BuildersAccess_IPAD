//
//  coforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfCODetail.h"

@interface coforapproveupd : mainmenuaaa{
    wcfCODetail* result;
    int xtype;
    UIScrollView *uv;
    UIButton *btnNext;
}

@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *idcia;
@property bool isfromapprove;
@property(copy, nonatomic) NSString *aattile;
@end
