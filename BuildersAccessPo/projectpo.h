//
//  projectpo.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"

@interface projectpo : mainmenuaaa
@property (nonatomic, retain) NSString *idproject;
@property (nonatomic, retain) NSString *idvendor;
@property (nonatomic, retain) NSString *idmaster;
@property int xtype;
@property int isfromdevelopment;
@property (nonatomic, retain) NSMutableArray* result;
@end
