//
//  projectCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@interface projectCell : BAUITableViewCell
//-(void)SetDetailWithId:(NSString *)idd withName:(NSString *)name WithPname:(NSString *)pname WithStatus:(NSString *)status;
@property (nonatomic, retain)  NSString         *idproject;
@property (nonatomic, retain)  NSString         *projectname;
@property (nonatomic, retain)  NSString         *planname;
@property (nonatomic, retain)  NSString         *status;
@end
