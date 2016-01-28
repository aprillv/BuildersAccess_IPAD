//
//  developmentVendorLs.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/27/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "developmentVendorLs.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "Reachability.h"
#import "developmentVendorInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "vendorlistCell.h"
#import "vendorlistfirstCell.h"

@interface developmentVendorLs ()<vendorlistfirstCellDelegate>

@end

@implementation developmentVendorLs{
//    UITabBar *ntabbar;
//    UIScrollView *uv;
    UITableView *uVendorTable;
    NSMutableArray* result ;
    UIButton *btnNext;
    vendorlistfirstCell *cell2;
}

@synthesize  idproject, searchkey, idmaster;

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
            cell2 = [[vendorlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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
    
    [result sortUsingComparator:^NSComparisonResult(wcfVendor* obj1, wcfVendor* obj2) {
        
        if (isup) {
            return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
        }else{
            return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
        }
        
        
    }];
    [uVendorTable reloadData];
    
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)dorefresh{
      [self getVenodrInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([idproject isEqualToString:@"-1"]) {
        self.title=searchkey;
    }else{
        self.title=@"Preferred Vendors";
    }
    
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
    if ([idproject isEqualToString:@"-1"]) {
//        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
//        [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
//        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    }else{
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
  
        BOOL aaa =NO;
        for (UIViewController *uc in self.navigationController.viewControllers) {
            if ([uc isKindOfClass:[development class]]) {
                aaa=YES;
                break;
            }
        }
        if (aaa) {
             [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        }else{
              [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        }

    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack: nil];
    }else if(item.tag == 2) {
        [self dorefresh];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [self orientationChanged];
    [self getVenodrInfo];
}
-(void)getVenodrInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if ([idproject isEqualToString:@"-1"]) {
            [service xSearchVendorList:self action:@selector(xGetDevelopmentVendorListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] keyword:searchkey EquipmentType:@"5"];
        }else{
        [service xGetDevelopmentVendorList:self action:@selector(xGetDevelopmentVendorListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject EquipmentType:@"5"];
        }
        
    }

}

- (void) xGetDevelopmentVendorListHandler: (id) value {
    
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
    result = [(wcfArrayOfVendor*)value toMutableArray];
    if (result.count>0) {
        if([value isKindOfClass:[wcfArrayOfVendor class]]){
            if (!uVendorTable) {
                int dh =([result count]+1)*44;
                if (dh>self.uw.frame.size.height) {
                    dh =self.uw.frame.size.height;
                }
                uVendorTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, dh)];
                uVendorTable.delegate=self;
                uVendorTable.dataSource=self;
                uVendorTable.tag=2;
//                uVendorTable.layer.cornerRadius = 10;
//                uVendorTable.layer.borderWidth = 1.2;
//                uVendorTable.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
                uVendorTable.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                [self.uw addSubview:uVendorTable];
            }else{
                [uVendorTable reloadData];
                [ntabbar setSelectedItem:nil];
            }
            
            
        }
    }else{
        [uVendorTable removeFromSuperview];
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 21)];
        lbl.text=@"Vendors not Found.";
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
    
    wcfVendor *kv =[result objectAtIndex:(indexPath.row)];
//        NSLog(@"%@", kv);
    static NSString *CellIdentifier = @"Cell";
    
    vendorlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
        cell = [[vendorlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
//    cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@", kv.Idnumber, kv.Name];
          cell.Cname=kv.Name;
        cell.contact=kv.Contact;
    //    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
//    [cell .imageView setImage:nil];
        return cell;}
    
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
        wcfVendor *vitem =[result objectAtIndex:indexPath.row];
        developmentVendorInfo *pf =[developmentVendorInfo alloc];
        if (vitem.Idcia) {
            [userInfo initCiaInfo:[vitem.Idcia intValue] andNm:@""];
        }
        pf.idmaster=self.idmaster;
        pf.managedObjectContext=self.managedObjectContext;
        pf.idproject=self.idproject;
        pf.atitle=vitem.Name;
        pf.idvendor=vitem.Idnumber;
        pf.menulist=self.menulist;
        pf.detailstrarr=self.detailstrarr;
        pf.tbindex=self.tbindex;
        
        [self.navigationController pushViewController:pf animated:NO];
        
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
