//
//  forapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprove.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "contractforapprovecials.h"
#import "calendarforapprove.h"
#import "Reachability.h"
#import "forapprovepocials.h"
#import "coforapprovecials.h"
#import "coforapprove.h"
#import "contractforapprove.h"
#import "forapprovepols.h"
#import "suggestforapprove.h"
#import "bustoutls.h"
#import "bustoutcials.h"
#import "requestedvpols.h"
#import "cntlistfirstCell.h"
#import "cntlistCell.h"

@interface forapprove ()<cntlistfirstCellDelegate>

@end

@implementation forapprove{
    cntlistfirstCell *cell2;
    NSMutableArray *rtnlistCopy;
}

@synthesize  rtnlist, mastercia;

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
    
    [self setTitle:@"For Approve"];
    
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
    

    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
     [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
   
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
    rtnlistCopy=[((wcfArrayOfKeyValueItem *)rtnlist)toMutableArray];
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self dorefresh:nil];
    }
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
 [tbview reloadData];
}

-(IBAction)dorefresh:(id)sender{
    
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
        
        //        UIAlertView *alert = nil;
        //        alert = [[UIAlertView alloc]
        //                 initWithTitle:@"BuildersAccess"
        //                 message:@"There is a new version?"
        //                 delegate:self
        //                 cancelButtonTitle:@"Cancel"
        //                 otherButtonTitles:@"Ok", nil];
        //        alert.tag = 1;
        //        [alert show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self getMenuList];
    }
}


-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    
     [self orientationChanged];
    [self getMenuList];
}
-(void)getMenuList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetMenuForApprove:self action:@selector(xGetMenuForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
    }
    
    
    
    }


- (void) xGetMenuForApproveHandler: (id) value {
    
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
    
	// Do something with the NSMutableArray* result
    rtnlist = (NSMutableArray*)value;
    rtnlistCopy=[((wcfArrayOfKeyValueItem *)rtnlist) toMutableArray];
    
    if (tbview!=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
    }else{
        int dh = [rtnlist count]*44+44;
        if (dh >self.uw.frame.size.height) {
            dh=self.uw.frame.size.height;
        }
         tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, dh)];
        tbview.rowHeight=44.0;
//        tbview.layer.cornerRadius = 10;
        tbview.tag=2;
//        tbview.layer.borderWidth = 1.2;
//        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        tbview.delegate = self;
        tbview.dataSource = self;
        [self.uw addSubview:tbview];
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
     return ([rtnlistCopy count]);
    }
   
    
    
}
- (void)orientationChanged{
    [super orientationChanged];
    [tbview reloadData];
//    tbview.frame=CGRectMake(10, 10, self.uw.frame.size.width-20, self.uw.frame.size.height-20);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        static NSString *CellIdentifier = @"Cell";
        
        cntlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[cntlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        wcfKeyValueItem *kv =[rtnlistCopy objectAtIndex:(indexPath.row)];
        cell.cnt=kv.Value;
        cell.Cname=kv.Key;
//        wcfKeyValueItem *kv =[rtnlistCopy objectAtIndex:(indexPath.row)];
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
//            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//
//        }
//               cntlbl *lt =[[cntlbl alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
//        lt.Cname=kv.Key;
//        lt.cnt=kv.Value;
//        [cell.contentView addSubview:lt];
        
        return cell;
    }
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
        if (!cell2) {
            cell2 = [[cntlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.cname=@"For Approve";
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
    
    [rtnlistCopy sortUsingComparator:^NSComparisonResult(wcfKeyValueItem* obj1, wcfKeyValueItem* obj2) {
      
        if ([str isEqualToString:@"Key"]) {
            if (isup) {
                return [obj1.Key compare:obj2.Key];
            }else{
                return [obj2.Key compare:obj1.Key];
            }
        }else{
            int t1 = [obj1.Value intValue];
            int t2 = [obj2.Value intValue];
            if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
            }
        }
        
        
    }];
    [tbview reloadData];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
//        if (indexPath.row==self.tbindex) {
//            [self.navigationController popViewControllerAnimated:NO];
//        }else{
//       
//        }
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
     wcfKeyValueItem *kv =[rtnlistCopy objectAtIndex:(indexPath.row)];
    if ([kv.Value isEqualToString:@"0"]) {
        return;
    }
    
    if ([kv.Key isEqualToString:@"Suggested Price"]) {
        suggestforapprove *pl =[[suggestforapprove alloc]init];
        pl.masterciaid=self.mastercia;
        pl.managedObjectContext=self.managedObjectContext;
        pl.menulist=self.menulist;
        pl.detailstrarr=self.detailstrarr;
        pl.tbindex=self.tbindex;
        [self.navigationController pushViewController:pl animated:NO];
    }else if ([kv.Key isEqualToString:@"Bust Out"]) {
        xtype=0;
        [self getcialistofcoforapprove];
        
//        bustoutls *pl =[[bustoutls alloc]init];
//        pl.masterciaid=self.mastercia;
//        pl.managedObjectContext=self.managedObjectContext;
//        pl.title=kv.Key;
//        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Change Orders"]) {
//        coforapprove *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"coforapprove"];
//        pl.managedObjectContext=self.managedObjectContext;
//        pl.masterciaid=self.mastercia;
//        [self.navigationController pushViewController:pl animated:YES];
        xtype=1;
        [self getcialistofcoforapprove];
        
    }else if ([kv.Key isEqualToString:@"Contract ISP"]) {
        xtype=2;
         [self getcialistofcoforapprove];
//        contractforapprovecials *pl =[[contractforapprovecials alloc]init];
//        pl.mastercia=self.mastercia;
//        pl.title=kv.Key;
//        pl.managedObjectContext=self.managedObjectContext;
//        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Calendar Builder"]) {
        calendarforapprove *pl =[calendarforapprove alloc];
        pl.mxtype=1;
         pl.masterciaid=self.mastercia;
        pl.detailstrarr=self.detailstrarr;
        pl.menulist=self.menulist;
        pl.tbindex=self.tbindex;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:NO];
    }else if ([kv.Key isEqualToString:@"Calendar Buyer"]) {
        calendarforapprove *pl =[calendarforapprove alloc];
        pl.detailstrarr=self.detailstrarr;
        pl.menulist=self.menulist;
        pl.tbindex=self.tbindex;

        pl.mxtype=2;
         pl.masterciaid=self.mastercia;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:NO];

  }else if ([kv.Key isEqualToString:@"PO For Approve"]) {
      
      xtype=3;
      [self getcialistofcoforapprove];
      potitle=kv.Key;      
  }else if ([kv.Key isEqualToString:@"PO Turn In"]) {
      xtype=4;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
//      forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
//      pl.mxtype=2;
//       pl.title=kv.Key;
//      pl.masterciaid=self.mastercia;
//      pl.managedObjectContext=self.managedObjectContext;
//      [self.navigationController pushViewController:pl animated:YES];
  }else if ([kv.Key isEqualToString:@"PO Hold"]) {
//      forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
//      pl.mxtype=3;
//       pl.title=kv.Key;
//      pl.masterciaid=self.mastercia;
//      pl.managedObjectContext=self.managedObjectContext;
//      [self.navigationController pushViewController:pl animated:YES];
      
      xtype=5;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
      

  }else if ([kv.Key isEqualToString:@"Requested VPO"]) {
      
      xtype=6;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
  }else if ([kv.Key isEqualToString:@"Requested VPO Hold"]) {
      
      xtype=7;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
  }
    
    
}


