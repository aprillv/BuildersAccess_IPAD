//
//  projectls.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-11.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "projectls.h"
#import "wcfService.h"
#import "wcfArrayOfKeyValueItem.h"
#import "wcfKeyValueItem.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_project.h"
#import "project.h"
#import "development.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "MBProgressHUD.h"
#import "projectCell.h"
#import "firstcell.h"
#import "developmentCell.h"
#import "dfirstCell.h"

@interface projectls ()<MBProgressHUDDelegate, firstcellDelegate,dfirstcellDelegate>
@end


@implementation projectls{
    int pageNo;
    int currentPage;
    int xatype;
    MBProgressHUD *HUD;
    NSMutableArray *rtnlist;
    NSMutableArray *rtnlist1;
    firstcell *cell2;
    dfirstCell *cell3;
}

@synthesize  islocked, tbview, atitle, isfrommainmenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    cell2=nil;
    cell3=nil;
    [self orientationChanged];
    [self getPojectls];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage=1;
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
    
    if ([atitle isEqualToString:@"Development"]) {
        xatype=1;
    }else if([atitle isEqualToString:@"Active Units"]){
        xatype=2;
    }else if([atitle isEqualToString:@"Not Started"]){
        xatype=3;
    }else{
        xatype=4;
    }
    [self setTitle:atitle];
    searchtxt= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    searchtxt.delegate=self;
    [self.uw addSubview: searchtxt];
    searchtxt.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    
    if (isfrommainmenu) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
        //    UITabBarItem *t = [ntabbar.items objectAtIndex:13];
        //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
        //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
        
        [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    }
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh1.png"] ];
     [[ntabbar.items objectAtIndex:13]setTitle:@"Sync" ];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]]; 

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self refreshPrject:nil];
    }
}


-(void)orientationChanged{
    [super orientationChanged];
//    int dwidth =self.uw.frame.size.width;
//    int dheight=self.uw.frame.size.height;
//    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
    [tbview reloadData];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
    [tbview reloadData];
}

-(void)doneClicked{
    [searchtxt resignFirstResponder];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (xatype==1) {
            if (!cell3) {
                cell3 = [[dfirstCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
                cell3.accessoryType = UITableViewCellAccessoryNone;
                cell3.selectionStyle = UITableViewCellSelectionStyleNone;
                cell3.delegate=self;
            }
            return cell3;
        }else{
            if (!cell2) {
                cell2 = [[firstcell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
                cell2.accessoryType = UITableViewCellAccessoryNone;
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                cell2.delegate=self;
            }
            return cell2;
        }
        
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

- (void)getPojectls
{
    cl_project *mp=[[cl_project alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    
    switch (xatype) {
        case 1:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
            break;
        case 2:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
            break;
        case 3:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0'", [userInfo getCiaId]];
            break;

        default:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
            break;
    }
    
   rtnlist = [mp getProjectList:str];
    rtnlist1=rtnlist;
//    
//    UIScrollView *sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
//    [self.uw addSubview:sv];
    UILabel *lbl =[[UILabel alloc]init];
    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
//    lbl.textColor=[UIColor whiteColor];
     lbl.textColor=[UIColor darkGrayColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.tag=14;
    lbl.numberOfLines=2;
    [lbl sizeToFit];
    CGRect rect= lbl.frame;
    rect.origin.x=(self.uw.frame.size.width-rect.size.width)/2;
    rect.origin.y=12;
    rect.size.height=40;
    lbl.frame=rect;
//    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
    lbl.font=[UIFont systemFontOfSize:10.0];
    lbl.backgroundColor=[UIColor clearColor];
    [ntabbar addSubview:lbl];
    if (!tbview) {
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
        int dh =([rtnlist count]+1)*44;
        if (dh<self.uw.frame.size.height-44) {
            tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, dh)];
        }else{
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, self.uw.frame.size.height-44)];
        }
        //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-43);
        
        //    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        //    tbview.layer.borderWidth = 1.2;
        //    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        //   tbview.layer.cornerRadius = 10;
        
        tbview.delegate = self;
        tbview.dataSource = self;
         [self.uw addSubview:tbview];
    }else{
        [tbview reloadData];
    }
   
   
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
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler1:) version:version];
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:[NSString stringWithFormat: @"We will sync all %@ with your device, this will take some time, Are you sure you want to continue?", atitle]
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
    }
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView .tag==1){
        //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                [self refreshProjectList:1];
            }
                break;
        }
    }
}


-(void)refreshProjectList:(int)xpageNo {
    
  
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:[NSString stringWithFormat:@"Synchronizing %@...",atitle ] delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=[NSString stringWithFormat:@"Synchronizing %@...  ",atitle ];
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        islocked=1;
    }else{
//        alertViewWithProgressbar.progress= (currentPage*100/pageNo);
         HUD.progress= (currentPage*1.0/pageNo);
        
    }
    currentPage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
        [service xSearchProject:self action:@selector(xSearchProjectSyncHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]xtype:xatype currentPage: xpageNo EquipmentType: @"3"];
    }
}

