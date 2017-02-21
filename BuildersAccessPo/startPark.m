//
//  startPark.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-27.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "startPark.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "wcfArrayOfStartPackItem.h"
#import "startpackCell.h"
#import "startpackfirstCell.h"

@interface startPark ()<startpackfirstCellDelegate>{
    UITableView *ciatbview;
    UIButton *btnNext;
    startpackfirstCell *cell2;
}


@end

@implementation startPark
@synthesize idproject, rtnlist;

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
            cell2 = [[startpackfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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
    
    [rtnlist sortUsingComparator:^NSComparisonResult(wcfStartPackItem* obj1, wcfStartPackItem* obj2) {
        
        
        
        if (isup) {
            return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
        }else{
            return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
        }
    }
     ];
    [ciatbview reloadData];
    
}

-(IBAction)goProject:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle: @"Start Pack"];
    
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
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goProject:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width;
    dheight=cs.height;
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
//    uv.backgroundColor=[UIColor whiteColor];
    [self getScheduleLog];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goProject: nil];
    }else if(item.tag == 2){
        [self dorefresh: nil];
    }
}


-(void)orientationChanged{
    [super orientationChanged];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)getScheduleLog{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetStartPackList:self action:@selector(xGetStartPackListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: idproject EquipmentType: @"3"];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetStartPackList:self action:@selector(xGetStartPackListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: idproject EquipmentType: @"3"];
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
    
//    UIScrollView *sv=uv;
    wcfArrayOfStartPackItem* result = (wcfArrayOfStartPackItem*)value;
    if ([result isKindOfClass:[wcfArrayOfStartPackItem class]]) {
        [result removeObjectAtIndex:0]; 
        rtnlist=[result toMutableArray] ;
        if([rtnlist count] > 0){
            if (ciatbview ==nil) {
                int dwidth;
                int dheight;
                CGSize cs = self.uw.frame.size;
                dwidth=cs.width;
                dheight=cs.height;
//                int dwidth =self.uw.frame.size.width;
//                int dheight =self.uw.frame.size.height;
                int dh =([rtnlist count])*44;
                if (dh>dheight) {
                    dh=dheight;
                }
                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dh)];
                
//                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
//                uv.contentSize=CGSizeMake(dwidth,dheight+1);
//                ciatbview.layer.cornerRadius = 10;
                ciatbview.tag=2;
//                ciatbview.layer.borderWidth = 1.2;
//                ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//                uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                [self.uw addSubview:ciatbview];
                ciatbview.delegate = self;
                ciatbview.dataSource = self;
            }else{
                [self.uw addSubview: ciatbview];
                [ciatbview reloadData];
            }

            
        }else{
           UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 315, 25)];
            lbl.text=[self.title stringByAppendingString:@" not found."];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.textColor=[UIColor redColor];
            [self.uw addSubview:lbl];
        }
        
    }
	
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
         [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return ([self.rtnlist count]); // or self.items.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     wcfStartPackItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    startpackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
        cell = [[startpackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
   cell.cname=kv.StartPack;
    cell.cvalue=kv.MValue;
//    [cell .imageView setImage:nil];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
