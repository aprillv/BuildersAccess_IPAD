//
//  vpolistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/16/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@protocol vpolistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end


@interface vpolistfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<vpolistfirstCellDelegate> delegate;

@end
