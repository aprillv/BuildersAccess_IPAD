//
//  multiSearchRslt.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/23/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "multiSearchRslt.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "project.h"
#import "cl_cia.h"
#import "projectCell.h"
#import "firstcell.h"
#import <QuartzCore/QuartzCore.h>

@interface multiSearchRslt ()<firstcellDelegate>

@end

@implementation multiSearchRslt{
    UITabBar* ntabbar;
    int donext;
    NSMutableArray *wi;
    UITableView* tbview;
    UIButton *btnNext;
    firstcell *cell2;
}

@synthesize keyWord;

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
    
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
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
    
//    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
//    [self.uw addSubview:sv];
    
    self.title=keyWord;
    [self getSearchResult];
    
    
//    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, xheight)];
//    //    tbview.layer.cornerRadius = 10;
//    tbview.delegate = self;
//    tbview.dataSource = self;
//    //    tbview.editing=YES;
//    [uv addSubview:tbview];
    
	// Do any additional setup after loading the view.
}

-(void)getSearchResult{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xSearchProjects:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] keyword:keyWord EquipmentType:@"3"];
    }
}

- (void) xisupdate_iphoneHandler5: (id) value {
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
    
    wi=[(wcfArrayOfProjectListItem *)value toMutableArray];
    //    if (uv) {
    //        [uv removeFromSuperview];
    //    }
    
//    int xheight;
//    if (self.view.frame.size.height>480) {
//        xheight=454;
//        
//    }else{
//        xheight=366;
//    }
    
    if (wi.count>0) {
//        sv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        int dwidth = self.uw.frame.size.width;
        int dheight = self.uw.frame.size.height;
        //    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth,dheight)];
        int dh = [wi count]*44+44;
        if (dh >dheight) {
            dh=dheight;
        }
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, dwidth,dh)];
//        tbview.layer.cornerRadius = 10;
        tbview.delegate = self;
//        tbview.rowHeight=66;
//        tbview.layer.borderWidth = 1.2;
//        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        tbview.dataSource = self;
        //    tbview.editing=YES;
        [self.uw addSubview:tbview];
    }else{
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 21)];
        lbl.text=@"Projects not Found.";
        lbl.textColor=[UIColor redColor];
        [self.uw addSubview:lbl];
    }
    
    
}

-(void)orientationChanged{
    [super orientationChanged];
    [tbview reloadData];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
//    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    [tbview reloadData];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
     [tbview reloadData];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [wi count];}
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView: tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    static NSString *CellIdentifier = @"Cell";
//    
//    projectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////    if (cell == nil)
////    {
//        cell = [[projectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
////    }
//    
//    wcfProjectListItem *kv =[wi objectAtIndex:(indexPath.row)];
//    
//  
//    cell.textLabel.text =kv.ProjectName;
//    //    cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
//    if ([kv.Status isEqualToString:@"Development"]) {
//        cell.detailTextLabel.text=@"Development";
//    }else{
//        if(kv.PlanName==nil){
//            [cell.detailTextLabel setNumberOfLines:2];
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@",kv.Status];
//        }else{
//            [cell.detailTextLabel setNumberOfLines:2];
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", kv.PlanName, kv.Status];
//        }
//        
//    }
//    
//    
//    
//    
//    [cell .imageView setImage:nil];
//        return cell;
    
        wcfProjectListItem *kv =[wi objectAtIndex:(indexPath.row)];
       
        //            if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
        //                developmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //                cell = [[developmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //                cell.accessoryType = UITableViewCellSelectionStyleNone;
        //                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //                NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row-1)];
        //                cell.idproject=[kv valueForKey:@"idnumber"];
        //                cell.projectname=[kv valueForKey:@"name"];
        //                cell.status=[kv valueForKey:@"status"];
        //                [cell .imageView setImage:nil];
        //                return cell;
        //            }else{
        projectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[projectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.idproject=kv.IDNumber;
        cell.planname=kv.PlanName;
        cell.projectname=kv.ProjectName;
        cell.status=kv.Status;
        return cell;
    }
    
}

-(void)doaClicked:(NSString *)str :(BOOL) isup{
    NSString *ts;
    if ([str isEqualToString:@"idnumber"]) {
        ts=@"IDNumber";
    }else if([str isEqualToString:@"name"]) {
     ts=@"ProjectName";
    }else if([str isEqualToString:@"planname"]) {
             ts=@"PlanName";
    }else if([str isEqualToString:@"status"]) {
         ts=@"Status";
    }
    [wi sortUsingComparator:^NSComparisonResult(NSEntityDescription* obj1, NSEntityDescription* obj2) {
        
        
        if (isup) {
            return [[obj1 valueForKey:ts] compare:[obj2 valueForKey:ts]];
        }else{
            return [[obj2 valueForKey:ts] compare:[obj1 valueForKey:ts]];
        }
        
    }];
    [tbview reloadData];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[firstcell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
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


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 66;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [self autoUpd];}
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
        [self gotonextpage];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self orientationChanged];
}
-(void)gotonextpage {
    
  
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
    wcfProjectListItem *kv =[wi objectAtIndex:(indexPath.row)];
    
//    if (xatype==1) {
//        development *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"development"];
//        LoginS.managedObjectContext=self.managedObjectContext;
//        LoginS.idproject=[kv valueForKey:@"idnumber"];
//        [self.navigationController pushViewController:LoginS animated:YES];
//    }else{
        project *LoginS=[project alloc];
    LoginS.menulist=self.menulist;
    LoginS.detailstrarr=self.detailstrarr;
    LoginS.tbindex=self.tbindex;
        LoginS.idproject=kv.IDNumber;
    cl_cia *ma = [[cl_cia alloc]init];
    ma.managedObjectContext=self.managedObjectContext;
//    NSLog(@"%@", kv.Idcia);
//     NSMutableArray *rtnls =[ma getCiaListWithStr:[NSString stringWithFormat:@"ciaid=%@",kv.Idcia]];
    
//    [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"] intValue] andNm:[cia valueForKey:@"cianame"]];
     [userInfo initCiaInfo:[kv.Idcia intValue] andNm:kv.Ncia];
//      [userInfo initCiaInfo:[kv.Idcia intValue] andNm:@""];
        LoginS.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:LoginS animated:NO];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
