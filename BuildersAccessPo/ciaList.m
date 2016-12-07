//
//  ciaList.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import "ciaList.h"
#import "userInfo.h"
#import "wcfService.h"
#import "wcfKeyValueItem.h"
#import "wcfArrayOfKeyValueItem.h"
#import "Mysql.h"
#import "projectls.h"
#import "MBProgressHUD.h"
#import "wcfProjectListItem.h"
#import "cl_cia.h"
#import "cl_project.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "phonelist.h"
#import "cl_phone.h"
#import "cialistCell.h"
#import "cialistfirstCell.h"

@interface ciaList ()<MBProgressHUDDelegate, cialistfirstCellDelegate>{
    MBProgressHUD *HUD;
    cialistfirstCell *cell2;
}
@end

int currentpage, pageno;

@implementation ciaList

@synthesize ciaListresult, islocked;

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
    [self setTitle:((wcfKeyValueItem *)[self.menulist objectAtIndex:self.tbindex]).Key];
    // Do any additional setup after loading the view from its nib.
   islocked=0;
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
    //    UITabBarItem *t = [ntabbar.items objectAtIndex:13];
    //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
    //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0] setTag:1];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
//    [[ntabbar.items objectAtIndex:13] setTag:2];
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh1.png"] ];
     [[ntabbar.items objectAtIndex:13]setTitle:@"Sync" ];
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshCiaList:)];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES ];

    
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    [self.uw addSubview: searchtxt];
    searchtxt.delegate=self;
     searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
   
    
       [self getcialist];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self refreshCiaList:nil];
    }
}

- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    cl_cia *mp =[[cl_cia alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"(cianame like [c]'*%@*') or (ciaid like '%@*')", searchtxt.text, searchtxt.text] ;
        
    ciaListresult=[mp getCiaListWithStr:str];
    
    UITableView *tbview=(UITableView *)[self.uw viewWithTag:2];
    
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)getcialist{
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
//    NSLog(@"%@", self.uw);
    if (([ciaListresult count]+1)*44<self.uw.frame.size.height-44) {
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, ([ciaListresult count]+1)*44)];
    }else{
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
        
    }
    
//    NSLog(@"self.uw.frame.size.width %f", self.uw.frame.size.width);
    
//    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake()];
//    ciatbview.layer.borderWidth = 1.2;
//    ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    ciatbview.layer.cornerRadius = 10;
//    ciatbview.separatorInset = UIEdgeInsetsZero;
    ciatbview.separatorColor = [UIColor clearColor];
    ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    ciatbview.tag=2;
    [self.uw addSubview:ciatbview];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
    
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
       return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return [self.ciaListresult count]; 
    }
    
    
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        
//        NSLog(@"%f -- %f", tableView.separatorInset.left, tableView.separatorInset.right);
        static NSString *CellIdentifier = @"CellcialistCell";
        
        cialistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
            cell = [[cialistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
//        }
        
        NSEntityDescription *cia =[ciaListresult objectAtIndex:indexPath.row];
   
        cell.Id=[cia valueForKey:@"ciaid"];
        cell.Cname=[cia valueForKey:@"cianame"];
//        cell.textLabel.text = @"afsf";
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", idnm, [cia valueForKey:@"cianame"]];
//        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        
//        [cell .imageView setImage:nil];
        return cell;

    }
    
    
}

- (void)orientationChanged{
    [super orientationChanged];
    CGRect f= ciatbview.frame;
    
    if (([ciaListresult count]+1)*44<self.uw.frame.size.height-44) {
        f.size.height=([ciaListresult count]+1)*44;
    }else{
        f.size.height=self.uw.frame.size.height-44;
        
    }
    ciatbview.frame=f;
   
//    ciatbview.frame=CGRectMake(10, 54, self.uw.frame.size.width-20, self.uw.frame.size.height-64);
//    searchtxt.frame= CGRectMake(0, 0, self.uw.frame.size.width, 44);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        if (indexPath.row==self.tbindex) {
            return;
        }
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [self autoUpd];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
        if (!cell2) {
            cell2 = [[cialistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
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
    
    [ciaListresult sortUsingComparator:^NSComparisonResult(wcfKeyValueItem* obj1, wcfKeyValueItem* obj2) {
        NSString *ts;
        if ([str isEqualToString:@"Key"]) {
            ts=@"ciaid";
        }else{
            ts=@"cianame";
        }
        if (isup) {
            return [[obj1 valueForKey:ts] compare:[obj2 valueForKey:ts]];
        }else{
            return [[obj2 valueForKey:ts] compare:[obj1 valueForKey:ts]];
        }
        
    }];
    [ciatbview reloadData];
    
}

-(void)autoUpd{
    
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    
      NSIndexPath *selectedIndexPath = [ciatbview indexPathForSelectedRow];
    
    [ciatbview deselectRowAtIndexPath:selectedIndexPath animated:YES];
    [searchtxt resignFirstResponder];
  
    
   NSEntityDescription *cia =[ciaListresult objectAtIndex:selectedIndexPath.row];
    NSLog(@"%@", [cia valueForKey:@"ciaid"]);
   [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"]integerValue] andNm:[cia valueForKey:@"cianame"]];

    if ([self.title isEqualToString:@"Phone List"]) {
        cl_phone *mp =[[cl_phone alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp IsFirstTimeToSyncPhone]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync Phone Lis with your phone, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 2;
            [alert show];
        }else{
            [self gotoNextPage];
            
        }
    }else{
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync: [[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue] :@"1"]) {
            
            cl_project *cp =[[cl_project alloc]init];
            cp.managedObjectContext=self.managedObjectContext;
            [cp deletaAll:0];
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync all projects with your phone, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 0;
            [alert show];
        }else{
            [self gotoNextPage];
            
        }
    }
    
}

-(IBAction)refreshCiaList:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:@"We will sync all companies with your device, this will take some time, Are you sure you want to continue?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
    }
    
    
}

