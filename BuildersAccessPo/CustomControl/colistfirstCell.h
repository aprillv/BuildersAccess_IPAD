//
//  colistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"


@protocol colistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface colistfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<colistfirstCellDelegate> delegate;

@end
