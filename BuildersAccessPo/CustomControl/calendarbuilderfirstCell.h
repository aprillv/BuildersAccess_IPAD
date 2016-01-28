//
//  calendarbuilderfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol calendarbuilderfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface calendarbuilderfirstCell : UITableViewCell

@property (nonatomic, strong) id<calendarbuilderfirstCellDelegate> delegate;

@end
