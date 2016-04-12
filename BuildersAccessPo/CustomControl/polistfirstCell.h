//
//  polistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol polistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface polistfirstCell : UITableViewCell
@property (nonatomic, strong) id<polistfirstCellDelegate> delegate;

@end
