//
//  developmentCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "developmentCell.h"

@implementation developmentCell{UILabel *lblid;
UILabel *lblname;
UILabel *lblpname;
UILabel *lblstatus;
}

@synthesize idproject, projectname, status;

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
        int tx=2;
        int dw =self.frame.size.width;
        
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 110, 44)];
        lblid.text=idproject;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        tx=tx+110;
        dw=dw-112;
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*.8, 44)];
        lblname.text=projectname;
        [self.contentView addSubview: lblname];
        tx=tx+dw*.8;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        tx=tx+3;
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw+112-tx, 44)];
        lblstatus.text=status;
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
