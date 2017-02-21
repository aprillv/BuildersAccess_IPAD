//
//  projectpo.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectpo.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "projectpols.h"
#import "cl_sync.h"
#import "cl_vendor.h"
#import "cl_reason.h"
#import "poassembly.h"
#import "vpopendinglsViewController.h"
#import "MBProgressHUD.h"
#import "cntlistCell.h"
#import "cntlistfirstCell.h"

@interface projectpo ()<UIAlertViewDelegate, MBProgressHUDDelegate, cntlistfirstCellDelegate>{
    UITableView *ciatbview;
    UIButton *btnNext;
    UIButton* loginButton;
    MBProgressHUD * HUD;
    int currentpage, pageno;
    bool isfirstTime;
    int selectedRow;
    cntlistfirstCell *cell2;
}

@end



@implementation projectpo

@synthesize  idproject,xtype, idmaster, isfromdevelopment,result, idvendor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)gotoProject:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
        if (!cell2) {
            cell2 = [[cntlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.cname=@"Purchase Order";
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.delegate=self;
        }
        return cell2;
        
        
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (tableView.tag ==1)
		return 0;
	else
		return 44.0f;
}


-(void)doaClicked:(NSString *)str :(BOOL) isup{
   
    [result sortUsingComparator:^NSComparisonResult(wcfKeyValueItem* obj1, wcfKeyValueItem* obj2) {
        
        if ([str isEqualToString:@"Key"]) {
            if (isup) {
                return [obj1.Key compare:obj2.Key];
            }else{
                return [obj2.Key compare:obj1.Key];
            }
        }else{
            int t1 = [[[[[obj1.Value componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0] intValue];
            int t2 = [[[[[obj2.Value componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0] intValue];
            if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
            }
        }
        
        
    }];
    [ciatbview reloadData];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject: nil];
    }else if(item.tag == 2){
        [self dorefresh: nil];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self setTitle:@"Purchase Order"];
    isfirstTime=YES;
    if (!idvendor) {
        idvendor=@"";
    }
    
    
    if (isfromdevelopment==0) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    }else if (isfromdevelopment==1) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    }
   
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
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
    
//    int dwidth;
//    int dheight;
//    CGSize cs = self.uw.frame.size;
//    dwidth=cs.width;
//    dheight=cs.height;
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
//    uv.backgroundColor=[UIColor whiteColor];
    
    if (result) {
         [self drawPage];
    }else{
        [self getdetail];
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    if (isfirstTime) {
        isfirstTime=NO;
    }else{
        [self dorefresh:nil];
    }
     [super viewWillAppear:animated];
    [self orientationChanged];
}


-(IBAction)dorefresh:(id)sender{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
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
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        
        [self getdetail];
    }
}

-(void)getdetail{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    NSLog(@"%@ %@", idproject, idvendor);
    [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:idvendor EquipmentType:@"5"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:{
            if (alertView.tag==0) {
                currentpage=1;
                [self getAssemblyfromServer:1];
            }
        }
            break;
    }
}

-(void)getProjectPo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:idvendor EquipmentType:@"5"];
    }
    
}

- (void) xGetStartPackListHandler: (id) value {
    [ntabbar setSelectedItem:nil];
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
	// Do something with the NSMutableArray* result
    
    result=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    [result removeObjectAtIndex: 0];
    [result removeObjectAtIndex: 0];
    

    [self drawPage];
}

-(void)drawPage{
//    uv.backgroundColor=[UIColor whiteColor];
//    for (UIView *we in uv.subviews) {
//        [we removeFromSuperview];
//    }
    [ciatbview removeFromSuperview];
    if (result.count==0) {
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 21)];
        lbl.text=@"Purchase Order not Found.";
        lbl.textColor=[UIColor redColor];
        [self.uw addSubview:lbl];
    }else{
    if (ciatbview ==nil) {
        int dwidth =self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
        int dh =([result count]+1)*44;
        if (dh>dheight) {
            dh=dheight;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dh)];
//        uv.contentSize=CGSizeMake(dwidth,dheight+1);
//        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=2;
        [self.uw addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
//        ciatbview.layer.borderWidth = 1.2;
//        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        loginButton= [UIButton buttonWithType:UIButtonTypeCustom];
//        [loginButton setFrame:CGRectMake(10, dheight-54, dwidth-20, 44)];
//        if (xtype==1) {
//            [loginButton setTitle:@"Request WPO" forState:UIControlStateNormal];
//        }else{
//            [loginButton setTitle:@"Request VPO" forState:UIControlStateNormal];
//        }
//        
//        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [loginButton addTarget:self action:@selector(docreatevpo:) forControlEvents:UIControlEventTouchUpInside];
//        uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//        [uv addSubview:loginButton];
        
    }else{
        [self.uw addSubview: ciatbview];
        [ciatbview reloadData];
    }
    }
}

