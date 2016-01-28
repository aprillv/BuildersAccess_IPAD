//
//  vpolistfirstCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/16/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "vpolistfirstCell.h"

@implementation vpolistfirstCell{
    BOOL numberup;
    BOOL dateup;
    BOOL projectup;
    BOOL salesup;
    BOOL totalup;
}


@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        numberup =NO;
        dateup=NO;
        projectup=NO;
        salesup=NO;
        totalup=NO;
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    UIButton *btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 45, 44)];
    
    [btn1 setTitle:@"#" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    //    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    //     [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(idclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake( 45, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 46, 0, 94, 44)];
    [btn1 setTitle:@"Date" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pronameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( 140, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 141, 0, 242, 44)];
    [btn1 setTitle:@"Project" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pnameclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( 381, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 382, 0, 260, 44)];
    [btn1 setTitle:@"Vendor Name" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(billtoclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    label = [[UILabel alloc] initWithFrame: CGRectMake( 642, 0, 1, 44)];
    label.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self.contentView addSubview: label];
    
    btn1 = [[UIButton alloc] initWithFrame: CGRectMake( 643, 0, self.frame.size.width-643, 44)];
    [btn1 setTitle:@"Total" forState:UIControlStateNormal];
    //     [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(statusclick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:btn1];
    
    
}

-(void)idclick{
    numberup=!numberup;
    if (delegate) {
        return [delegate doaClicked:@"IdNumber" :numberup];
    }
}
-(void)pronameclick{
    
    //    if (dateup) {
    //        dateup=NO;
    //        NSLog(@"23");
    //    }else{
    //        dateup=YES;
    //        NSLog(@"45");
    //    }
    dateup=!dateup;
    if (delegate) {
        return [delegate doaClicked:@"RequestedDate" :dateup];
    }
}
-(void)pnameclick{
    projectup=!projectup;
    if (delegate) {
        return [delegate doaClicked:@"Nproject" :projectup];
    }
}

-(void)billtoclick{
    salesup=!salesup;
    if (delegate) {
        return [delegate doaClicked:@"Nvendor":salesup];
    }
}
-(void)statusclick{
    totalup=!totalup;
    if (delegate) {
        return [delegate doaClicked:@"Total":totalup];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
