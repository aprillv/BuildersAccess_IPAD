//
//  polbl.h
//  BuildersAccess
//
//  Created by roberto ramirez on 12/6/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface polbl : UILabel
@property (nonatomic, retain)  NSString         *desc;
@property (nonatomic, retain)  NSString         *qty;
@property (nonatomic, retain)  NSString         *price;
@property (nonatomic, retain)  NSString         *total;
@property BOOL istwocolomum;
@property BOOL isfirst;

@end
