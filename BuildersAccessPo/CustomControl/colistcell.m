//
//  colistcell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "colistcell.h"

@implementation colistcell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
    UILabel *lblstatus;
}

@synthesize Number, sDate, Project, Total, Sales;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    if (!lblid) {
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( 5, 3, 60, 39)];
        lblid.text=Number;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( 65, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( 70, 3, 100, 40)];
        lblname.text=sDate;
        [self.contentView addSubview: lblname];
        label = [[UILabel alloc] initWithFrame: CGRectMake( 170, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( 175, 3, 308, 40)];
        lblpname.text=Project;
        [self.contentView addSubview: lblpname];
        
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 483, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 487, 3, 137, 40)];
        lblstatus.text=Sales;
        [self.contentView addSubview: lblstatus];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 624, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 628, 3, self.frame.size.width-630, 40)];
        lblstatus.text=Total;
        lblstatus.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblstatus.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview: lblstatus];
        
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
