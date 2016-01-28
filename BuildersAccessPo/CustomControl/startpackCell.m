//
//  startpackCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "startpackCell.h"

@implementation startpackCell{
    UILabel *lblpname;
    UILabel *lblname;
}


@synthesize cname, cvalue;
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    if (!lblname) {
        
    int tx=2;
    int dw=self.frame.size.width;
    lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*.35, 44)];
    lblname.text=cname;
    //    lblname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview: lblname];
    tx=tx +dw*.35;
    
    UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview: label];
    tx=tx+3;
    
    lblpname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw-tx, 44)];
    lblpname.text=cvalue;
    //    lblpname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview: lblpname];
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( 0, 43, self.frame.size.width, 1)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview: label];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
