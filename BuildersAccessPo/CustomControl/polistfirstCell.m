//
//  polistfirstCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "polistfirstCell.h"

@implementation polistfirstCell{
    BOOL docup;
    BOOL vendorup;
    BOOL shipup;
    BOOL statusup;
}

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        docup =NO;
        vendorup=NO;
        shipup=NO;
        statusup=NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    int tx=0;
    int dw =self.frame.size.width;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, 135, 44)];
    
    [btn1 setTitle:@"Doc" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx=tx+135;
    dw=dw-135;
    
   
    
   UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*.22+1, 44)];
    [btn1 setTitle:@"Project Name" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(statusclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx=tx+dw*.22+1;
    
     label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*.3+1, 44)];
    [btn1 setTitle:@"Vendor Name" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx=tx+dw*.3+1;
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw+135-tx, 44)];
    [btn1 setTitle:@"Notes" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
        
    
}

-(void)idclick{
    docup=!docup;
    if (delegate) {
        return [delegate doaClicked:@"Doc" :docup];
    }
}
-(void)pronameclick{
    vendorup=!vendorup;
    if (delegate) {
        return [delegate doaClicked:@"Nvendor" :vendorup];
    }
}
-(void)pnameclick{
    shipup=!shipup;
    if (delegate) {
        return [delegate doaClicked:@"Shipto" :shipup];
    }
}
-(void)statusclick{
    statusup=!statusup;
    if (delegate) {
        return [delegate doaClicked:@"Nproject":statusup];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
