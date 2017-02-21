//
//  projectpols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectpols.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "project.h"
#import "development.h"
#import "wcfArrayOfStartPackItem.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"
#import "polistcell.h"
#import "polistfirstCell.h"


@interface projectpols ()<UISearchBarDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate, polistfirstCellDelegate>
@end

@implementation projectpols{
    polistfirstCell *cell2;
    CustomKeyboard *keyboard;
    NSMutableArray* result1;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    int currentpage;
    int pageNo;
    MBProgressHUD *HUD;
    UIButton *btnNext;
}

@synthesize idproject, result, xtatus, isfromdevelopment, idvendor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)gotoProject:(id)sender{
    if (isfromdevelopment!=-1) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if(isfromdevelopment){
                if ([temp isKindOfClass:[development class]]) {
                    [self.navigationController popToViewController:temp animated:NO];
                }
            }else{
                
                
                if ([temp isKindOfClass:[project class]]) {
                    [self.navigationController popToViewController:temp animated:NO];
                }}
            
        }
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.xtatus isEqualToString:@"Show All"]) {
        [self setTitle:@"All POs"];
    }else{
    [self setTitle:[NSString stringWithFormat:@"%@ POs", self.xtatus]];
    }
    
    
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
    
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dwidth, 44)];
    [self.uw addSubview: searchBar];
    searchBar.delegate=self;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
//    uv.backgroundColor=[UIColor whiteColor];
    
    
    if (isfromdevelopment==0) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    }else if (isfromdevelopment==1){
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    }
    
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
            
    
    // Do any additional setup after loading the view from its nib.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject: nil];
    }else if(item.tag == 2){
        [self dorefresh: nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    result=nil;
    result1=nil;
    [searchBar setText:@""];
    [self getPols:1];
     [super viewWillAppear:animated];
    [self orientationChanged];
}

-(void)getPols:(int)xpageNo {
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"  Downloading Purchase Order...  " delegate:self otherButtonTitles:nil];
//        [alertViewWithProgressbar show];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Downloading Purchase Order...  ";
        
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
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetPO93list:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:idvendor xstatus:xtatus currentPage:currentpage EquipmentType:@"5"];
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
//            uv.contentSize=CGSizeMake(dwidth,dheight-43);
//            uv.backgroundColor=[UIColor whiteColor];
            
            ciatbview.tag = 2;
//            ciatbview.layer.cornerRadius = 10;
//            ciatbview.layer.borderWidth = 1.2;
//            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            [self.uw addSubview: ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            
//            uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
        }else{
            [self.uw addSubview: ciatbview];
            [ciatbview reloadData];
        }
        [ntabbar setSelectedItem:nil];
    }else{
        [self getPols:(currentpage+1)];
    }
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
    
    NSString* resultd = (NSString*)value;
    if ([resultd isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        result=nil;
        result1=nil;
        [searchBar setText:@""];
        [self getPols:1];
    }
    
    
}

-(void)doaClicked:(NSString *)str :(BOOL)isup{
    
    [result sortUsingComparator:^NSComparisonResult(wcfPOListItem* obj1, wcfPOListItem* obj2) {
//        if ([str isEqualToString:@"Total"]) {
//            double t1 =[[[[obj1 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
//            double t2 =[[[[obj2 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [self.result count]; // or self.items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

   
    
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            polistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil)
//            {
//                cell = [[polistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }            cell.delegate=self;
////            cell.Doc=@"Doc";
////            cell.Nvendor=@"Vendor Name";
////            cell.Shipto=@"Notes";
////            cell.Status=@"Stauts";
//             return cell;
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
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
        [searchBar resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfPOListItem *kv =[result objectAtIndex:indexPath.row];
        po1 *LoginS=[po1 alloc];
        if (isfromdevelopment==1) {
            LoginS.fromforapprove=2;
        }else if (isfromdevelopment==0){
            LoginS.fromforapprove=3;
        }else{
        LoginS.fromforapprove=4;
        }
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.menulist=self.menulist;
        LoginS.tbindex=self.tbindex;
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idpo1=kv.Idnumber;
        LoginS.xcode=kv.Code;
        [self.navigationController pushViewController:LoginS animated:NO];
    }
}

-(void)orientationChanged{
    [super orientationChanged];
//    int dwidth =self.uw.frame.size.width;
//    int dheight=self.uw.frame.size.height;
//    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
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

- (void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Nvendor like [c]'*%@*' or Nproject like [c]'*%@*' or Shipto like [c]'*%@*'", searchText, searchText, searchText, searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
