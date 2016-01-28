//
//  firstcell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol firstcellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface firstcell : UITableViewCell

@property (nonatomic, strong) id<firstcellDelegate> delegate;

@end
