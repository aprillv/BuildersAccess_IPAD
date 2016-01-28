//
//  vendorpocials.m
//  BuildersAccess
//
//  Created by roberto ramirez on 10/9/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "vendorpocials.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "Reachability.h"
#import "projectpo.h"
#import <QuartzCore/QuartzCore.h>
#import "cntlistCell.h"
#import "cntlistfirstCell.h"

@interface vendorpocials ()<cntlistfirstCellDelegate>

@end

@implementation vendorpocials{
//    UIScrollView *uv;
    NSMutableArray *result;
    UITableView *uVendorTable;
    int tmcia;
    UIButton *btnNext;
    cntlistfirstCell *cell2;
}

@synthesize idvendor=_idvendor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}
//-(void)loadView{
//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    
//    //    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    //    [view addSubview: searchBar];
//    //    searchBar.delegate=self;
//    //
//    //    keyboard=[[CustomKeyboard alloc]init];
//    //    keyboard.delegate=self;
//    //    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
//    
//    self.view = view;
//    
//    if (view.frame.size.height>480) {
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 454, 320, 50)];
//    }else{
//        
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 366, 320, 50)];
//    }
//    [view addSubview:ntabbar];
//    
//    UITabBarItem *firstItem0 ;
//    UITabBarItem *fi =[[UITabBarItem alloc]init];
//    UITabBarItem *f2 =[[UITabBarItem alloc]init];
//    UITabBarItem *firstItem2;
//    
//    firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
//    
//    firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
//    
//    
//    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
//    
//    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh)];
//    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    
//    
//    if (self.view.frame.size.height>480) {
//        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 454)];
//        uv.contentSize=CGSizeMake(320, 455);
//    }else{
//        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 366)];
//        uv.contentSize=CGSizeMake(320, 367);
//    }
//    [view addSubview:uv];
//    
//    view.backgroundColor=[UIColor whiteColor];
//    
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
//    
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
        if (!cell2) {
            cell2 = [[cntlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.cname=@"Open POs";
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
             NSArray *firstSplit = [obj1.Key componentsSeparatedByString:@","];
             NSArray *firstSplit2 = [obj2.Key componentsSeparatedByString:@","];
            if (isup) {
                return [[firstSplit objectAtIndex:1] compare:[firstSplit2 objectAtIndex:1]];
            }else{
                return [[firstSplit2 objectAtIndex:1] compare:[firstSplit objectAtIndex:1]];
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
    [uVendorTable reloadData];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"Open POs";
//    int dw = self.uw.frame.size.width;
//    int dh = self.uw.frame.size.height;
//           uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dw, dh)];
//           uv.contentSize=CGSizeMake(dw, dh);
//    [self.uw addSubview:uv];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
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
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];
    
    tmcia=[userInfo getCiaId];
    [self getCiaList];
}

-(void)dorefresh{
    [self getCiaList];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2) {
        [self dorefresh];
    }
}


-(void)getCiaList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetVendorPOSelectCia:self action:@selector(xGetVendorPOSelectCiaHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] idvendor:_idvendor EquipmentType:@"3"];
        
        
    }
    
}

- (void) xGetVendorPOSelectCiaHandler: (id) value {
    
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
    result = [(wcfArrayOfKeyValueItem*)value toMutableArray];
   
    if (result.count>0) {
        if (!uVendorTable) {
            
            
            int dh =([result count]+1)*44;
            if (dh>self.uw.frame.size.height) {
                dh =self.uw.frame.size.height;
            }
            
            uVendorTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, dh)];
            
         uVendorTable.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            uVendorTable.delegate=self;
//            uVendorTable.layer.cornerRadius = 8;
//            uVendorTable.layer.borderWidth = 1.2;
//            uVendorTable.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            uVendorTable.dataSource=self;
            [self.uw addSubview:uVendorTable];
        }else{
            [uVendorTable reloadData];
            [ntabbar setSelectedItem:nil];
        }
    }else{
        [uVendorTable removeFromSuperview];
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 21)];
        lbl.text=@"Purchase Order not Found.";
        lbl.textColor=[UIColor redColor];
        [self.uw addSubview:lbl];
        [ntabbar setSelectedItem:nil];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return ([result count]); // or self.items.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    cntlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
        cell = [[cntlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
    
    NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        cell.Cname=[firstSplit objectAtIndex:1];
        cell.cnt=kv.Value;
//    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
    
    
    
    //    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
//    [cell .imageView setImage:nil];
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag==1) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
    
    NSString* result22 = (NSString*)value;
    if ([result22 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [uVendorTable indexPathForSelectedRow];
        wcfKeyValueItem *kv =[result objectAtIndex:indexPath.row];
        //        NSLog(@"%@",vitem);
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        
        
        projectpo *cc =[[projectpo alloc]init];
        cc.tbindex=self.tbindex;
        cc.menulist=self.menulist;
        cc.detailstrarr=self.detailstrarr;
        tmcia=[userInfo getCiaId];
        
        cc.idmaster=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
        [userInfo initCiaInfo:[ [firstSplit objectAtIndex:0] intValue] andNm: [firstSplit objectAtIndex:1]];
        cc.idvendor=self.idvendor;
        cc.idproject=@"";
        cc.isfromdevelopment=-1;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:NO];
        
        //        developmentVendorInfo *pf =[developmentVendorInfo alloc];
        //        pf.managedObjectContext=self.managedObjectContext;
        //        pf.idproject=self.idproject;
        //        //        pf.title=vitem.Name;
        //        pf.title=@"Vendor Profile";
        //        pf.idvendor=vitem.Idnumber;
        //
        //        [self.navigationController pushViewController:pf animated:YES];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super orientationChanged];
    [userInfo initCiaInfo:tmcia andNm: @""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
