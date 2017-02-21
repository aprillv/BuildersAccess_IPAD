//
//  dfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@protocol dfirstcellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface dfirstCell : BAUITableViewCell
@property (nonatomic, strong) id<dfirstcellDelegate> delegate;
@end
