//
//  firstcell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/14/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "firstcell.h"

@implementation firstcell{
    BOOL idup;
    BOOL nameup;
    BOOL pnameup;
    BOOL statusup;
    UIButton *btn1;
}

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        idup =NO;
        nameup=NO;
        pnameup=NO;
        statusup=NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    if (!btn1) {
        int tx=0;
        int dw =self.frame.size.width;
        
        btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, 69, 44)];
        
        [btn1 setTitle:@"Project" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor lightGrayColor]];
        //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:btn1];
        
        tx=tx+69;
        
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*.28+2, 44)];
        [btn1 setTitle:@"Project Name" forState:UIControlStateNormal];
        //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [btn1 setBackgroundColor:[UIColor lightGrayColor]];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:btn1];
        tx=tx+dw*.28+2;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*0.48+2, 44)];
        [btn1 setTitle:@"Plan Name" forState:UIControlStateNormal];
        //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [btn1 setBackgroundColor:[UIColor lightGrayColor]];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:btn1];
        tx=tx+dw*.48+2;
        
        label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
        label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview: label];
        tx=tx+1;
        
        btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw-tx, 44)];
        [btn1 setTitle:@"Status" forState:UIControlStateNormal];
        //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [btn1 setBackgroundColor:[UIColor lightGrayColor]];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(statusclick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:btn1];
    }
 
}

-(void)idclick{
    idup=!idup;
    if (delegate) {
        return [delegate doaClicked:@"idnumber" :idup];
    }
}
-(void)pronameclick{
    nameup=!nameup;
    if (delegate) {
        return [delegate doaClicked:@"name" :nameup];
    }
}
-(void)pnameclick{
    pnameup=!pnameup;
    if (delegate) {
        return [delegate doaClicked:@"planname" :pnameup];
    }
}
-(void)statusclick{
    statusup=!statusup;
    if (delegate) {
        return [delegate doaClicked:@"status":statusup];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
