//
//  newSchedule1.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "newSchedule1.h"
#import "wcfArrayOfProjectSchedule.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "newSchedule2.h"
#import "CKCalendarCellColors.h"

@interface newSchedule1 (){
    UIScrollView *uv;
    wcfArrayOfProjectSchedule * wi;
    wcfProjectSchedule *xidnum;
    UIButton *btnNext;
}

@end

@implementation newSchedule1

@synthesize xidproject;

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
        [self goBack: nil];
    }else if(item.tag == 2){
        [self dorefresh];
    }else if(item.tag == 3) {
        [self goTaskDue];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=@"Project Schedule";
    
	
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack:)];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:1] setAction:@selector(goTaskDue)];
    [[ntabbar.items objectAtIndex:1] setTag:3 ];
    [[ntabbar.items objectAtIndex:1] setTitle:@"Task Due" ];
    [[ntabbar.items objectAtIndex:1] setEnabled:YES];
    [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"schedule.png"] ];
    
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

-(void)goTaskDue{
    newSchedule2 *ns =[newSchedule2 alloc];
    ns.managedObjectContext=self.managedObjectContext;
    ns.xidproject=self.xidproject;
    ns.menulist=self.menulist;
    ns.detailstrarr=self.detailstrarr;
    ns.tbindex=self.tbindex;
    
    ns.xidstep=@"-1";
    ns.atitle=@"Task Due List";
    [self.navigationController pushViewController:ns animated:NO];
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

-(void)dorefresh{
    [self getMilestone];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getMilestone];
}
-(void)getMilestone{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xGetNewSchedule1:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject EquipmentType:@"3"];
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
    
    wi=(wcfArrayOfProjectSchedule *)value;
    if (uv) {
        [uv removeFromSuperview];
    }
    

    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.uw addSubview:uv];
    
    
    
    
    UITableView *tbview;
    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, uv.frame.size.height-20)];
    tbview.layer.cornerRadius = 10;
    tbview.delegate = self;
    tbview.layer.borderWidth = 1.2;
    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    tbview.dataSource = self;
    tbview.rowHeight=54;
    [uv addSubview:tbview];
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


//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//tableview delegate
//{
//    //here is the code to create and customize a cell
//    //adding gesture recognizer
//    uito
//    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]
//                                                initWithTarget:self action:@selector(dfgsyour_function)];
//    recognizer.minimumPressDuration = 1.0; //seconds
//    [cell addGestureRecognizer:lpgr];
//    [lpgr release];
//    return  cell;
//}
//-(void)your_function
//{
//    NSlog(@"detecting long press");
//}
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
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", event.Item, event.Name]];
        if (event.DcompleteYN) {
              cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@", event.Dstart, event.Dcomplete];
        }else{
            cell.detailTextLabel.text=event.Dcomplete;
        }
 
    
   
    
    
    
    
//    if ([event.Item isEqualToString:@"2"]) {
//        cell.textLabel.backgroundColor=[UIColor clearColor];
//        UIView *myView = [[UIView alloc] init];
//        myView.backgroundColor =kCalendarColorBlue;
//        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
//          cell.backgroundView = myView;
//    }
    
  
    

      
    
    [cell .imageView setImage:nil];
    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        xidnum=((wcfProjectSchedule *)[wi objectAtIndex:indexPath.row]);
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
        newSchedule2 *ns =[newSchedule2 alloc];
        ns.managedObjectContext=self.managedObjectContext;
        ns.xidproject=self.xidproject;
        ns.xidstep=xidnum.Item;
        ns.menulist=self.menulist;
        ns.detailstrarr=self.detailstrarr;
        ns.tbindex=self.tbindex;
        ns.atitle=[NSString stringWithFormat:@"%@ - %@", xidnum.Item, xidnum.Name];
        [self.navigationController pushViewController:ns animated:NO];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
