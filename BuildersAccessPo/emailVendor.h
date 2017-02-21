//
//  emailVendor.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-7.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"

@class  wcfPODetail;

@interface emailVendor : mainmenuaaa

@property(retain, nonatomic) wcfPODetail *pd;
@property (nonatomic, retain) NSString *xidvendor;
@property(copy, nonatomic) NSString *poid;
@property int fromforapprove;
@property int xtype;
@end
