//
//  phonelistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol phonelistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface phonelistfirstCell : UITableViewCell

@property (nonatomic, strong) id<phonelistfirstCellDelegate> delegate;

@end

