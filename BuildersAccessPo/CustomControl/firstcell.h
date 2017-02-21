//
//  firstcell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@protocol firstcellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface firstcell : BAUITableViewCell

@property (nonatomic, strong) id<firstcellDelegate> delegate;

@end
