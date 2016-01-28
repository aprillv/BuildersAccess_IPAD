//
//  projectCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "projectCell.h"

@implementation projectCell{
    UILabel *lblid;
     UILabel *lblname;
     UILabel *lblpname;
     UILabel *lblstatus;
}

@synthesize idproject, projectname, planname, status;

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
        
        lblid = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 67, 44)];
        lblid.text=idproject;
        lblid.textColor=[UIColor blackColor];
        [self.contentView addSubview: lblid];
        tx=tx+67;
        
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*.28, 44)];
        lblname.text=projectname;
        [self.contentView addSubview: lblname];
        tx=tx+dw*.28;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblpname = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw*0.48, 44)];
        lblpname.text=planname;
        [self.contentView addSubview: lblpname];
        tx=tx+dw*0.48;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+3;
        
        lblstatus = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, dw-tx, 44)];
        lblstatus.text=status;
        [self.contentView addSubview: lblstatus];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( 0, 43, self.frame.size.width, 1)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: label];
    }
    
}

//-(void)SetDetailWithId:(NSString *)idd withName:(NSString *)name WithPname:(NSString *)pname WithStatus:(NSString *)status{
//    [lblid setText:idd];
//    [lblname setText:name];
//    [lblpname setText:pname];
//    [lblstatus setText:status];
//   
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
