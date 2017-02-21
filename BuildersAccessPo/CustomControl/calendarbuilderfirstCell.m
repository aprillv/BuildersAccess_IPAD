//
//  calendarbuilderfirstCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/18/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "calendarbuilderfirstCell.h"

@implementation calendarbuilderfirstCell{
    BOOL reasonup;
    BOOL requestedup;
    BOOL subjectup;
    BOOL originalup;
}


@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reasonup=NO;
        requestedup=NO;
        subjectup=NO;
        originalup=NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 113, 44)];
    
    [btn1 setTitle:@"Requested" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( 113, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 114, 0, 385, 44)];
    [btn1 setTitle:@"Subject" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( 499, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 500, 0, 110, 44)];
    [btn1 setTitle:@"Original" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    
    
    label = [[UILabel alloc] initWithFrame: CGRectMake(610, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 611,0, self.frame.size.width-611, 44)];
    [btn1 setTitle:@"Reschedule" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(billtoclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    

    
}

-(void)idclick{
    reasonup=!reasonup;
    if (delegate) {
        return [delegate doaClicked:@"Requested" :reasonup];
    }
}
-(void)pronameclick{
    requestedup=!requestedup;
    if (delegate) {
        return [delegate doaClicked:@"Subject" :requestedup];
    }
}
-(void)pnameclick{
    subjectup=!subjectup;
    if (delegate) {
        return [delegate doaClicked:@"Original" :subjectup];
    }
}

-(void)billtoclick{
    originalup=!originalup;
    if (delegate) {
        return [delegate doaClicked:@"Reschedule":originalup];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
