//
//  BAUITableViewCell.m
//  BuildersAccess
//
//  Created by April on 4/12/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "BAUITableViewCell.h"

@implementation BAUITableViewCell{
    UIView *line;
    UIImageView *img;
    
}
- (void) layoutSubviews {
    [super layoutSubviews];
//    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width - 50, 44);
    if (self.imageView.image == nil) {
        CGRect f = self.textLabel.frame;
        f.origin.x = 10;
        self.textLabel.frame = f;
        f = self.detailTextLabel.frame;
        f.origin.x = 10;
        self.detailTextLabel.frame = f;
    }else{
        CGRect f = self.imageView.frame;
        f.origin.x = 10;
        self.imageView.frame = f;
         f = self.textLabel.frame;
        f.origin.x = 20 + self.imageView.frame.size.width;
        self.textLabel.frame = f;
        f = self.detailTextLabel.frame;
        f.origin.x = 20 + self.imageView.frame.size.width;
        self.detailTextLabel.frame = f;
    }
   
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    UITableView *tableView = (UITableView *)view;
//    NSLog(@"%f  %d", tableView.rowHeight, tableView.separatorStyle);
//
//    if(tableView.separatorColor != [UIColor clearColor] &&
//       tableView.separatorStyle != UITableViewCellSeparatorStyleNone
//       && tableView.separatorColor != [UIColor whiteColor]){
        CGFloat fl = 1.0/[[UIScreen mainScreen] scale];
    
        if (!line && self.frame.size.height >= 44.0) {
            UIView *label1 = [[UIView alloc] initWithFrame: CGRectMake( 0, self.frame.size.height-fl, self.frame.size.width, fl)];
            line = label1;
            label1.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
            [self.contentView addSubview: label1];

        }
//    }
//     CGFloat fl = 1.0/[[UIScreen mainScreen] scale];
    line.frame = CGRectMake( 0, self.frame.size.height-fl, self.frame.size.width, fl);

//    self.textLabel.frame = CGRectMake(10, 0, self.frame.size.width - 50, 44);
    
   
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (!img) {
            img = [[UIImageView alloc]init];
            img.contentMode = UIViewContentModeCenter;
            img.frame = CGRectMake(self.frame.size.width - 40, (self.frame.size.height - 20)/2.0, 20, 20);
            img.image = [UIImage imageNamed:@"ios7-arrow-right"];
            [self.contentView addSubview:img];
        }

    }
    
    if (self.accessoryView) {
        img.frame = CGRectMake(self.frame.size.width - 40, (self.frame.size.height - 20)/2.0, 20, 20);
    }else{
        if (img){
            img.frame = CGRectMake(self.frame.size.width - 40, (self.frame.size.height - 20)/2.0, 20, 20);
        }
    }
    
    

}
//

@end
