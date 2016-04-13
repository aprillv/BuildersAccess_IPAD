//
//  suggestfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/16/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@protocol suggestfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface suggestfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<suggestfirstCellDelegate> delegate;

@end
