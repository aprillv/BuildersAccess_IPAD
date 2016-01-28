//
//  sugestlistCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/16/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "sugestlistCell.h"

@implementation sugestlistCell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
    UILabel *lblstatus;
}

@synthesize idproject, project, sqft, sugestprice, formula;

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
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( 5, 3, 70, 39)];
        lblid.text=idproject;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( 75, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( 76, 3, 302, 40)];
        lblname.text=project;
        [self.contentView addSubview: lblname];
        label = [[UILabel alloc] initWithFrame: CGRectMake( 378, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( 379, 3, 80, 40)];
        lblpname.text=sqft;
        lblpname.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview: lblpname];
        
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 459, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 460, 3, 130, 40)];
        lblstatus.text=sugestprice;
        lblstatus.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview: lblstatus];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 590, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 591, 3, 130, 40)];
        lblstatus.text=formula;
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
