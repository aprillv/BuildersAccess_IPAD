//
//  mainmenu.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenu.h"
#import "Mysql.h"

@interface mainmenu ()
@end

@implementation mainmenu{
    UIButton*lbla;
}


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.uw.backgroundColor=[UIColor whiteColor];
    int xw;
    int xh;
    
    if ([UIScreen mainScreen].bounds.size.width==748.0f) {
        xw= [UIScreen mainScreen].bounds.size.height;
        xh=[UIScreen mainScreen].bounds.size.width+1;
        
    }else{
        xw= [UIScreen mainScreen].bounds.size.width;
        xh=[UIScreen mainScreen].bounds.size.height+1;
    }
    
    UIImageView *ue =[[UIImageView alloc]init];
//WithFrame:CGRectMake(0, 10, xw-330, xh-160)
    
    UIImage *img=[UIImage imageNamed:@"ba.png"];
    ue.image=img;
    CGRect rect =CGRectMake((xw-330-img.size.width)/2, (xh-160-img.size.height)/2, img.size.width, img.size.width);
    ue.frame=rect;
    ue.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
//    self.uw.backgroundColor = [UIColor redColor];
    [self.uw addSubview:ue];
    ntabbar.hidden=YES;
    CGRect r =ntabbar.frame;
    lbl =[[UILabel alloc]init];
    lbl.backgroundColor = [UIColor whiteColor];
//    r.origin.y +=40;
    lbl.frame=r;
    [self.view addSubview:lbl];
    
   
//    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@\n%@\n%@", self.view, self.uw, ntabbar);
    
//    lbla =[UIButton buttonWithType:UIButtonTypeCustom];
//    lbla .frame=CGRectMake(xw-460, 5, 100, 30);
//    [lbla addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];    [lbla setTitle:@"Logout" forState:UIControlStateNormal];
//    UIColor * cg1 = [Mysql getBlueTextColor];
//    [lbla.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    
//    [lbla setTitleColor:cg1 forState:UIControlStateNormal];
//    [self.navigationBar addSubview:lbla];
   
}
//-(IBAction)gobig:(id)sender{
//    [super gobig:sender];
//    CGRect r =ntabbar.frame;
//    lbl.frame=r;
//    lbla .frame=CGRectMake(r.size.width-100, 5, 100, 30);
//    
////    lbla .frame=CGRectMake(680, 5, 100, 30);
//    
//}
//-(IBAction)gosmall:(id)sender{
//    [super gosmall:sender];
//    NSLog(@"%@ -- %@",self.uw, self.view);
//    CGRect r =ntabbar.frame;
//    lbl.frame=r;
//    lbla .frame=CGRectMake(r.size.width-100, 5, 100, 30);
//    
////    lbla .frame=CGRectMake(380, 5, 100, 30);
//    
//}

-(void)orientationChanged{
    [super orientationChanged];
    CGRect r =ntabbar.frame;
    lbl.frame=r;
    lbla .frame=CGRectMake(r.size.width-100, 5, 100, 30);
//    r=ciatbview1.frame;
//    r.size.height=r.size.height+50;
//    ciatbview1.frame=r;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setIsTwoPart:YES];
    [super viewWillAppear:animated];
    
    [self orientationChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