-(IBAction)docreatevpo:(id)sender{
    cl_sync *mp =[[cl_sync alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    if ([mp isFirttimeToSync: idmaster :@"7"]) {
        
        cl_vendor *cp =[[cl_vendor alloc]init];
        cp.managedObjectContext=self.managedObjectContext;
        [cp deletaAll:idmaster];
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"This is the first time, we will sync all vendors with your pad, this will take some time, Are you sure you want to continue?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Continue", nil];
        alert.tag = 0;
        [alert show];
    }else{
        [self gotoNextPageAssembly];
        
    }
}

-(void)getAssemblyfromServer:(int)xpageNo{
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
    }else{
        if (xpageNo==1) {
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Vendors..." delegate:self otherButtonTitles:nil];
//            [alertViewWithProgressbar show];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Synchronizing Vendors... ";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
        }else{
            HUD.progress= (currentpage*1.0/(pageno+1));
            
        }
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
    NSMutableArray* result3 = (NSMutableArray*)value;
    if([result3 isKindOfClass:[wcfArrayOfVendor class]]){
        if ([result3 count]>0) {
            wcfVendor *kv = (wcfVendor *)[result3 objectAtIndex:0];
            pageno=[kv.TotalPage intValue];
            [result3 removeObjectAtIndex:0];
            
            cl_vendor *mp=[[cl_vendor alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToVendor:result3];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self getAssemblyfromServer:currentpage];
            }else{
                HUD.progress = (pageno*1.0/(pageno+1));
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms addToSync:idmaster :@"7" :[[NSDate alloc] init]];
                
                [self SyncReason];
                
                
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:idmaster :@"7" :[[NSDate alloc] init]];
            
            [self SyncReason];
        }
        
    }
}

-(void)SyncReason{
    wcfService *service = [wcfService service];
    [service xGetReasons:self action:@selector(xGetReasonsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"5"];
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    [loginButton setFrame:CGRectMake(10, dheight-54, dwidth-20, 44)];
//    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
    [ciatbview reloadData];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [ciatbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
    [ciatbview reloadData];
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
    NSMutableArray* result3 = (NSMutableArray*)value;
    if([result3 isKindOfClass:[wcfArrayOfReasonListItem class]]){
        cl_reason *mp=[[cl_reason alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletaAll:idmaster];
        [mp addToReason:result3 :idmaster];
        
        
    }
    HUD.progress = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [HUD hide];
    [self gotoNextPageAssembly];
    
}
-(void)gotoNextPageAssembly{
    poassembly *pd =[poassembly alloc];
    pd.menulist=self.menulist;
    pd.detailstrarr=self.detailstrarr;
    pd.tbindex=self.tbindex;
    pd.managedObjectContext=self.managedObjectContext;
    pd.idproject =self.idproject;
    pd.idmaster=self.idmaster;
    pd.xtype=self.xtype;
    [self.navigationController pushViewController:pd animated:NO];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [result count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        static NSString *CellIdentifier = @"Cell";
        
        cntlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
            cell = [[cntlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        }
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        NSArray *ta = [kv.Value componentsSeparatedByString:@"("];
        
        cell.Cname=kv.Key;
        cell.cnt=[[[ta objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
//        cell.textLabel.text=kv.Value;
//        [cell .imageView setImage:nil];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        selectedRow=indexPath.row;
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
            [alert show];
        }else{
            wcfService* service = [wcfService service];
            NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler2:) version:version];
        }
    }
}
- (void) xisupdate_iphoneHandler2: (id) value {
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfKeyValueItem *kv =[result objectAtIndex:selectedRow];
//        NSLog(@"%@", kv);
        if (![kv.Key isEqualToString:@"VPO Pending"]) {
            projectpols *pl =[projectpols alloc];
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.tbindex=self.tbindex;
            pl.isfromdevelopment=self.isfromdevelopment;
            pl.managedObjectContext=self.managedObjectContext;
            pl.idproject=self.idproject;
            pl.idvendor=self.idvendor;
            pl.xtatus=kv.Key;
            [self.navigationController pushViewController:pl animated:NO];
        }else{
            if ([kv.Value rangeOfString:@"(0)"].location == NSNotFound  ) {
                vpopendinglsViewController *vc =[vpopendinglsViewController alloc];
                vc.menulist=self.menulist;
                vc.detailstrarr=self.detailstrarr;
                vc.tbindex=self.tbindex;
                vc.idproject=self.idproject;
                vc.managedObjectContext=self.managedObjectContext;
                [self.navigationController pushViewController:vc animated:NO];
            }
            
        }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
