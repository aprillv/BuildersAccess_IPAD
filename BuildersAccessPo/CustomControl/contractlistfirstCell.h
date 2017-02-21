//
//  contractlistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/22/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"
@protocol contractlistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface contractlistfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<contractlistfirstCellDelegate> delegate;

@end