-(void)getcialistofcoforapprove{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
         [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==1) {
             [service xGetMenuCOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
        }else if(xtype==0){
             [service xGetMenuBustOutForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
        }else if(xtype==2){
            [service xGetMenuContractForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
        }else if(xtype==6){
            [service xGetMenuRequestedPOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
        }else if(xtype==7){
            [service xGetMenuRequestedPOHold:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
        }else{
            [service xGetMenuPOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia xtype:[[NSNumber numberWithInt:xtype-2] stringValue] EquipmentType:@"5"];
        }
       
    
    }
    
    
}

- (void) xGetMenuCOForApproveHandler: (id) value {
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray * rtnlist1=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    if (xtype==1) {
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            coforapprove *pl =[[coforapprove alloc]init];
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.managedObjectContext=self.managedObjectContext;
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.tbindex=self.tbindex;
            [self.navigationController pushViewController:pl animated:NO];
        }else{
            coforapprovecials *cc =[[coforapprovecials alloc]init];
            cc.menulist=self.menulist;
            cc.detailstrarr=self.detailstrarr;
            cc.tbindex=self.tbindex;
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
            cc.result=rtnlist1;
           [self.navigationController pushViewController:cc animated:NO];
        }
    }else if(xtype==0){
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            bustoutls *pl =[[bustoutls alloc]init];
            pl.managedObjectContext=self.managedObjectContext;
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.tbindex=self.tbindex;
            [self.navigationController pushViewController:pl animated:NO];
        }else{
            bustoutcials *cc =[[bustoutcials alloc]init];
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
        cc.menulist=self.menulist;
        cc.detailstrarr=self.detailstrarr;
        cc.tbindex=self.tbindex;
            cc.result=rtnlist1;
            [self.navigationController pushViewController:cc animated:NO];
        }
    }else if(xtype==2){
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            contractforapprove *pl =[[contractforapprove alloc]init];
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.tbindex=self.tbindex;
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:NO];
            
        }else{
            contractforapprovecials *cc =[[contractforapprovecials alloc]init];
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
            cc.result=rtnlist1;
            cc.menulist=self.menulist;
            cc.detailstrarr=self.detailstrarr;
            cc.tbindex=self.tbindex;
            [self.navigationController pushViewController:cc animated:NO];
        }

    }else{
        if ([rtnlist1 count]==1) {
             wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            if (xtype!=6 && xtype!=7) {
               
                NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
                forapprovepols *LoginS=[forapprovepols alloc];
                LoginS.menulist=self.menulist;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.tbindex=self.tbindex;
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.mxtype=xtype-2;
                LoginS.atitle=potitle;
                [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
                [self.navigationController pushViewController:LoginS animated:NO];
            }else{
                NSArray *firstSplit = [kv.Value componentsSeparatedByString:@"("];
                [userInfo initCiaInfo:[kv.Key integerValue] andNm:[firstSplit objectAtIndex:0]];
            
                requestedvpols *LoginS=[requestedvpols alloc];
                LoginS.menulist=self.menulist;
                LoginS.xtype=xtype;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.tbindex=self.tbindex;
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.title=potitle;
                [self.navigationController pushViewController:LoginS animated:NO];
            }
            
        }else{
        
            forapprovepocials *pl =[forapprovepocials alloc];
            pl.menulist=self.menulist;
            pl.detailstrarr=self.detailstrarr;
            pl.tbindex=self.tbindex;
            pl.mxtype=xtype-2;
            pl.atitle=potitle;
            pl.masterciaid=self.mastercia;
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:NO];
        }
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
