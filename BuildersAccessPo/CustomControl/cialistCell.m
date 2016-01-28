//
//  cialistCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "cialistCell.h"

@implementation cialistCell{
    UILabel *lblpname;
    UILabel *lblname;
}

@synthesize Id, Cname;

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
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 110, 44)];
        lblname.text=Id;
        //    lblname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: lblname];
        tx=tx +110;
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, self.frame.size.width-tx, 44)];
        lblpname.text=Cname;
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
