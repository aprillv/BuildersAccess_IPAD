//
//  bustoutdetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "bustoutdetail.h"
#import "Mysql.h"
#import "wcfService.h"
#import "userInfo.h"
#import "cl_reason.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "project.h"
#import "bustoutupg.h"
#import "forapprove.h"

@interface bustoutdetail ()

@end

int hy;
@implementation bustoutdetail

@synthesize xidproject, xidbustout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
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
    
    CGSize cs = self.uw.frame.size;
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, cs.width, cs.height)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [self getPoDetail];
    [ntabbar setSelectedItem:nil];
}
-(void)getPoDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetBustOutDetailForApprove:self action:@selector(xGetPendingVpoDetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xid:xidbustout EquipmentType:@"5"];
    }
}

-(void)xGetPendingVpoDetailHandler:(id)value{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    pd =(wcfBustOutItem*)value;
    self.title=[NSString stringWithFormat:@"Bust Out - %@", pd.Iddoc];
    [self drawpage];
    
}

-(void)drawpage{
    int y=10;
    int dwidth =self.uw.frame.size.width-20;
    for (UIView *utt in uv.subviews) {
        [utt removeFromSuperview];
    }
    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
    lbl.text=@"Termination Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Refdate;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Contract Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.ContractRefdate;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
    lbl.text=@"Non-Refundable";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Nonrefundable;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
    lbl.text=@"Approve by";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Appr_by;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
    lbl.text=@"Project";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Nproject;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Sub Division";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.borderWidth = 1.2;
      lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Subdividion;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Buyer Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.borderWidth = 1.2;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Client;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Stage @ Contract";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.borderWidth = 1.2;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Stage;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+37;

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Project Manager";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.borderWidth = 1.2;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.PM1;
    lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Consultant";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 32)];
    lbl.layer.borderWidth = 1.2;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, 24)];
    lbl.text=pd.Sales1;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    y=y+54;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    y=y+54;
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];
    
//    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
//    [[ntabbar.items objectAtIndex:0]setTitle:@"Approve" ];
//    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:) ];
//    
//    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
//    [[ntabbar.items objectAtIndex:13]setTitle:@"Disapprove" ];
//    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dodisapprove:) ];
    
    if ( y<self.uw.frame.size.height+1) {
        y =self.uw.frame.size.height+1;
    }
    uv.contentSize=CGSizeMake(dwidth,y);
    [ntabbar setSelectedItem:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

-(void)dorefresh{
    [self getPoDetail];
}
-(void)gotoProject{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}
-(void)orientationChanged{
    [super orientationChanged];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(IBAction)doapprove:(id)sender{
    bustoutupg *pa =[[bustoutupg alloc]init];
    pa.managedObjectContext=self.managedObjectContext;
    pa.xidnum=pd.Idnumber;
    pa.xidproject=pd.idproject;
    pa.detailstrarr=self.detailstrarr;
    pa.menulist=self.menulist;
    pa.tbindex=self.tbindex;
    pa.atitle=[NSString stringWithFormat:@"Project # %@ ~ %@", pd.idproject, pd.Nproject];
    pa.xtype=1;
    [self.navigationController pushViewController:pa animated:NO];
}

-(IBAction)dodisapprove:(id)sender{
    bustoutupg *pa =[[bustoutupg alloc]init];
    pa.managedObjectContext=self.managedObjectContext;
    pa.xidnum=pd.Idnumber;
    pa.xidproject=pd.idproject;
    pa.xtype=2;
     pa.title=[NSString stringWithFormat:@"Project # %@ ~ %@", pd.idproject, pd.Nproject];
    [self.navigationController pushViewController:pa animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