- (void) vGetCiaListHandler: (id) value {
    // Handle errors
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray *result1 = (NSMutableArray*)value;
    
    if([result1 isKindOfClass:[wcfArrayOfKeyValueItem class]]){
        cl_cia *mcia = [[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        [mcia deletaAll];
        [mcia addToCia:result1];
    }
    
    HUD.progress= 1;
    [HUD hide];
    
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms updSync:@"0" :@"0" :[[NSDate alloc] init]];
    
    UITableView *ut = (UITableView *)[self.view viewWithTag:2];
    [ut reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self getProjectList:1];
            }
               break;
                
		}
		return;
	}else if(alertView .tag==1){
    //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                [self doSyncCialist];
            }
            break;
        }
    }else if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
        }
    }else if(alertView .tag==100){
        for (UIWindow* window in [UIApplication sharedApplication].windows) {
            NSArray* subviews = window.subviews;
            if ([subviews count] > 0){
                for (UIAlertView* cc in subviews) {
                    if ([cc isKindOfClass:[UIAlertView class]]) {
                        [cc dismissWithClickedButtonIndex:0 animated:YES];
                    }
                }
            }
        }
    }

}

-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Phone List..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Phone List...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"3"];
    }

}

-(void)doSyncCialist{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Company..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Company...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        [service xGetCiaList:self action:@selector(vGetCiaListHandler:) xemail: [userInfo getUserName] xpassword: [[userInfo getUserPwd] copy] EquipmentType:@"5"];
    }

}

- (void) xGetPhoneListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
    if([value isKindOfClass:[NSError class]]) {
         [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
         [HUD hide];
        SoapFault *sf =value;
        
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }

    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    [HUD hide];
    [self gotoNextPage];
    
}


-(void)getProjectList:(int)xpageNo {
    
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
         alert.delegate=self;
        alert.tag=100;
        [alert show];
       
    }else{
        if (xpageNo==1) {
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Project..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Synchronizing Project...  ";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            islocked=1;
        }else{
            HUD.progress= (currentpage*1.0/pageno);
            
        }
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
       [service xSearchProject:self action:@selector(xSearchProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  xtype: 0 currentPage: xpageNo EquipmentType: @"3"];
 
    }
}

- (void) xSearchProjectHandler: (id) value {

    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        if ([result count]>0) {
//            wcfProjectListItem *kv = (wcfProjectListItem *)[result objectAtIndex:0];
//            pageno=kv.TotalPage;
//            [result removeObjectAtIndex:0];
//
//            cl_project *mp=[[cl_project alloc]init];
//            mp.managedObjectContext=self.managedObjectContext;
//            [mp addToProject:result];
            
            
            wcfProjectListItem *kv;
            
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageno=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            NSString* scheduleyn=kv.IDNumber;
            [result removeObjectAtIndex:0];
            
            
            
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToProject:result andscheleyn:scheduleyn];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self getProjectList:currentpage];
            }else{
                HUD.progress = 1;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [HUD hide];
                
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                
                
                if (self.islocked==2) {
                    if (![[self unlockPasscode] isEqualToString:@""] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                        
                        [self.navigationItem setHidesBackButton:NO];
                        
                        [self enterPasscode:nil];
                    }else{
                        [self gotoNextPage];                }
                    
                }else{
                    [self gotoNextPage];
                    
                }
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
            
            
            [self gotoNextPage];
        
        }
        
    }
}

-(void)gotoNextPage{
    if([self.title isEqualToString:@"Phone List" ]){
        phonelist *pl =[phonelist alloc];
        pl.menulist=self.menulist;
        pl.detailstrarr=self.detailstrarr;
        pl.tbindex=self.tbindex;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:NO];
    }else {
        projectls *LoginS=[[projectls alloc]init];
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
        UINavigationItem *item =[[self.navigationBar items]objectAtIndex:0];
        LoginS.atitle=item.title;
        self.islocked=0;
        [self.navigationController pushViewController:LoginS animated:NO];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self orientationChanged];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    if (islocked==2) {
        [self dismissViewControllerAnimated:YES completion:^() {
             [self gotoNextPage];
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
