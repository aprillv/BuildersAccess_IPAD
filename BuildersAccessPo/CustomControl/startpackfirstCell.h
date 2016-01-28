//
//  startpackfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol startpackfirstCellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface startpackfirstCell : UITableViewCell

@property (nonatomic, strong) id<startpackfirstCellDelegate> delegate;


@end
