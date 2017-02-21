//
//  calendarbuilderCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "calendarbuilderCell.h"

@implementation calendarbuilderCell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
    UILabel *lblstatus;
}

@synthesize Reschedule, Requested, Subject, Original;

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
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( 5, 3, 108, 40)];
        lblname.text=Requested;
        [self.contentView addSubview: lblname];
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( 113, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( 115, 3, 383, 40)];
        lblpname.text=Subject;
        [self.contentView addSubview: lblpname];
        
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 499, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( 502, 3, 108, 40)];
        lblstatus.text=Original;
        [self.contentView addSubview: lblstatus];
        
        
        label = [[UILabel alloc] initWithFrame: CGRectMake(610, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( 613, 3, 110, 40)];
        lblid.text=Reschedule;
        lblid.textColor=[UIColor blackColor];
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
