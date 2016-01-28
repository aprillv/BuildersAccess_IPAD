//
//  mastercialist.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mastercialist.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "userInfo.h"
#import "wcfKeyValueItem.h"
#import "forapprove.h"
#import "wcfService.h"
#import "Reachability.h"
#import "cl_phone.h"
#import "cl_sync.h"
#import "phonelist.h"
#import "multiSearch.h"
#import "cialistCell.h"
#import "cialistfirstCell.h"

@interface mastercialist ()<cialistfirstCellDelegate>

@end

@implementation mastercialist{
    cialistfirstCell *cell2;
}

@synthesize rtnlist, rtnlist1, type, atitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    [rtnlist sortUsingComparator:^NSComparisonResult(wcfKeyValueItem* obj1, wcfKeyValueItem* obj2) {
        
        if ([str isEqualToString:@"Key"]) {
            if (isup) {
                return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
            }else{
                return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
            }
        }else{
            NSString *t1 = [obj1.Value substringFromIndex:([obj1.Key length]+3)];
            NSString *t2 = [obj2.Value substringFromIndex:([obj2.Key length]+3)];
            if (isup) {
                return [t1 compare:t2];
            }else{
                return [t2 compare:t1];
            }
        }
        
        
    }];
    [ciatbview reloadData];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self dorefresh:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setTitle:((wcfKeyValueItem *)[self.menulist objectAtIndex:self.tbindex]).Key];
    
  
    rtnlist1=rtnlist;

    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
    //    UITabBarItem *t = [ntabbar.items objectAtIndex:13];
    //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
    //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
//    UITabBarItem *t = [ntabbar.items objectAtIndex:13];
//    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
//    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];

    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
  
    
    
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
//    [self.uw addSubview:uv];
    
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    [self.uw addSubview: searchtxt];
//    uv.backgroundColor=[UIColor whiteColor];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    searchtxt.delegate=self;
     searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
//     ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, self.uw.frame.size.height-44)];
    
    if (([rtnlist count]+1)*44<self.uw.frame.size.height-44) {
         ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, ([rtnlist count]+1)*44)];
    }else{
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, self.uw.frame.size.height-44)];

    }
   
    
//    ciatbview.layer.cornerRadius = 10;
    ciatbview.tag=2;
//    ciatbview.layer.borderWidth = 1.2;
//    ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];    [ciatbview setRowHeight:44.0f];
    [self.uw addSubview:ciatbview];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
     ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
}


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    UITableView *tbview=(UITableView *)[self.uw viewWithTag:2];

    NSString *str;
    str=[NSString stringWithFormat:@"Key like '%@*' or Value like [c]'*%@*'", searchtxt.text, searchtxt.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
    
}

//- (void)orientationChanged{
//    [super orientationChanged];
////    UITableView *tbview=(UITableView *)[self.uw viewWithTag:2];
////    tbview.frame=CGRectMake(10, 54, self.uw.frame.size.width-20, self.uw.frame.size.height-64);
////    searchtxt.frame= CGRectMake(0, 0, self.uw.frame.size.width, 44);
//}

-(IBAction)dorefresh:(id)sender{
    [searchtxt setText:@""];
    UITableView *tbview=(UITableView *)[self.uw viewWithTag:2];
    rtnlist=nil;
    [tbview reloadData];
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
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            wcfService *service =[wcfService service];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"5"];
        }

    }
    
    
}


- (void) xGetMasterCiaHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    UITableView *tbview=(UITableView *)[self.uw viewWithTag:2];

    
	// Do something with the NSMutableArray* result

    self.rtnlist =[(wcfArrayOfKeyValueItem*)value toMutableArray];
    rtnlist1=rtnlist;
    
    searchtxt.text=@"";
    [tbview reloadData];
    [ntabbar setSelectedItem:nil];
}


#pragma mark - TableView Methods
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([ciatbview respondsToSelector:@selector(setSeparatorInset:)]) {
        [ciatbview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([ciatbview respondsToSelector:@selector(setLayoutMargins:)]) {
        [ciatbview setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return [self.rtnlist count];
    }
     // or self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (tableView.tag==1) {
         return [super tableView:tableView cellForRowAtIndexPath:indexPath];
     }else{
         static NSString *CellIdentifier = @"Cell";
         
         cialistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             cell = [[cialistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
             cell.accessoryType = UITableViewCellAccessoryNone;
             cell.selectionStyle = UITableViewCellSelectionStyleBlue;
         wcfKeyValueItem *cia =[rtnlist objectAtIndex:indexPath.row];
         cell.Id=cia.Key;
         cell.Cname=[cia.Value substringFromIndex:([cia.Key length]+3)];
         return cell;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        if (indexPath.row==self.tbindex) {
           return;
        }
        return[super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler1:) version:version];
        }
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
        
    }else {
        
        if ([[self getTitle] isEqualToString:@"Phone List"]) {
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            
            cl_sync *mp =[[cl_sync alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
             if ([mp isFirttimeToSync:kv.Key :@"5"]) {
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
                phonelist *pl =[[phonelist alloc]init];
                pl.managedObjectContext=self.managedObjectContext;
                pl.menulist=self.menulist;
                pl.detailstrarr=self.detailstrarr;
                pl.tbindex=self.tbindex;
                [self.navigationController pushViewController:pl animated:NO];
            }
                
        }else if ([[self getTitle] isEqualToString:@"For Approve"]){
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            forapprove *fr =[[forapprove alloc]init];
            fr.tbindex=1;
            fr.menulist=self.menulist;
            fr.detailstrarr=self.detailstrarr;
            fr.managedObjectContext=self.managedObjectContext;
            fr.mastercia=kv.Key;
            fr.title=@"For Approve";
            [self.navigationController pushViewController:fr animated:NO];
        }else{
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            
            multiSearch *k =[[multiSearch alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.menulist=self.menulist;
            k.detailstrarr=self.detailstrarr;
            k.tbindex=self.tbindex;
            k.atitle=atitle;
            [self.navigationController pushViewController:k animated:NO];
        }
        
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [ciatbview reloadData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
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
    phonelist *pl =[[phonelist alloc]init];
    pl.managedObjectContext=self.managedObjectContext;
    pl.menulist=self.menulist;
    pl.detailstrarr=self.detailstrarr;
    pl.tbindex=self.tbindex;
    [self.navigationController pushViewController:pl animated:NO];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
