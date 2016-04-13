//
//  calendarforapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "calendarforapprove.h"
#import "wcfService.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "calendarforapproveupd.h"
#import "Reachability.h"
#import "calendarbuilderCell.h"
#import "calendarbuilderfirstCell.h"

@interface calendarforapprove ()<calendarbuilderfirstCellDelegate>

@end

@implementation calendarforapprove{
    calendarbuilderfirstCell *cell2;
}

@synthesize rtnlist, tbview, rtnlist1, mxtype, masterciaid;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doaClicked:(NSString *)str :(BOOL)isup{
    [rtnlist sortUsingComparator:^NSComparisonResult(wcfCalendarItem* obj1, wcfCalendarItem* obj2) {
        if ([str isEqualToString:@"Subject"]) {
            if (isup) {
                return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
            }else{
                return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
            }
            

        }else{
            
            NSString *t1=[obj1 valueForKey:str];
            NSString *t2 =[obj2 valueForKey:str];
            t1=[NSString stringWithFormat:@"%@%@",[t1 substringFromIndex:6], [t1 substringToIndex:5]];
            
            t2=[NSString stringWithFormat:@"%@%@",[t2 substringFromIndex:6], [t2 substringToIndex:5]];
            
            if (isup) {
                return [t1 compare:t2];
            }else{
                return [t2 compare:t1];;
            }
        }
        
    }];
    
    [tbview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (mxtype==1) {
        [self setTitle:@"Calendar Builder"];
    }else{
        [self setTitle:@"Calendar Buyer"];
    }
    
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
    
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
//    uv.backgroundColor=[UIColor whiteColor];
    

    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];

    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self dorefresh:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
     [self getCalendarList];
}

-(void)orientationChanged{
    [super orientationChanged];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    [tbview reloadData];
   
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)dorefresh:(id)sender{
    
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
        [self getCalendarList];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[calendarbuilderfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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

- (void)doneClicked {
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Subject like [c]'*%@*' or Original like [c]'%@*' or Reschedule like '%@*'", searchtxt.text, searchtxt.text, searchtxt.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}


-(void) getCalendarList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        if (mxtype!=1) {
            [service xGetCalendarBuyerForApprove:self action:@selector(xGetCalendarForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"5"];
        }else{
            [service xGetCalendarBuilderForApprove:self action:@selector(xGetCalendarForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"5"];
        }

    }
        
    
}

- (void) xGetCalendarForApproveHandler: (id)value {
    
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
    
	// Do something with the NSMutableArray* result
    rtnlist=[(wcfArrayOfCalendarItem*)value toMutableArray];
    rtnlist1=rtnlist ;
   
    
    if (tbview !=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
        [searchtxt setText:@""];
    }else{
        
        int dwidth = self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
//        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
        int dh =([rtnlist count]+1)*44;
        if (dh>dheight-44) {
            dh=dheight-44;
        }
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
        
//        uv.contentSize=CGSizeMake(320.0,dheight-43);
//        tbview.layer.cornerRadius = 10;
//        tbview.rowHeight=66.0f;
//        tbview.layer.borderWidth = 1.2;
//        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        tbview.tag=2;
        tbview.delegate = self;
        tbview.dataSource = self;
        [self.uw addSubview:tbview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [self.rtnlist count]; // or self.items.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1){
        return [super tableView:tableView cellForRowAtIndexPath:(indexPath)];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            calendarbuilderfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil){
//                cell = [[calendarbuilderfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                 cell.delegate=self;
//            }
//            
//           
//            return cell;
//        }else{
            static NSString *CellIdentifier = @"Cell";
            
            //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //    if (cell == nil)
            //    {
            //        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //    }
            //
            //    wcfCalendarItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
            //
            //    cell.textLabel.text = kv.Subject;
            //    cell.detailTextLabel.numberOfLines=2;
            //    cell.detailTextLabel.text=[NSString stringWithFormat:@"Original: %@\nReschedule: %@", kv.Original, kv.Reschedule];
            //    [cell.detailTextLabel sizeToFit];
            //    [cell .imageView setImage:nil];
            //    return cell;
            
            calendarbuilderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil){
                cell = [[calendarbuilderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//            }
            
            wcfCalendarItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
            cell.Requested=kv.Requested;
            cell.Reschedule=kv.Reschedule;
            cell.Original=kv.Original;
            cell.Subject=kv.Subject;
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
        
        calendarforapproveupd *pd =[calendarforapproveupd alloc];
        pd.menulist=self.menulist;
        pd.detailstrarr=self.detailstrarr;
        pd.tbindex=self.tbindex;
        pd.managedObjectContext=self.managedObjectContext;
        pd.xmtype=mxtype;
        wcfCalendarItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
        pd.idnumber=kv.IDNumber;
        [self.navigationController pushViewController:pd animated:NO];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
