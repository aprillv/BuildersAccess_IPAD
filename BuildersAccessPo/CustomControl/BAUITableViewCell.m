//
//  BAUITableViewCell.m
//  BuildersAccess
//
//  Created by April on 4/12/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@implementation BAUITableViewCell
- (void) layoutSubviews {
    [super layoutSubviews];
//    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width - 50, 44);
    self.textLabel.frame = CGRectMake(10, 0, self.frame.size.width - 50, 44);
    CGFloat fl = 1.0/[[UIScreen mainScreen] scale];
    UIView *label1 = [[UIView alloc] initWithFrame: CGRectMake( 0, 44-fl, self.frame.size.width, fl)];
    label1.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label1];
   
    if (self.accessoryType != UITableViewCellAccessoryNone)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 25, 44)];
        img.contentMode = UIViewContentModeCenter;
        img.image = [UIImage imageNamed:@"ios7-arrow-right"];
        [self.contentView addSubview:img];
    }
//    self.accessoryView.frame = CGRectMake(self.frame.size.width - 50, 0, 50, 44);
    

}
//

@end
