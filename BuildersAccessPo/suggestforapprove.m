//
//  suggestforapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "suggestforapprove.h"
#import "wcfService.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "calendarforapproveupd.h"
#import "Reachability.h"
#import "approvesuggest.h"
#import "sugestlistCell.h"
#import "suggestfirstCell.h"

@interface suggestforapprove ()<suggestfirstCellDelegate>

@end

@implementation suggestforapprove{
    suggestfirstCell *cell2;
}
@synthesize rtnlist, tbview, rtnlist1, masterciaid;


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
    
    [self setTitle:@"Suggested Price"];
    int dwidth=self.uw.frame.size.width;
//    int dheight =self.uw.frame.size.height;
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
    searchBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
        
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
   
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self dorefresh: nil];
    }
}


-(IBAction)goback1:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
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


- (void)doneClicked {
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar2 textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Nproject like [c]'*%@*' or Suggested like [c]'%@*'", searchBar.text, searchBar.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar2{
    [searchBar resignFirstResponder];
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
        
        [service xGetSuggestedPricelistForApprove:self action:@selector(xGetSuggestedPricelistForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"5"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [self getCalendarList];
}

- (void) xGetSuggestedPricelistForApproveHandler: (id)value {
    
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
    rtnlist=[(wcfArrayOfSuggestedPriceListItem*)value toMutableArray];
    rtnlist1=rtnlist ;
    
//    NSLog(@"%@", [rtnlist objectAtIndex:0]);
    
   
    
    if (tbview !=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
        [searchBar setText:@""];
    }else{
        int dwidth =self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
//        sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
//        sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self.uw addSubview:sv];
//        sv.backgroundColor=[UIColor whiteColor];
//        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
        int dh =([rtnlist count]+1)*44;
        if (dh>dheight-44) {
            dh=dheight-44;
        }
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
        
//        sv.contentSize=CGSizeMake(dwidth,dheight-43);
//        tbview.layer.cornerRadius = 10;
        tbview.tag=2;
//        tbview.layer.borderWidth = 1.2;
//        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//        tbview.rowHeight=67.0f;
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
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
        return ([self.rtnlist count]); // or self.items.count;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[suggestfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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
-(void)doaClicked:(NSString *)str :(BOOL)isup{
    
 
    
    [rtnlist sortUsingComparator:^NSComparisonResult(wcfCOListItem* obj1, wcfCOListItem* obj2) {
        if ([str isEqualToString:@"Suggested"] || [str isEqualToString:@"FormulaPrice"]) {
                        double t1 =[[[[obj1 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        double t2 =[[[[obj2 valueForKey:str] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
//            double t1 =[[[obj1 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
//            double t2 =[[[obj2 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
            if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
            }
        }else if ([str isEqualToString:@"SQFT"]) {
            double t1=[[[obj1 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
           double t2=[[[obj2 valueForKey:str] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        if (isup) {
                return t1>t2;
            }else{
                return t1<t2;
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



-(void)orientationChanged{
    [super orientationChanged];
//    [sv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    [tbview reloadData];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
    [tbview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
       return  [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//        if (indexPath.row==0) {
//            static NSString *CellIdentifier = @"Cell1";
//            
//            
//            suggestfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil)
//            {
//                cell = [[suggestfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                cell.delegate=self;
//            }
//           
//            return cell;
//        }else{
            static NSString *CellIdentifier = @"Cell";
            
            sugestlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //               if (cell == nil)
            //                {
            cell = [[sugestlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //                }
            
            wcfSuggestedPriceListItem *kv =[rtnlist objectAtIndex:indexPath.row];
            cell.idproject=kv.Idproject;
            cell.project=kv.Nproject;
            cell.sqft=kv.SQFT;
            cell.sugestprice=kv.Suggested;
            cell.formula=kv.FormulaPrice;
            return cell;

//        }

    }
        
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
        
        approvesuggest *pd =[[approvesuggest alloc]init];
        pd.managedObjectContext=self.managedObjectContext;
        pd.menulist=self.menulist;
        pd.detailstrarr=self.detailstrarr;
        pd.tbindex=self.tbindex;
        wcfSuggestedPriceListItem *kv =[rtnlist objectAtIndex:indexPath.row];
         pd.xidproject=kv.Idproject;
        pd.xidcia=kv.Idcia;
        pd.xnproject=kv.Nproject;
        pd.idnumber=kv.Idnumber;
        [self.navigationController pushViewController:pd animated:NO];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
