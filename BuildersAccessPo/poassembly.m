
//
//  poassembly.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "poassembly.h"
#import "wcfService.h"
#import "wcfArrayOfKeyValueItem.h"
#import "wcfKeyValueItem.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_vendor.h"
#import "MBProgressHUD.h"
#import "project.h"
#import "development.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "cl_reason.h"
#import "newpovendorls.h"

@interface poassembly ()<MBProgressHUDDelegate>

@end

int pageNo;
int currentPage;

int currentpage, pageno;

@implementation poassembly{
    MBProgressHUD *HUD;
}

@synthesize rtnlist;
@synthesize islocked, tbview, idmaster, xtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage=1;
    searchtxt.delegate=self;
    [self setTitle:@"Select a Vendor"];
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
    
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dwidth, 44)];
    [self.uw addSubview: searchtxt];
    searchtxt.delegate=self;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    
    [self getAssemblyls];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh1.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Sync" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshAssembly:) ];
    
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1: nil];
    }else if(item.tag == 2){
        [self refreshAssembly: nil];
    }
}

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}


-(void)doneClicked{
    [searchtxt resignFirstResponder];
}
- (void)getAssemblyls
{
    cl_vendor *mp=[[cl_vendor alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    
    lastsync=[ms getLastSync:idmaster :@"7"];
    str=[NSString stringWithFormat:@"idcia ='%@'", idmaster];
    rtnlist = [mp getVendorList:str];
    
    
    UIScrollView *sv =uv;
    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 12, 300, 40)];
    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.numberOfLines=2;
    [lbl sizeToFit];
    lbl.tag=14;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    CGRect rect= lbl.frame;
    rect.origin.x=(self.uw.frame.size.width-rect.size.width)/2;
    rect.origin.y=12;
    rect.size.height=40;
    lbl.frame=rect;
  lbl.textColor=[UIColor darkGrayColor];
//    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
    lbl.font=[UIFont boldSystemFontOfSize:10.0];
    lbl.backgroundColor=[UIColor clearColor];
    [ntabbar addSubview:lbl];
    
    int dwidth = self.uw.frame.size.width;
    int dheight = self.uw.frame.size.height;
    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, dheight-64)];
    sv.contentSize=CGSizeMake(dwidth,dheight-43);
    tbview.layer.cornerRadius = 10;
    tbview.layer.borderWidth = 1.2;
    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    tbview.delegate = self;
    tbview.dataSource = self;
    tbview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [sv addSubview:tbview];
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(IBAction)refreshAssembly:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler1:) version:version];
    }
}
- (void) xisupdate_iphoneHandler1: (id) value {
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:@"We will sync all Vendors with your device, this will take some time, Are you sure you want to continue?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
    }
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView .tag==1){
        //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                

                currentpage=1;
                [self refreshAssemblyList:1];
            }
                break;
        }
    }
}


-(void)refreshAssemblyList:(int)xpageNo {
    
    
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Vendors"delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Vendors  ";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        islocked=1;
    }else{
        HUD.progress= (currentPage*1.0/(pageno+1));
        
    }
    currentPage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetPoVendor:self action:@selector(xGetAssemblysHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] currentPage:xpageNo EquipmentType:@"5"];
    }
}

- (void) xGetAssemblysHandler: (id) value {
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    if([result isKindOfClass:[wcfArrayOfVendor class]]){
        
        cl_vendor *mp=[[cl_vendor alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if (currentPage==1) {
            [mp deletaAll:idmaster];
        }
        
        if ([result count]>0) {
            wcfVendor *kv = (wcfVendor *)[result objectAtIndex:0];
            pageno=[kv.TotalPage intValue];
            [result removeObjectAtIndex:0];
            
            
            [mp addToVendor:result];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self refreshAssemblyList:currentpage];
            }else{
                HUD.progress = (pageno*1.0/(pageno+1));
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms updSync:idmaster :@"7" :[[NSDate alloc] init]];
                
                [self SyncReason];
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms updSync:idmaster :@"7" :[[NSDate alloc] init]];
            
            [self SyncReason];
        }
    }
}


-(void)SyncReason{
    wcfService *service = [wcfService service];
    [service xGetReasons:self action:@selector(xGetReasonsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"5"];
}

-(void)xGetReasonsHandler: (id) value {
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
        return;
    }
    
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    if([result isKindOfClass:[wcfArrayOfReasonListItem class]]){
        cl_reason *mp=[[cl_reason alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletaAll:idmaster];
        [mp addToReason:result :idmaster];
        
        
    }
    HUD.progress = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [HUD hide];
    [self getAssemblyls];
    [ntabbar setSelectedItem:nil];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    cl_vendor *mp =[[cl_vendor alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"((idNumber like [c]'%@*') or (name like [c]'*%@*'))", searchtxt.text, searchtxt.text];
    
    
    rtnlist=[mp getVendorList:str];
    
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [rtnlist count];
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
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    cell.textLabel.text = [kv valueForKey:@"name"];
    [cell .imageView setImage:nil];
    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
    [self autoUpd];
    }
}
-(void)autoUpd{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    
    [searchtxt resignFirstResponder];
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    newpovendorls *next =[newpovendorls alloc];
    next.detailstrarr=self.detailstrarr;
    next.menulist=self.menulist;
    next.tbindex=self.tbindex;
    next.managedObjectContext=self.managedObjectContext;
    next.xidvendor=[kv valueForKey:@"idNumber"];
    next.xxnvendor=[kv valueForKey:@"name"];
    next.xidproject=self.idproject;
    next.idmaster=self.idmaster;
    next.xtype=self.xtype;
    [self.navigationController pushViewController:next animated:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
