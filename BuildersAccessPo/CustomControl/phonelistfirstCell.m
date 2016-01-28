//
//  phonelistfirstCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "phonelistfirstCell.h"

@implementation phonelistfirstCell{
    BOOL reasonup;
    BOOL requestedup;
    BOOL subjectup;
}


@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reasonup=NO;
        requestedup=NO;
        subjectup=NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    int tx=0;
    int dw =self.frame.size.width;
    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*0.27+2, 44)];
    
    [btn1 setTitle:@"Name" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//     btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx= tx+dw*0.27+2;
    
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
//     label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview: label];
    tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw*0.27+2, 44)];
    [btn1 setTitle:@"Title" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//     btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    tx= tx+dw*0.27+2;
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( tx, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
//     label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview: label];
     tx=tx+1;
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( tx, 0, dw-tx, 44)];
    [btn1 setTitle:@"Email" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];

    
//    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 193, 44)];
//    
//    [btn1 setTitle:@"Name" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
//    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
//    [self.contentView addSubview:btn1];
//    
//    
//    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( 193, 0, 1, 44)];
//    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
//    [self.contentView addSubview: label];
//    
//    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 194, 0, 191, 44)];
//    [btn1 setTitle:@"Title" forState:UIControlStateNormal];
//    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
//    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
//    [self.contentView addSubview:btn1];
//    
//    label = [[UILabel alloc] initWithFrame: CGRectMake( 385, 0, 1, 44)];
//    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
//    [self.contentView addSubview: label];
//    
//    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 386, 0, self.frame.size.width-386, 44)];
//    [btn1 setTitle:@"Email" forState:UIControlStateNormal];
//    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
//    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
//    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
//    [self.contentView addSubview:btn1];
    
    
   
    
    
    
}

-(void)idclick{
    reasonup=!reasonup;
    if (delegate) {
        return [delegate doaClicked:@"name" :reasonup];
    }
}
-(void)pronameclick{
    requestedup=!requestedup;
    if (delegate) {
        return [delegate doaClicked:@"title" :requestedup];
    }
}
-(void)pnameclick{
    subjectup=!subjectup;
    if (delegate) {
        return [delegate doaClicked:@"Email" :subjectup];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
