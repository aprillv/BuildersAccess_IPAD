//
//  projectcols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectcols.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "project.h"
#import "coforapproveupd.h"
#import "wcfArrayOfStartPackItem.h"
#import "CustomKeyboard.h"
#import "colistcell.h"
#import "colistfirstCell.h"

@interface projectcols ()< UISearchBarDelegate, CustomKeyboardDelegate, colistfirstCellDelegate>{
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    NSMutableArray* result1;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    int currentpage;
    int pageNo;
    UIButton *btnNext;
}


@end

@implementation projectcols
@synthesize idproject, result, xtatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)gotoProject:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Change Order"];
    
 
    
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
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
      [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
        [self drawpage];
    // Do any additional setup after loading the view from its nib.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject:nil];
    }else if(item.tag == 2){
        [self dorefresh:nil];
    }
}


-(void)getPols {
Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetProjectCOList:self action:@selector(xGetProjectCOListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject EquipmentType:@"5"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self orientationChanged];
}
- (void) xGetProjectCOListHandler: (id) value {
    
	
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
    
    result =[(wcfArrayOfCOListItem*)value toMutableArray];
    [result removeObjectAtIndex:0];
    [self drawpage];
}

-(void)drawpage{
    result1=result;
    
    if (ciatbview ==nil) {
        
//        int dwidth =self.uw.frame.size.width;
//        int dheight =self.uw.frame.size.height;
//        
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dheight-44)];
        
        int dwidth =self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
        
        int dh =([result count]+1)*44;
        if (dh>dheight-44) {
            dh=dheight-44;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth, dh)];
        
        uv.contentSize=CGSizeMake(dwidth,dheight-43);
        uv.backgroundColor=[UIColor whiteColor];
//        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag = 2;
//        ciatbview.rowHeight=70;
//        ciatbview.layer.borderWidth = 1.2;
//        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview: ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        uv.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    }else{
        [uv addSubview: ciatbview];
        [ciatbview reloadData];
    }
    [ntabbar setSelectedItem:nil];
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
        [self getPols];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return ([self.result count]+1); // or self.items.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"Cell1";
            
            colistfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[colistfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }            cell.delegate=self;
            //            cell.Doc=@"Doc";
            //            cell.Nvendor=@"Vendor Name";
            //            cell.Shipto=@"Notes";
            //            cell.Status=@"Stauts";
            return cell;
            
        }else{
            static NSString *CellIdentifier = @"Cell";
            
            colistcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//               if (cell == nil)
//                {
            cell = [[colistcell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                }
            
            wcfCOListItem *kv =[result objectAtIndex:(indexPath.row-1)];
            cell.Number=kv.Doc;
            cell.sDate=kv.codate;
            cell.Project=kv.Nproject;
            cell.Sales=kv.Sales1;
            cell.Total=kv.Total;
            return cell;
        }
    
    }
}

-(void)doaClicked:(NSString *)str :(BOOL)isup{
   
   
    [result sortUsingComparator:^NSComparisonResult(wcfCOListItem* obj1, wcfCOListItem* obj2) {
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
    
    [ciatbview reloadData];
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
        
        wcfCOListItem *kv =[result objectAtIndex:(indexPath.row-1)];
        coforapproveupd *cpd =[coforapproveupd alloc];
        cpd.menulist=self.menulist;
        cpd.detailstrarr=self.detailstrarr;
        cpd.tbindex=self.tbindex;
        cpd.managedObjectContext=self.managedObjectContext;
        cpd.idnumber=kv.Idnumber;
        cpd.aattile=[NSString stringWithFormat:@"CO-%@", kv.Doc];
        cpd.idcia=kv.IDCia;
        cpd.isfromapprove=NO;
        [self.navigationController pushViewController:cpd animated:NO];
    }
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
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
    str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Status like [c]'*%@*' or Nproject like [c]'*%@*'", searchBar.text, searchBar.text, searchBar.text];
    
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

