//
//  requestedvpols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "requestedvpols.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "po1.h"
#import "forapprove.h"
#import "requestvpo.h"
#import "project.h"
#import "development.h"
#import "vpolistCell.h"
#import "vpolistfirstCell.h"

@interface requestedvpols ()<vpolistfirstCellDelegate>

@end
@implementation requestedvpols{
    UISearchBar *searchBar;
   UIButton * btnNext;
    vpolistfirstCell *cell2;
}

@synthesize result,result1, xtype, idproject;


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
    if (xtype==6) {
         [self setTitle:@"Requested VPO"];
    }else if(xtype==8){
        [self setTitle:@"Requested VPO"];
    }else{
        
      [self setTitle:@"Requested VPO Hold"];   
    }
   
    //    [self getPols:1];
    
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
    
    
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    [self.uw addSubview: searchBar];
    searchBar.delegate=self;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    searchBar.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
//    [self.uw addSubview:uv];
//    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
//    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    if (xtype!=8) {
         [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    }else{
     [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
   
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
   
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goback1:) ];
//    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
   
    [[ntabbar.items objectAtIndex:13] setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13] setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:nil];
    }else if(item.tag == 2){
        [self refreshPrject:nil];
    }
}

-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

-(IBAction)refreshPrject:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [ciatbview removeFromSuperview];
        result=nil;
        result1=nil;
        [searchBar setText:@""];
        [self getPols];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchBar setText:@""];
    [self getPols];
}


-(void)getPols {
   
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==6) {
            [service xGetRequestedPOForApproveLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType:@"5"];
        }else  if (xtype==8) {
            [service xGetProjectRequestedPOLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:idproject EquipmentType:@"3"];
        }else{
        [service xGetRequestedPOHoldLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType:@"5"];
        }
    
    }
    
}
- (void) xGetPOForApproveListHandler: (id) value {
    
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    
	// Do something with the NSMutableArray* result
      
    result =[(wcfArrayOfRequestedPOListItem*)value toMutableArray];
//    NSLog(@"%@", result);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
     
        
        result1=result;
        
  
        if (ciatbview ==nil) {
           
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
            
            int dwidth =self.uw.frame.size.width;
            int dheight =self.uw.frame.size.height;
            int dh =([result count]+1)*44;
            if (dh>dheight-44) {
                dh=dheight-44;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
            
//            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=2;
//            ciatbview.rowHeight=84;
//            ciatbview.layer.borderWidth = 1.2;
//            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];  
            [self.uw addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
        }else{
            
            [ciatbview reloadData];
        }
        
        [ntabbar setSelectedItem:nil];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
            if (!cell2) {
                cell2 = [[vpolistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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


-(void)doaClicked:(NSString *)str :(BOOL)isup{
    [result sortUsingComparator:^NSComparisonResult(wcfCOListItem* obj1, wcfCOListItem* obj2) {
        if ([str isEqualToString:@"Total"]) {
//            double t1 =[[[[obj1 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
//            double t2 =[[[[obj2 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
            double t1 =[[[obj1 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            double t2 =[[[obj2 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
            if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
            }
        }else if ([str isEqualToString:@"RequestedDate"]) {
            NSString *t1=[obj1 valueForKey:str];
            NSString *t2 =[obj2 valueForKey:str];
            t1=[NSString stringWithFormat:@"%@%@",[t1 substringFromIndex:6], [t1 substringToIndex:5]];
            
            t2=[NSString stringWithFormat:@"%@%@",[t2 substringFromIndex:6], [t2 substringToIndex:5]];
            
            if (isup) {
                return [t1 compare:t2];
            }else{
                return [t2 compare:t1];;
            }
        }else{
            if (isup) {
                return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
            }else{
                return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
            }
        }
        
    }];
    
    [ciatbview reloadData];
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
    
    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
//    
//    wcfRequestedPOListItem *kv =[result objectAtIndex:(indexPath.row)];
//    
//    cell.textLabel.text = kv.Nproject;
//    [cell.detailTextLabel setNumberOfLines:3];
////    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\nRequested: %@", kv.Nvendor, kv.RequestedDate];
//    
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"Request # %@ @ %@\n%@\nTotal: %@", kv.IdNumber, kv.RequestedDate, kv.Nvendor, kv.Total];
//    
//    [cell .imageView setImage:nil];
//    return cell;
        
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            vpolistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil){
//                cell = [[vpolistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            cell.delegate=self;
//            return cell;
//            
//           
//            
//            
//        }else{
            static NSString *CellIdentifier = @"Cell";
            
            vpolistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //               if (cell == nil)
            //                {
            cell = [[vpolistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //                }
            
            wcfRequestedPOListItem *kv =[result objectAtIndex:indexPath.row];
            cell.RequesteNo=kv.IdNumber;
            cell.Requested=kv.RequestedDate;
            cell.Project=kv.Nproject;
            cell.Nvendor=kv.Nvendor;
            cell.Total=kv.Total;
            return cell;
//        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
         [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
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
        [searchBar resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfRequestedPOListItem *kv =[result objectAtIndex:indexPath.row];
        requestvpo *LoginS=[requestvpo alloc];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idnum=kv.IdNumber;
        if (xtype==8) {
            LoginS.fromforapprove=0;
        }else{
        LoginS.fromforapprove=1;
        }
        
        [self.navigationController pushViewController:LoginS animated:NO];
    }
    
    
}

- (void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar2 textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Nproject like [c]'*%@*' or Nvendor like '*%@*' or RequestedDate like [c]'*%@*'", searchBar.text, searchBar.text, searchBar.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar2{
    [searchBar resignFirstResponder];
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
