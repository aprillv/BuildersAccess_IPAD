//
//  polistcell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "polistcell.h"

@implementation polistcell{
    UILabel *lblid;
    UILabel *lblname;
    UILabel *lblpname;
    UILabel *lblstatus;
}


@synthesize Doc, Nvendor, Shipto, Nproject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect{
    if (!lblid) {
        int tx=2;
        int dw =self.frame.size.width;
        
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 133, 44)];
        lblid.text=Doc;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        tx=tx+133;
        dw=dw-135;
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*0.22+1, 44)];
        lblname.text=Nproject;
        [self.contentView addSubview: lblname];
        tx=tx+dw*.22+1;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*.3+1, 44)];
        lblpname.text=Nvendor;
        [self.contentView addSubview: lblpname];
        tx=tx+dw*.3+1;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw+135-tx, 44)];
        lblstatus.text=[Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
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
