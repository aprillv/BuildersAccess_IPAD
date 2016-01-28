//
//  vendorlistfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol vendorlistfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface vendorlistfirstCell : UITableViewCell

@property (nonatomic, strong) id<vendorlistfirstCellDelegate> delegate;


@end
