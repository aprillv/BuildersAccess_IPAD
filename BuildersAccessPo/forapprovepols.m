//
//  forapprovepols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprovepols.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "po1.h"
#import "forapprove.h"
#import "polistcell.h"
#import "polistfirstCell.h"

@interface forapprovepols ()<MBProgressHUDDelegate, polistfirstCellDelegate>{
    int pageNo;
    int currentpage;
}

@end


@implementation forapprovepols{
    MBProgressHUD *HUD;
    polistfirstCell *cell2;
}

@synthesize  mxtype, result,result1, atitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)doaClicked:(NSString *)str :(BOOL)isup{
    [result sortUsingComparator:^NSComparisonResult(wcfPOListItem* obj1, wcfPOListItem* obj2) {
//        if ([str isEqualToString:@"Total"]) {
//            double t1 =[[[[[[obj1 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@"-"] stringByReplacingOccurrencesOfString:@")" withString:@""] doubleValue];
//            double t2 =[[[[[[obj2 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""]stringByReplacingOccurrencesOfString:@"(" withString:@"-"] stringByReplacingOccurrencesOfString:@")" withString:@""]doubleValue];
//            if (isup) {
//                return t1>t2;
//            }else{
//                return t1<t2;
//            }
//        }else{
            if (isup) {
                return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
            }else{
                return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
            }
//        }
        
    }];
    
    [ciatbview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:atitle];
    pageNo=0;
    currentpage=1;
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    searchtxt.delegate=self;
    [self.uw addSubview: searchtxt];
    searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    
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
        
//    int dwidth = self.uw.frame.size.width;
//    int dheight =self.uw.frame.size.height;
//    
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
//    uv.backgroundColor=[UIColor whiteColor];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshPrject:) ];
   
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self refreshPrject: nil];
    }
}


-(IBAction)refreshPrject:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler3:) version:version];
    }
}
- (void) xisupdate_iphoneHandler3: (id) value {
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
        [ciatbview removeFromSuperview];
        result=nil;
        result1=nil;
        [searchtxt setText:@""];
        [self getPols:1];
    }
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchtxt setText:@""];
    [ciatbview removeFromSuperview];
    [self getPols:1];
}


-(void)getPols:(int)xpageNo {
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:[NSString stringWithFormat:@"Downloading %@...", atitle] delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=[NSString stringWithFormat:@"Downloading %@...", atitle];
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }else{
//        alertViewWithProgressbar.progress= ((xpageNo-1)*100/pageNo);
        HUD.progress= ((xpageNo-1)*1.0/pageNo);
        
    }
    currentpage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetPOForApproveList:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xtype:[[NSNumber numberWithInt:mxtype]stringValue] currentPage:xpageNo EquipmentType:@"5"];
    }

}
- (void) xGetPOForApproveListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    
    NSMutableArray *ns1 =[(wcfArrayOfPOListItem*)value toMutableArray];
    
    wcfPOListItem *pi;
    if (pageNo==0) {
        pi= (wcfPOListItem *)[ns1 objectAtIndex:0];
        pageNo=[pi.TotalPage intValue];
    }
    
    [ ns1 removeObjectAtIndex:0];
    

    if (result==nil) {
         result=[[NSMutableArray alloc]init];
    }
   
     [result addObjectsFromArray:ns1];
    
    if (currentpage==pageNo) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        HUD.progress=1;
        [HUD hide];
        
        result1=result;
       
        
        if (ciatbview ==nil) {
            int dwidth =self.uw.frame.size.width;
            int dheight =self.uw.frame.size.height;
            int dh =([result count]+1)*44;
            if (dh>dheight-44) {
                dh=dheight-44;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
            
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//            uv.contentSize=CGSizeMake(dwidth,dheight-43);
//             uv.backgroundColor=[UIColor whiteColor];
//            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag = 2;
//            ciatbview.rowHeight=70;
//            ciatbview.layer.borderWidth = 1.2;
//            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            [self.uw addSubview: ciatbview];
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
        }else{
            [self.uw addSubview: ciatbview];
            [ciatbview reloadData];
        }

        [ntabbar setSelectedItem:nil];
    }else{
        [self getPols:(currentpage+1)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [result count];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[polistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
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

-(void)orientationChanged{
    [super orientationChanged];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    [ciatbview reloadData];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [ciatbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
    [ciatbview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        static NSString *CellIdentifier = @"Cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
//            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        }
//        
//        wcfPOListItem *kv =[result objectAtIndex:(indexPath.row)];
//        
//        cell.textLabel.text = kv.Doc;
//        [cell.detailTextLabel setNumberOfLines:2];
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", kv.Nvendor, kv.Nproject];
//        [cell .imageView setImage:nil];
//        return cell;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            polistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil){
//                cell = [[polistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            cell.delegate=self;
//            return cell;
//        }else{
            static NSString *CellIdentifier = @"Cell";
            
            polistcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[polistcell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            wcfPOListItem *kv =[result objectAtIndex:indexPath.row];
            cell.Doc=kv.Doc;
            cell.Nvendor=kv.Nvendor;
            cell.Shipto=kv.Shipto;
            cell.Nproject=kv.Nproject;
            
            return cell;
        }
        
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [searchtxt resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfPOListItem *kv =[result objectAtIndex:indexPath.row];
        po1 *LoginS=[po1 alloc];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idpo1=kv.Idnumber;
        LoginS.fromforapprove=1;
        LoginS.xcode=kv.Code;
        [self.navigationController pushViewController:LoginS animated:NO];
    }
    
    
}

- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Nvendor like [c]'*%@*' or Nproject like [c]'*%@*' or Shipto like [c]'*%@*'", searchText, searchText, searchText, searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
