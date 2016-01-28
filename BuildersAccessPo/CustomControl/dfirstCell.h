//
//  dfirstCell.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dfirstcellDelegate

//@optional
-(void)doaClicked:(NSString *)str :(BOOL)isup;
@end

@interface dfirstCell : UITableViewCell
@property (nonatomic, strong) id<dfirstcellDelegate> delegate;
@end
