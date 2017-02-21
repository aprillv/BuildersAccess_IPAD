//
//  phonelistCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "phonelistCell.h"

@implementation phonelistCell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
}


@synthesize Name, Title, Email;

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
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, self.frame.size.width*0.27, 44)];
        lblname.text=Name;
        //    lblname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: lblname];
        tx=tx +self.frame.size.width*0.27;
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, self.frame.size.width*0.27, 44)];
        lblpname.text=Title;
        //    lblpname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: lblpname];
        tx=tx+self.frame.size.width*0.27;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: label];
        tx=tx+3;
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, self.frame.size.width-tx, 44)];
        lblid.text=Email;
        //    lblid.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: lblid];
        
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
