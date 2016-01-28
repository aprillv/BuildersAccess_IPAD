//
//  projectaddc.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectaddc.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>

@interface projectaddc (){
    UIScrollView *uv;
    UIButton *btnNext;
    NSMutableArray *sf1;
}


@end

@implementation projectaddc

@synthesize idproject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Addendum C"];
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width;
    dheight=cs.height;
    
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self getIsTwoPart]) {
        btnNext.frame = CGRectMake(10, 26, 40, 32);
    }else{
        btnNext.frame = CGRectMake(60, 26, 40, 32);
    }
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back1"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    [self.navigationBar addSubview:btnNext];
    
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
     uv.contentSize=CGSizeMake(dwidth,dheight+1);
    [self getDetail];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack: nil];
    }
}


-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        [service xGetProjectAddendumc:self action:@selector(xGetProjectAddendumcHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject EquipmentType:@"5"];
    }
}

-(void)xGetProjectAddendumcHandler:(id)value1{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value1 isKindOfClass:[NSError class]]) {
        NSError *error = value1;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value1 isKindOfClass:[SoapFault class]]) {
        SoapFault* sf =value1;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value1];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
     
    sf1=value1;
      
    [self drawPage];
   

}

-(void)drawPage{
    int y=10;
    for (UIView *uiv in uv.subviews) {
        [uiv removeFromSuperview];
    }
    UILabel  *lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Description";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    float h;
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width-20;
    dheight=cs.height;
    
    for (NSString *desc in sf1) {
        
        h=32.0f;
        
        UILabel * lblTitle;
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+5, dwidth-20, 94)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=desc;
        lblTitle.numberOfLines=0;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [lblTitle sizeToFit];
        
        if (h < lblTitle.frame.size.height+10) {
            h = lblTitle.frame.size.height+10;
        }
        UILabel * lblTitle2  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, h)];
        lblTitle2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblTitle2.layer.cornerRadius =10.0;
        lblTitle2.layer.borderWidth = 1.2;
        lblTitle2.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:lblTitle2];
        [uv addSubview:lblTitle];
        
        
        y = y + h+10;
        
    }

}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    if ([[UIScreen mainScreen] applicationFrame].size.height!=1024) {
        [self drawPage];
    }
    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
