//
//  cntlistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"


@protocol cntlistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface cntlistfirstCell : BAUITableViewCell

@property (nonatomic, strong) id<cntlistfirstCellDelegate> delegate;
@property (nonatomic, retain)  NSString         *cname;


@end
