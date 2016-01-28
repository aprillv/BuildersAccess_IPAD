//
//  coforapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "coforapprove.h"
#import "wcfService.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "coforapproveupd.h"
#import "Reachability.h"
#import "forapprove.h"
#import "colistfirstCell.h"
#import "colistcell.h"
@interface coforapprove ()<colistfirstCellDelegate>

@end

@implementation coforapprove{
colistfirstCell *cell2;
}
@synthesize rtnlist, rtnlist1, tbview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)doaClicked:(NSString *)str :(BOOL)isup{
    
    
    [rtnlist sortUsingComparator:^NSComparisonResult(wcfCOListItem* obj1, wcfCOListItem* obj2) {
        if ([str isEqualToString:@"Total"]) {
            double t1 =[[[[obj1 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            double t2 =[[[[obj2 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
            if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
            }
        }else if ([str isEqualToString:@"codate"]) {
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
    
    [tbview reloadData];
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitle:@"Change Order"];
    
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
    [self.uw addSubview: searchtxt];
    searchtxt.delegate=self;
    
//    UIScrollView *uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
//    uv.tag=1;
//    [self.uw addSubview:uv];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
     [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
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
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
[self getcoList];
    [self orientationChanged];
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
        [self getcoList];
    }
    
    
}


    - (void)doneClicked {
        [searchtxt resignFirstResponder];
    }
    
    -(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
        [searchtxt resignFirstResponder];
    }
    
    -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
        NSString *str;
        str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Nproject like [c]'*%@*' or codate like '%@*'", searchtxt.text, searchtxt.text, searchtxt.text];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
        rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
        [tbview reloadData];
    }
    
    
    -(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
        [searchtxt resignFirstResponder];
    }


-(void)getcoList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [service xGetCOListForApprove:self action:@selector(xGetCOListForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"5"];
    }


}

- (void) xGetCOListForApproveHandler: (id) value {
    
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
    rtnlist = [(wcfArrayOfCOListItem*)value toMutableArray];
    rtnlist1=rtnlist;
    
//    UIScrollView *sv =(UIScrollView *)[self.uw viewWithTag:1];
//    sv.backgroundColor=[UIColor whiteColor];
    
    if (tbview!=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
        [searchtxt setText:@""];
    }else{
        int dh =([rtnlist count]+1)*44;
        if (dh>self.uw.frame.size.height-44) {
            dh=self.uw.frame.size.height-44;
        }
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, dh)];
//         tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 100)];
//        sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-44);
//        tbview.layer.borderWidth = 1.2;
//        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//        tbview.layer.cornerRadius = 10;
        tbview.tag=2;
        tbview.delegate = self;
        tbview.dataSource = self;
//        tbview.rowHeight=66.0f;
        [self.uw addSubview:tbview];
//        sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[colistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            colistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                if (cell == nil)
//                {
//            cell = [[colistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//            cell.delegate=self;
//                }
//                    return cell;
//            
//        }else{
            static NSString *CellIdentifier = @"Cell";
            
            colistcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil)
//            {
                cell = [[colistcell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//            }
            
            wcfCOListItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
            cell.Number=kv.Doc;
            cell.sDate=kv.codate;
            cell.Project=kv.Nproject;
            cell.Sales=kv.Sales1;
            cell.Total=kv.Total;
            //    cell.textLabel.text =kv.Nproject;
            //    cell.detailTextLabel.numberOfLines=2;
            //    cell.detailTextLabel.text=[NSString stringWithFormat:@"Number: %@\nDate: %@", kv.Doc, kv.codate];
            //    [cell.detailTextLabel sizeToFit];
            //    [cell .imageView setImage:nil];
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
        NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        coforapproveupd *cpd =[[coforapproveupd alloc]init];
        cpd.managedObjectContext=self.managedObjectContext;
        wcfCOListItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
        cpd.idnumber=kv.Idnumber;
        cpd.menulist=self.menulist;
        cpd.detailstrarr=self.detailstrarr;
        cpd.tbindex=self.tbindex;
        cpd.isfromapprove=YES;
        cpd.aattile =[NSString stringWithFormat:@"CO-%@", kv.Doc];
       cpd.title=[NSString stringWithFormat:@"CO-%@", kv.Doc];
        cpd.idcia=kv.IDCia;
        [self.navigationController pushViewController:cpd animated:NO];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
