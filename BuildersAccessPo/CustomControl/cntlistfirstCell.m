//
//  cntlistfirstCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "cntlistfirstCell.h"

@implementation cntlistfirstCell{
    BOOL idup;
    BOOL cnameup;
}


@synthesize delegate, cname;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        idup=NO;
        cnameup=NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    int tx=0;
    int dw =self.frame.size.width;
    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*.8+2, 44)];
    
    [btn1 setTitle:cname forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    //     btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx= tx+dw*.8+2;
    
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    //     label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview: label];
    tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw-tx, 44)];
    [btn1 setTitle:@"Found" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    //     btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
}

-(void)idclick{
    idup=!idup;
    if (delegate) {
        return [delegate doaClicked:@"Key" :idup];
    }
}
-(void)pronameclick{
    cnameup=!cnameup;
    if (delegate) {
        return [delegate doaClicked:@"Value" :cnameup];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
