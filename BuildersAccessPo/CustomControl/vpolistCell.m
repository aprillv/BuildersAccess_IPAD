//
//  vpolistCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/16/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "vpolistCell.h"

@implementation vpolistCell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
    UILabel *lblstatus;
}


@synthesize RequesteNo, Requested, Project, Nvendor, Total;

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
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( 5, 3, 40, 39)];
        lblid.text=RequesteNo;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( 45, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( 50, 3, 90, 40)];
        lblname.text=Requested;
        [self.contentView addSubview: lblname];
        label = [[UILabel alloc] initWithFrame: CGRectMake( 140, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( 148, 3, 233, 40)];
        lblpname.text=Project;
        [self.contentView addSubview: lblpname];
        
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 381, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 385, 3, 257, 40)];
        lblstatus.text=Nvendor;
        [self.contentView addSubview: lblstatus];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 642, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 646, 3, 75, 40)];
        lblstatus.text=Total;
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
