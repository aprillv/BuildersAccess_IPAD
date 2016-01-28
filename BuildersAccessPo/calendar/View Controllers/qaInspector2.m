//
//  qaInspector2.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "qaInspector2.h"
#import "wcfArrayOfQACalendarItem.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "qacalendarViewController.h"
#import "qainspection.h"
#import "qainspectionb.h"

@interface qaInspector2 ()<UITableViewDataSource, UITableViewDelegate>{
   
    UIScrollView *uv;
    wcfArrayOfQACalendarItem * wi;
    NSString *xidnum;
    UIButton *btnNext;
}


@end

@implementation qaInspector2

@synthesize xyear, xmonth, xqaemail, atitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
   self.title=atitle;
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack1)];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Calendar" ];
    
    
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
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
    
	// Do any additional setup after loading the view.
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=uv.contentSize.height+1;
    [uv setContentSize:CGSizeMake(dwidth, dheight)];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[qacalendarViewController class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }    }
    
}
-(void)dorefresh{
    [self getInspector];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getInspector];
}
-(void)getInspector{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        
        [service xGetInspectorByMonthAndEmail:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xyear:xyear xqaemail:xqaemail xmonth:xmonth EquipmentType:@"5"];
        // Do any additional setup after loading the view.
    }
    
}

- (void) xisupdate_iphoneHandler5: (id) value {
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
    
    wi=(wcfArrayOfQACalendarItem *)value;
    if (uv) {
        [uv removeFromSuperview];
    }
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.uw addSubview:uv];
    
    
    
    UITableView *tbview;
    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, dheight-20)];
    tbview.layer.cornerRadius = 10;
    tbview.delegate = self;
    tbview.layer.borderWidth = 1.2;
    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    tbview.dataSource = self;
    [uv addSubview:tbview];
    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    uv.contentSize=CGSizeMake(dwidth,uv.frame.size.height+1);
    [ntabbar setSelectedItem:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [wi count];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfQACalendarItem *event =[wi objectAtIndex:(indexPath.row)];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:event.Name];
    [[cell textLabel]setBackgroundColor:[UIColor clearColor]];
    UIView *myView = [[UIView alloc] init];
    

        
        if ([event.Color isEqualToString:@"Yellow"]) {
            myView.backgroundColor = [UIColor colorWithRed:218.0/256 green:165.0/256 blue:32.0/256 alpha:1.0];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Orange"]){
//            myView.backgroundColor = [UIColor colorWithRed:255.0/256 green:204.0/256 blue:0.0 alpha:1.0];
            myView.backgroundColor=[UIColor orangeColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
//        }else if([event.Color isEqualToString:@"Red"]){
//            myView.backgroundColor = [UIColor redColor];
//            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Green"]){
            myView.backgroundColor = [UIColor colorWithRed:50.0/256 green:205.0/256 blue:50.0/256 alpha:1.0];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
//        }else if([event.Color isEqualToString:@"Blue"]){
//            myView.backgroundColor = [UIColor blueColor];
//            [[cell textLabel]setTextColor:[UIColor blackColor]];
//        }else if([event.Color isEqualToString:@"Purple"]){
//            myView.backgroundColor = [UIColor purpleColor];
//            [[cell textLabel]setTextColor:[UIColor blackColor]];
//        }else if([event.Color isEqualToString:@"Pink"]){
//            myView.backgroundColor = [UIColor colorWithRed:253.0/256 green:215.0/256 blue:228.0/256 alpha:1.0];
//            [[cell textLabel]setTextColor:[UIColor blackColor]];
        }else if([event.Color isEqualToString:@"Brown"]){
            //255 192 203
            myView.backgroundColor = [UIColor brownColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Gray"]){
            //255 192 203
            myView.backgroundColor = [UIColor grayColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else{
            myView.backgroundColor = [UIColor whiteColor];
            [[cell textLabel]setTextColor:[UIColor blackColor]];
        }
    
       cell.backgroundView = myView;
    
    
    
    [cell .imageView setImage:nil];
    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
    xidnum=((wcfQACalendarItem *)[wi objectAtIndex:indexPath.row]).Idnumber;
    [self doupdateCheck];
    }
}

-(void)doupdateCheck{
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
            [service xGetQACalendarStatus:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:xidnum EquipmentType:@"5"];
               
        
        
        
        
    }
}

- (void) xisupdate_iphoneHandler3: (id) value {
    
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"There is no QA Inspection in this event."];
        [alert show];
        return;
        
    }else{
        
        if ([result2 isEqualToString:@"Not Started"] || [result2 isEqualToString:@"Not Ready"]) {
            qainspection *qt =[qainspection alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=xidnum;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:NO];
        }else{
            qainspectionb *qt =[qainspectionb alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=xidnum;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:NO];
        }
        
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
