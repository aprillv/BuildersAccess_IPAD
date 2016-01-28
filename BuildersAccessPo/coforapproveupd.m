//
//  coforapproveupd.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "coforapproveupd.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "coforapproveupd1.h"
#import "Reachability.h"
#import "project.h"
#import "forapprove.h"

@interface coforapproveupd (){
    int screenh;
}

@end

@implementation coforapproveupd

@synthesize idnumber, idcia, isfromapprove, aattile;

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
   
	[self setTitle:aattile];
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
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    [self.uw addSubview:uv];
    
    [self getDetail];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
   
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [ntabbar setSelectedItem:nil];
    [self orientationChanged];
}


-(IBAction)doapprove:(id)sender{
    [self gotonextpage:1];
}

-(IBAction)dodisapprove:(id)sender{
    [self gotonextpage:2];
}

-(IBAction)doacknowledge:(id)sender{
    [self gotonextpage:3];
}

-(void)gotonextpage:(int)xtype3{
    xtype=xtype3;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
}
- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        coforapproveupd1 *co =[[coforapproveupd1 alloc]init];
        co.menulist=self.menulist;
        co.detailstrarr=self.detailstrarr;
        co.tbindex=self.tbindex;
        co.managedObjectContext=self.managedObjectContext;
        co.idco1=self.idnumber;
        co.idcia=self.idcia;
        co.xtype=xtype;
        co.aattile=self.aattile;
        co.isfromapprove=self.isfromapprove;
        [self.navigationController pushViewController:co animated:NO];
    }
}


-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [service xGetCODetailForApprove:self action:@selector(xGetCODetailForApproveHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: idcia xcoid: idnumber EquipmentType: @"3"];
    }
}

- (void) xGetCODetailForApproveHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
    
	// Do something with the wcfCODetail* result
    result = (wcfCODetail*)value;
    
  
//    [self setTitle:[NSString stringWithFormat:@"CO-%@", result.Doc]];
    
    int y=10;
    float rowheight=32.0;
    float dwidth = self.uw.frame.size.width-20;
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    for (UIView *uw in uv.subviews) {
        [uw removeFromSuperview];
    }
    UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=[NSString stringWithFormat:@"Project # %@", result.idproject];
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*4)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0]CGColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-10, rowheight-1)];
    lbl.text=result.Nproject;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-10, rowheight-1)];
    if (result.Stage) {
        lbl.text=result.Stage;
    }else{
        lbl.text=@"Schedule Not Started";
        lbl.textColor=[UIColor redColor];
    }
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-10, rowheight-1)];
    lbl.text=result.ProjectStatus;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"C.O. Status: %@", result.Status];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
