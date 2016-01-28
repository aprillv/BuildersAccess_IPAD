//
//  cl_config.h
//  BuildersAccess
//
//  Created by amy zhao on 13-6-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_config : NSCoder
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)getIsTwoPart;
-(void)setIsTwoPart: (BOOL)value;
@end
