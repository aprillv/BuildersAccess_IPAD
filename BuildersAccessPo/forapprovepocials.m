//
//  forapprovepocials.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprovepocials.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "forapprovepols.h"
#import "requestedvpols.h"
#import "cntlistCell.h"
#import "cntlistfirstCell.h"

@interface forapprovepocials ()<cntlistfirstCellDelegate>

@end

@implementation forapprovepocials{
 cntlistfirstCell *cell2;
}

@synthesize mxtype, result,result1,masterciaid, atitle;

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
            cell2 = [[cntlistfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.cname=@"PO For Approve";
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
            if (isup) {
                return [[[obj1.Key componentsSeparatedByString:@","] objectAtIndex:1] compare:[[obj2.Key componentsSeparatedByString:@","] objectAtIndex:1]];
            }else{
                return [[[obj2.Key componentsSeparatedByString:@","] objectAtIndex:1] compare:[[obj1.Key componentsSeparatedByString:@","] objectAtIndex:1]];
            }
        }else{
            if (isup) {
                return [obj1.Value intValue] >[obj2.Value intValue];
            }else{
             return [obj1.Value intValue] <[obj2.Value intValue];
            }
        }
        
    }
     ];
    [ciatbview reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:atitle];
    
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
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshPrject:) ];
//    
//    [[ntabbar.items objectAtIndex:0] setTag: 1];
   
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self refreshPrject: nil];
    }
}



-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchtxt setText:@""];
    [ciatbview removeFromSuperview];
    [self getPols];
}

-(IBAction)refreshPrject:(id)sender{
    [searchtxt setText:@""];
    [ciatbview removeFromSuperview];
    [self getPols];
}

-(void)getPols{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (mxtype==4) {
            [service xGetMenuRequestedPOForApprove:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"5"];
        }else   if (mxtype==5) {
                [service xGetMenuRequestedPOHold:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"5"];
        }else{
            
        
        [service xGetMenuPOForApprove:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid xtype:[[NSNumber numberWithInt:mxtype] stringValue] EquipmentType:@"5"];
        }
    }
}

- (void) xGetMenuPOForApproveHandler: (id) value {
    
	
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
    
    result=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    
    result1=result;
//    uv.backgroundColor=[UIColor whiteColor];
    
    if (ciatbview ==nil) {
        int dwidth =self.uw.frame.size.width;
        int dheight =self.uw.frame.size.height;
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
        
        int dh =([result count]+1)*44;
        if (dh<self.uw.frame.size.height-44) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dh)];
        }else{
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, dwidth, dheight-44)];
        }
        
//        ciatbview.layer.borderWidth = 1.2;
//        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//        uv.contentSize=CGSizeMake(dwidth,dheight-43);
//        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=2;
//        uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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
//    if (cell == nil)
//    {
        cell = [[cntlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        if (mxtype==4 || mxtype==5) {
            
            cell.Cname=kv.Value;
//            cell.textLabel.text=kv.Value;
            
        }else{
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            
//            cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
            cell.Cname= [firstSplit objectAtIndex:1];
            cell.cnt=kv.Value;
        }
//        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
//        [cell .imageView setImage:nil];
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


-(void)orientationChanged{
    [super orientationChanged];
     [ciatbview reloadData];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
     [ciatbview reloadData];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43)];
    [ciatbview reloadData];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
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
        
        [searchtxt resignFirstResponder];
        
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        if (mxtype==4 || mxtype==5 ) {
            NSArray *firstSplit = [kv.Value componentsSeparatedByString:@"("];
            [userInfo initCiaInfo:[kv.Key integerValue] andNm:[firstSplit objectAtIndex:0]];
            requestedvpols *LoginS=[requestedvpols alloc];
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.menulist=self.menulist;
            LoginS.detailstrarr=self.detailstrarr;
            LoginS.tbindex=self.tbindex;
            LoginS.xtype=mxtype+2;
            LoginS.title=self.title;
            [self.navigationController pushViewController:LoginS animated:NO];
        }else{
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        forapprovepols *LoginS=[forapprovepols alloc];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.mxtype=self.mxtype;
        LoginS.atitle=self.atitle;
        [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
        [self.navigationController pushViewController:LoginS animated:NO];
        }
    }
    
    
}




- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    str=[NSString stringWithFormat:@"Key like [c]'*%@*' or Value like [c]'%@'", searchtxt.text, searchtxt.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
