//
//  phonelist.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "phonelist.h"
#import "cl_sync.h"
#import "MBProgressHUD.h"
#import "cl_phone.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "phoneDetail.h"
#import "phonelistCell.h"
#import "phonelistfirstCell.h"

@interface phonelist ()<MBProgressHUDDelegate, phonelistfirstCellDelegate>{
    MBProgressHUD *HUD;
}


@end

@implementation phonelist{
    phonelistfirstCell *cell2;
}
@synthesize rtnlist;
@synthesize  tbview, isfrommainmenu;

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
                cell2 = [[phonelistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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
    [rtnlist sortUsingComparator:^NSComparisonResult(NSEntityDescription* obj1, NSEntityDescription* obj2) {
      if (isup) {
                return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
            }else{
                return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
            }
     
        
    }];
    
    [tbview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Phone List"];
    
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
    
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    searchtxt.delegate=self;
    [self.uw addSubview: searchtxt];
    searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [self getPhonels];
    if (isfrommainmenu) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    }
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh1.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Sync" ];
    
   
    
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self refreshPrject: nil];
    }
}


- (void)doneClicked {
    [searchtxt resignFirstResponder];
}


- (void)getPhonels
{
    cl_phone *mp=[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    lastsync =[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue ] :@"5"];
    
    rtnlist = [mp getPhoneList:[NSString stringWithFormat:@"ciaid=%d",[userInfo getCiaId]] ];
  
    
//   sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
//    [self.uw addSubview:sv];
//    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UILabel *lbl =[[UILabel alloc]init];
    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
    lbl.textAlignment=NSTextAlignmentCenter;
     lbl.textColor=[UIColor darkGrayColor];
    lbl.tag=14;
    lbl.numberOfLines=2;
    [lbl sizeToFit];
    CGRect rect= lbl.frame;
    rect.origin.x=(ntabbar.frame.size.width-rect.size.width)/2;
    rect.origin.y=12;
    rect.size.height=40;
    lbl.frame=rect;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
    lbl.font=[UIFont systemFontOfSize:10.0];
    lbl.backgroundColor=[UIColor clearColor];
    [ntabbar addSubview:lbl];
//    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
    
    int dh =([rtnlist count]+1)*44;
    if (dh<self.uw.frame.size.height-44) {
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, dh)];
    }else{
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
    }
    
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
//    tbview.layer.cornerRadius = 10;
    tbview.delegate = self;
//    tbview.rowHeight=66.0f;
    tbview.tag=2;
    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    tbview.dataSource = self;
//    tbview.layer.borderWidth = 1.2;
//    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [self.uw addSubview:tbview];
}



-(IBAction)refreshPrject:(id)sender{
    
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
                                                           message:@"We will sync Phone List with your device, this will take some time, Are you sure you want to continue?"
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
                [self refreshPhoneList];
            }
                break;
        }
    }
}


-(void)refreshPhoneList{
    
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:[NSString stringWithFormat:@"Synchronizing %@...",self.title ] delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Phone List...  ";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];

        
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
       
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"3"];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [ntabbar setSelectedItem:nil];
}

- (void) xGetPhoneListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
    [mp deleteByCurrentCia];
    [mp addToPhone:result];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
    rtnlist=[mp getPhoneList:nil];
    
    [HUD hide];
    [tbview reloadData];
    
    [ntabbar setSelectedItem:nil];
    
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
     NSString *str =[NSString stringWithFormat:@"((name like [c]'*%@*') or (email like [c]'*%@*') or (title like [c]'*%@*')  or (tel like [c]'%@*') or (telhome like [c]'%@*') or (mobile like [c]'%@*')) and (ciaid = %d)", searchtxt.text, searchtxt.text , searchtxt.text, searchtxt.text, searchtxt.text, searchtxt.text,[userInfo getCiaId]] ;
    
    rtnlist=[mp getPhoneList:str];
    
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
         
        return [rtnlist count];
    }
}
-(void)orientationChanged{
    [super orientationChanged];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    [tbview reloadData];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
      [super gobig:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    [tbview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        static NSString *CellIdentifier = @"Cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
//            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        }
//        NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
//        cell.textLabel.text=[kv valueForKey:@"name"];
//        [cell.detailTextLabel setNumberOfLines:2];
//        if ([kv valueForKey:@"title"]==nil) {
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@", [kv valueForKey:@"Email"]];
//        }else{
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", [kv valueForKey:@"title"],[kv valueForKey:@"Email"]];
//        }
//        [cell .imageView setImage:nil];
//        return cell;
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            phonelistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil)
//                        {
//            cell = [[phonelistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//                            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                            cell.delegate=self;
//                        }
//            
//            return cell;
//        }else{
        static NSString *CellIdentifier = @"Cell";
        
        phonelistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
            cell = [[phonelistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
       
        NSEntityDescription *kv =[rtnlist objectAtIndex:indexPath.row];
        cell.Name=[kv valueForKey:@"name"];
        cell.Title=[kv valueForKey:@"title"];
        cell.Email= [kv valueForKey:@"Email"];
            return cell;
        
//        }

        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
         NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        [searchtxt resignFirstResponder];
        NSEntityDescription *kv =[rtnlist objectAtIndex:indexPath.row];
        phoneDetail *pd =[[phoneDetail alloc]init];
        pd.idmaster=[NSString stringWithFormat:@"%d", [userInfo getCiaId] ];
        pd.managedObjectContext=self.managedObjectContext;
        pd.menulist=self.menulist;
        pd.detailstrarr=self.detailstrarr;
        pd.tbindex=self.tbindex;
        pd.ename=[kv valueForKey:@"name"];
        pd.email =[kv valueForKey:@"Email"];
//        [self gootoonextPage:pd];
        [self.navigationController pushViewController:pd animated:NO];
        
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
