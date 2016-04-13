//
//  assignVendor.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-20.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "assignVendor.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "poemail.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "project.h"
#import "wcfArrayOfVendor.h"
#import "CustomKeyboard.h"

@interface assignVendor ()<CustomKeyboardDelegate, UISearchBarDelegate>{
    UIScrollView *uv;
    UISearchBar *searchBar;
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    NSMutableArray *result1;
    UIButton *btnNext;
}


@end

int pageNo;
int currentPageNo;

@implementation assignVendor

@synthesize xpocode, xpoid, xidcostcode, xidproject, rtnlist, searchField, xshipto, xdelivery, fromforapprove;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)dorefresh:(id)sender{
    currentPageNo=1;
    rtnlist=nil;
    [ciatbview removeFromSuperview];
    [self getVenderls:currentPageNo];
}
-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if (fromforapprove==2) {
            if ([temp isKindOfClass:[development class]]) {
                [self.navigationController popToViewController:temp animated:NO];
            }
        }else{
            if ([temp isKindOfClass:[project class]]) {
                [self.navigationController popToViewController:temp animated:NO];
            }
        }
        
    }
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
    str=[NSString stringWithFormat:@"Contact like [c]'*%@*' or Name like [c]'*%@*' or Idnumber like '*%@*'", searchBar.text, searchBar.text, searchBar.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result1=[[rtnlist filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Select Vendor"];
    
    
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
    
  
    if (fromforapprove==3) {
          [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    }else if (fromforapprove==2){
          [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    }
   
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
    
    

    
    searchField.text=@"";
    currentPageNo=1;
    [self getVenderls:currentPageNo];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1: nil];
    }else if(item.tag == 2){
        [self dorefresh: nil];
    }
}


-(void)getVenderls: (int)xpageNo{

    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        currentPageNo=xpageNo;
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetVendors:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidcostcode:xidcostcode projectid:xidproject currentPage:xpageNo EquipmentType:@"5"];
    }
    
}

- (void) xGetVendorsHandler: (id) value {
   
    
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
    NSMutableArray* result = (NSMutableArray*)value;
    
    UIScrollView *sv =uv;
    
    
   
    
	if([result isKindOfClass:[wcfArrayOfVendor class]]){
        wcfVendor *vitme=[result objectAtIndex:0];
        
        if (currentPageNo==1) {
            pageNo=[vitme.TotalPage intValue];
        }
        [result removeObjectAtIndex:0];
        if (rtnlist==nil) {
            rtnlist=[[NSMutableArray alloc]init];
        }
        
        [rtnlist addObjectsFromArray:[(wcfArrayOfVendor *)result toMutableArray]];
        
        

//        for(wcfVendor *vitme in result){
//            [rtnlist addObject:vitme];
//        }
        
        if (pageNo==currentPageNo) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if ([rtnlist count]>0) {
                result1=rtnlist;
                if (ciatbview ==nil) {
                    int dwidth =self.uw.frame.size.width;
                    int dheight =self.uw.frame.size.height;
                    
                    
                    int dh =([rtnlist count])*44;
                    if (dh>dheight-64) {
                        dh=dheight-64;
                    }
                    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, dh)];
                    
//                    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, dheight-64)];
                    uv.contentSize=CGSizeMake(dwidth,dheight-43);
                    ciatbview.layer.cornerRadius = 10;
                    ciatbview.tag=2;
                    ciatbview.layer.borderWidth = 1.2;
                    ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
                    [uv addSubview:ciatbview];
                    ciatbview.delegate = self;
                    ciatbview.dataSource = self;
                    [ntabbar setSelectedItem:nil];
                    
                    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                    ciatbview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                    
                }else{
                    [uv addSubview: ciatbview];
                    [ciatbview reloadData];
                    [ntabbar setSelectedItem:nil];
                }

                
            }else{
                UILabel *lbl;
                
                lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 300, 35)];
                lbl.tag=3;
                lbl.text=@" Vendor not found.";
                lbl.textColor=[UIColor redColor];
                [sv addSubview:lbl];
                [ntabbar setSelectedItem:nil];
            }

        }else{
            [self getVenderls:(currentPageNo +1)];
        }
        
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


- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return ([result1 count]); // or self.items.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    wcfVendor *kv =[result1 objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text=kv.Name;
    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
    [cell .imageView setImage:nil];
    return cell;
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
         NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        wcfVendor *vitem =[rtnlist objectAtIndex:indexPath.row];
        poemail *bug=[poemail alloc];
        bug.menulist=self.menulist;
        bug.detailstrarr=self.detailstrarr;
        bug.tbindex=self.tbindex;
        bug.managedObjectContext=self.managedObjectContext;
        bug.idpo1=self.xpoid;
        bug.xmcode=self.xpocode;
        bug.idvendor=vitem.Idnumber;
        bug.xtype=0;
        bug.isfromassign=YES;
        [self.navigationController pushViewController:bug animated:NO];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self orientationChanged];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