- (void) xSearchProjectSyncHandler: (id) value {
    
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
   
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
  
    
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
       
        
        if ([result count]==0) {
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            HUD.progress = 1;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            
            [ntabbar setSelectedItem:nil];
            NSString *str;
            switch (xatype) {
                case 1:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                    break;
                case 2:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                    break;
                case 3:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0'", [userInfo getCiaId]];
                    break;
                    
                default:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                    break;
            }
            UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
            lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
            
            if (self.islocked==2) {
                if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                    
                    [self.navigationItem setHidesBackButton:NO];
                    
                    [self enterPasscode:nil];
                }else{
                    rtnlist=[mp getProjectList:str];
                    rtnlist1=rtnlist;
                    [tbview reloadData];
                }
                
            }else{
                rtnlist=[mp getProjectList:str];
                 rtnlist1=rtnlist;
                [tbview reloadData];
            }
        }else{
            wcfProjectListItem *kv;
   
            
            
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageNo=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            NSString *syn =kv.IDNumber;
            [result removeObjectAtIndex:0];
            
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            
            if (currentPage==1) {
                [mp deletaAll:xatype];
            }
            [mp addToProject:result andscheleyn:syn];
            
            if (currentPage < pageNo) {
                
                currentPage=currentPage+1;
                [self refreshProjectList:currentPage];
            }else{
                HUD.progress = 1;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [HUD hide];
                
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                
                [ntabbar setSelectedItem:nil];
                NSString *str;
                switch (xatype) {
                    case 1:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                        break;
                    case 2:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                        break;
                    case 3:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0'", [userInfo getCiaId]];
                        break;
                        
                    default:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                        break;
                }
                UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
                lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
                
                if (self.islocked==2) {
                    if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                        
                        [self.navigationItem setHidesBackButton:NO];
                        
                        [self enterPasscode:nil];
                    }else{
                        rtnlist=[mp getProjectList:str];
                         rtnlist1=rtnlist;
                        [tbview reloadData];
                    }
                    
                }else{
                    rtnlist=[mp getProjectList:str];
                     rtnlist1=rtnlist;
                    [tbview reloadData];
                }
                
                
            }
        }
        
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

//-(NSString *)getSearchCondition{
//    NSString *str =[NSString stringWithFormat:@"((idnumber like [c]'%@*') or (planname like [c]'*%@*') or (name like [c]'*%@*')) and (idcia = %d)", searchtxt.text, searchtxt.text, searchtxt.text, [userInfo getCiaId]] ;
//    
//    switch (xatype) {
//        case 1:
//            str=[str stringByAppendingString :@" and status='Development'"];
//            break;
//        case 2:
//            str=[str stringByAppendingString :@" and status<>'Development' and status<>'Closed' and isactive='1'"];
//            break;
//        case 3:
//            str=[str stringByAppendingString :@" and status<>'Development' and status<>'Closed'  and isactive='0'"];
//            break;
//        default:
//            str=[str stringByAppendingString :@"and status='Closed'"];
//            break;
//    }    return str;
//}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    cl_project *mp =[[cl_project alloc]init];
//    mp.managedObjectContext=self.managedObjectContext;
//    rtnlist=[mp getProjectList:[self getSearchCondition]];
//    [tbview reloadData];
    
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"name like [c]'*%@*' or planname like [c]'*%@*' or idnumber like [c]'%@*' or status like [c]'*%@*'", searchText, searchText, searchText,searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        
        return [rtnlist count];
    }
   
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        static NSString *CellIdentifier;

            CellIdentifier = @"Cell1";
            if(xatype==1){
                developmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                //            if (cell == nil)
                //            {
                cell = [[developmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellSelectionStyleNone;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
                //                [cell SetDetailWithId:[kv valueForKey:@"idnumber"] withName:[kv valueForKey:@"name"] WithPname:[kv valueForKey:@"planname"] WithStatus:[kv valueForKey:@"status"]];
                
                //           }
                
                
                
                cell.idproject=[kv valueForKey:@"idnumber"];
                cell.projectname=[kv valueForKey:@"name"];
                cell.status=[kv valueForKey:@"status"];
                [cell .imageView setImage:nil];
                return cell;
            }else{
            projectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil)
//            {
                cell = [[projectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellSelectionStyleNone;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
//                [cell SetDetailWithId:[kv valueForKey:@"idnumber"] withName:[kv valueForKey:@"name"] WithPname:[kv valueForKey:@"planname"] WithStatus:[kv valueForKey:@"status"]];
            
//           }
            
           
           
            cell.idproject=[kv valueForKey:@"idnumber"];
            cell.planname=[kv valueForKey:@"planname"];
            cell.projectname=[kv valueForKey:@"name"];
            cell.status=[kv valueForKey:@"status"];
            [cell .imageView setImage:nil];
                return cell;
            }
//        }
        
    }
}



-(void)doaClicked:(NSString *)str :(BOOL) isup{
  
  [rtnlist sortUsingComparator:^NSComparisonResult(NSEntityDescription* obj1, NSEntityDescription* obj2) {
        
        
      if (isup) {
          return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
      }else{
      return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
      }
      
    }];
    [tbview reloadData];
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
       [self autoUpd];
       
    }
    
}
-(void)autoUpd{
    
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    
    [searchtxt resignFirstResponder];
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    if (xatype==1) {
        development *LoginS=[[development alloc]init];
        LoginS.managedObjectContext=self.managedObjectContext;
         LoginS.idproject=[kv valueForKey:@"idnumber"];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
        [self.navigationController pushViewController:LoginS animated:NO];
    }else{
        
        project *LoginS=[[project alloc]init];
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idproject=[kv valueForKey:@"idnumber"];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=self.tbindex;
       [self.navigationController pushViewController:LoginS animated:NO];
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end