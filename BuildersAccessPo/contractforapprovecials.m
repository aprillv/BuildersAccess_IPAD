//
//  contractforapprovecials.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "contractforapprovecials.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "contractforapprove.h"
#import "cntlistfirstCell.h"
#import "cntlistCell.h"

@interface contractforapprovecials ()<cntlistfirstCellDelegate>

@end

@implementation contractforapprovecials{
    cntlistfirstCell *cell2;
}

@synthesize mastercia, result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)goback1:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        
        if (!cell2) {
            cell2 = [[cntlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.cname=@"Contract For Approve";
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
    [ciatbview reloadData];
    
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
            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler2:) version:version];
        }
    }
}
- (void) xisupdate_iphoneHandler2: (id) value {
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
        [searchBar resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfKeyValueItem *kv =[result objectAtIndex:indexPath.row];
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        
        [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
        contractforapprove *pl =[[contractforapprove alloc]init];
        pl.menulist=self.menulist;
        pl.detailstrarr=self.detailstrarr;
        pl.tbindex=self.tbindex;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:NO];
        
    }
    
    
}



-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [ciatbview removeFromSuperview];
    [self orientationChanged];
    [self getcialistofcoforapprove];
   
    
}

-(void)orientationChanged{
    [super orientationChanged];
    [ciatbview reloadData];
}
-(IBAction)refreshPrject:(id)sender{
    
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
    
    NSString* result5 = (NSString*)value;
    if ([result5 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [ciatbview removeFromSuperview];
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
        [service xGetMenuContractForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"5"];
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
    
    result=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    
        result1=result;
//        uv.backgroundColor=[UIColor whiteColor];
    
        if (ciatbview ==nil) {
            
            
            int dwidth =self.uw.frame.size.width;
            int dheight =self.uw.frame.size.height;
            int dh =([result count]+1)*44;
            if (dh>dheight-44) {
                dh=dheight-44;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
            
//            uv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            ciatbview.layer.cornerRadius = 10;
//            ciatbview.layer.borderWidth = 1.2;
//            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            ciatbview.tag=2;
            [self.uw addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
        }else{
            [self.uw addSubview: ciatbview];
            [ciatbview reloadData];
        }

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
        static NSString *CellIdentifier = @"Cell";
        
        cntlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
            cell = [[cntlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        }
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        cell.Cname= [firstSplit objectAtIndex:1];
        cell.cnt=kv.Value;
//        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
//        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
//        [cell .imageView setImage:nil];
        return cell;
    }
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self refreshPrject: nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Contract ISP"];
	// Do any additional setup after loading the view.
    int dwidth=self.uw.frame.size.width;
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, dwidth, 44)];
    [self.uw addSubview: searchBar];
    searchBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    searchBar.delegate=self;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
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
    
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//    [self.uw addSubview:uv];
//    
//    uv.contentSize=CGSizeMake(dwidth,dheight+1);
    
    if (result!=nil) {
        result1=result;
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, uv.frame.size.height-20)];
//        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        ciatbview.layer.cornerRadius = 10;
//       
//        ciatbview.tag=2;
        int dwidth =self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
        int dh =([result count]+1)*44;
        if (dh>dheight-44) {
            dh=dheight-44;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dh)];
        
//        uv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        ciatbview.tag=2;
        [self.uw addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
    }else{
        [self getcialistofcoforapprove];
    }
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
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
    str=[NSString stringWithFormat:@"Key like [c]'*%@*' or Value like '%@'", searchBar.text, searchBar.text];
    
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
