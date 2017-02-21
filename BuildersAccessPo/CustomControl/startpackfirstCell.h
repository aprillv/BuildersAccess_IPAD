//
//  startpackfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@protocol startpackfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface startpackfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<startpackfirstCellDelegate> delegate;


@end