//    UITableView *ciatbview;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 290, 21)];
    lbl.text=@"Floorplan";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    int rtn =4;
    if (result.Reverseyn ) {
        rtn=rtn+1;
    }
    if (result.Repeated){
        rtn=rtn+1;
    }
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*rtn)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-10, rowheight-1)];
    if (result.IDFloorplan !=nil) {
        lbl.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
    }else{
        lbl.text=@"Plan No.";
    }
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-10, rowheight-1)];
    if (result.Stage) {
        lbl.text=result.Stage;
    }else{
        lbl.text=@"Schedule Not Started";
        lbl.textColor=[UIColor redColor];
    }
    
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-10, rowheight-1)];
    if (result.Bedrooms ==nil || result.Baths == nil) {
        lbl.text=@"Beds  / Baths ";
    }else if (result.Bedrooms ==nil ) {
        lbl.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
    }else if(result.Baths==nil){
        lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
    }else{
        lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
    }
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-10, rowheight-1)];
    if(result.Garage !=nil){
        lbl.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
    }else{
        lbl.text=@"Garage";
    }
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    if (result.Reverseyn ) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, rowheight-1)];
        lbl.text=@"Builder Reverse";
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lbl];
        y=y+rowheight-1;
    }
    
    if (result.Repeated){
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, 300, rowheight-1)];
        lbl.text=@"Repeated Plan";
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lbl];
        y=y+rowheight-1;
    }
    y=y+20;
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*3)];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Buyer: %@", result.Buyer];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Requested: %@", result.Sales1];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-10, rowheight-1)];
    if (result.PM1) {
        lbl.text=[NSString stringWithFormat:@"P.M.: %@", result.PM1];
    }else{
        lbl.text=@"P.M.:";
    }
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
//    rtn =[result.OrderDetailList count];
//    if (rtn>0) {
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, rtn*44)];
//        ciatbview.layer.borderWidth = 1.2;
//        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//        ciatbview.layer.cornerRadius = 10;
//        ciatbview.tag=6;
//        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//        ciatbview.dataSource=self;
//        ciatbview.delegate=self;
//        [uv addSubview:ciatbview];                               
//        y=y+rtn*44+20;
// 
//    }
    
    rtn =[result.OrderDetailList count];
    if (rtn>0) {
        //        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rtn*66)];
        //        ciatbview.layer.cornerRadius = 10;
        //        ciatbview.tag=6;
        //        ciatbview.rowHeight=66;
        //        ciatbview.dataSource=self;
        //        ciatbview.delegate=self;
        //        [uv addSubview:ciatbview];
        //        y=y+rtn*66+20;
        
        UILabel *lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 1)];
        lbl2.layer.cornerRadius=10.0;
        lbl2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl2.layer.borderWidth = 1.2;
        lbl2.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:lbl2];
        
        int fh;
        int i =0;
        for (wcfCOOrderDetail *wd in result.OrderDetailList) {
            i =i+1;
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-10, rowheight-1)];
            lbl.text=wd.Description;
            lbl.numberOfLines=0;
            lbl.font=[UIFont systemFontOfSize:14.0];
            [lbl sizeToFit];
            
            [uv addSubview:lbl];
            fh = lbl.frame.size.height;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+fh+6, dwidth-10, rowheight-1)];
            lbl.text=wd.Btype;
            lbl.numberOfLines=0;
            lbl.textColor=[UIColor darkGrayColor];
            lbl.font=[UIFont systemFontOfSize:13.0];
            [lbl sizeToFit];
            
            [uv addSubview:lbl];
            fh =fh+ lbl.frame.size.height;
            
            
            
            CGRect rc= lbl2.frame;
            rc.size.height=rc.size.height + 14+fh;
            lbl2.frame=rc;
            
            y= y+14+fh;
            //            y=y+20;
        }
        
    }
    
    y=y+20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*3)];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Asking %@", result.Asking];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Increase Asking %@", result.Increase];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-10, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"New Price %@", result.Newprice];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
  
    if (isfromapprove) {
        UIButton* loginButton;
        if ( [result.ApproveOrder isEqualToString:@"1"]) {
            //        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
            //        [[ntabbar.items objectAtIndex:0]setTitle:@"Approve Order" ];
            //        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
            //        [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:) ];
            
            
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
            [loginButton setTitle:@"Approve Order" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
            
        }
        
        
        if ([result.Acknowledge isEqualToString:@"1"]) {
            
            //        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
            //        [[ntabbar.items objectAtIndex:0]setTitle:@"Acknowledge" ];
            //        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
            //        [[ntabbar.items objectAtIndex:0]setAction:@selector(doacknowledge:) ];
            
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
            [loginButton setTitle:@"Acknowledge" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [loginButton addTarget:self action:@selector(doacknowledge:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if ( [result.Disapprove isEqualToString:@"1"]) {
            //        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
            //        [[ntabbar.items objectAtIndex:13]setTitle:@"DisApprove" ];
            //        [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
            //        [[ntabbar.items objectAtIndex:13]setAction:@selector(dodisapprove:) ];
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
            [loginButton setTitle:@"DisApprove" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(doRefresh) ];
        
        
    }else {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(doRefresh) ];
    }
 
  screenh = y;
    if (y<self.uw.frame.size.height) {
        y=self.uw.frame.size.height;
    }
    uv.contentSize=CGSizeMake(320.0,y+1);
    [ntabbar setSelectedItem:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self doRefresh];
    }
}


-(void)doRefresh{
      [self getDetail];
}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]] ||  [temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

-(void)orientationChanged{
    [super orientationChanged];
    CGRect f=uv.frame;
    f.size=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height);
    uv.frame=f;
    float y=f.size.height;
    for (UIView *ue in uv.subviews) {
        f=ue.frame;
        if (f.origin.x==10) {
            f.size.width=self.uw.frame.size.width-20;
        }else{
            f.size.width=self.uw.frame.size.width-30;
        }
        ue.frame=f;
        if (y<f.size.height) {
            y=f.size.height;
        }
    }
    
   y=screenh;
    if (y<self.uw.frame.size.height) {
        y=self.uw.frame.size.height+1;}
    
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, y);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        int rtn;
        switch (tableView.tag) {
                
            case 6:
                rtn=[result.OrderDetailList count];
                break;
                
            default:
                rtn=4;
                break;
        }
        return rtn;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            if (tableView.tag ==6) {
                wcfCOOrderDetail *w =[result.OrderDetailList objectAtIndex:indexPath.row];
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                if ([w.HasColor isEqualToString:@"1"]) {
                    cell.textLabel.textColor=[UIColor greenColor];
                    cell.detailTextLabel.textColor=[UIColor greenColor];
                    
                }
                cell.textLabel.font=[UIFont systemFontOfSize:14.0];
                cell.textLabel.text=w.Description;
                cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0];
                cell.detailTextLabel.text=w.Btype;
                cell.userInteractionEnabled = NO;
                
                cell.accessoryType=UITableViewCellAccessoryNone;
                [cell .imageView setImage:nil];
                
            }}
        
        return cell;
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
