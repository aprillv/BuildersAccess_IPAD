//
//  project.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "project.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_favorite.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "cl_project.h"
#import "Reachability.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI
#import "phoneDetail.h"
#import "cl_sync.h"
#import "MBProgressHUD.h"
#import "cl_phone.h"
#import "startPark.h"
#import "website.h"
#import "projectpo.h"
#import "projectSuggestPrice.h"
#import "projectcols.h"
#import "projectaddc.h"
#import "qainspectionb.h"
#import "qainspection.h"
#import "requestedvpols.h"
#import "newSchedule1.h"
#import "contractforapproveupd.h"
#import "developmentVendorLs.h"
#import "projectPhotoFolder.h"
#import "ProjectPhotoName.h"
#import "projectContractFiles.h"

@interface project ()<MBProgressHUDDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, projectContractFilesDelegate>{
    MBProgressHUD *HUD;
    NSMutableArray *uploadLs;
    UIAlertView *myAlertView;
    int y;
    BOOL isaddfavorite;
    NSURL *turl;
    wcfProjectItem* result;
    NSMutableArray *rtnfiles;
    BOOL isshow;
    wcfProjectFile *key;
    NSString *xtoemail;
    NSString *xtoename;
    NSMutableArray *pmLs;
    NSMutableArray *pmEmailLs;
}


@end




@implementation project
@synthesize idproject, docController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:[userInfo getCiaName]];
   
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self getIsTwoPart]) {
        btnNext.frame = CGRectMake(10, 26, 40, 32);
    }else{
        btnNext.frame = CGRectMake(60, 26, 40, 32);
    }
    
    [[UITableView appearance] setSeparatorColor:[UIColor clearColor]];
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back1"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    [self.navigationBar addSubview:btnNext];
    
    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    if ([mf isInFavorite:self.idproject]) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"favorite_delete.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Remove" ];
        isaddfavorite=NO;
    }else{
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Favorite" ];
        isaddfavorite=YES;
    }
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(addtoFavorite:)];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
    
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self addtoFavorite:nil];
    }else if(item.tag == 2){
        [self refreshPrject:nil];
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


-(void)gotoprofile:(NSString *)xemail1{
    xemail=xemail1;
    
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        xtoemail=xemail;
        [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync:result.mastercia :@"5"]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync Phone List with your device, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 3;
            [alert show];
        }else{
            
            phoneDetail *pd =[phoneDetail alloc];
            pd.menulist=self.menulist;
            pd.idmaster=result.mastercia;
            pd.detailstrarr=self.detailstrarr;
            pd.tbindex=self.tbindex;
            pd.managedObjectContext=self.managedObjectContext;
            pd.email =xemail;
            pd.ename=xtoename;
            [self.navigationController pushViewController:pd animated:NO];
        }
    }
    
    
}
-(void)contactPm1:(int) row{
    xtoename=[pmLs objectAtIndex:row];
    [self gotoprofile:[pmEmailLs objectAtIndex:row]];
}
-(void)contactSales1{
    xtoename=result.Sales1;
    [self gotoprofile:result.Sales1Email];
}
-(void)contactSales2{
    xtoename=result.Sales2;
    [self gotoprofile:result.Sales2Email];
}


-(IBAction)refreshPrject:(id)sender{
    [self autoUpd];
}

-(void)autoUpd{
    
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self getDetail];
    }
    
    
}



-(IBAction)addtoFavorite:(id)sender{
    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    if(isaddfavorite){
        if ([mf addToFavorite:self.idproject]) {
            UIAlertView *alert=[self getSuccessAlert:@"Add to Favorite successfully."];
            alert.tag=1;
            alert.delegate=self;
            [alert show];
        } ;
    }else{
        if ( [mf removeFromFavorite:self.idproject]) {
            UIAlertView *alert=[self getSuccessAlert:@"Remove from Favorite successfully."];
            alert.tag=2;
            alert.delegate=self;
            [alert show];
            
        };
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
    if (alertView.tag==101){
        switch (buttonIndex) {
            case 2:
            {
                UIImagePickerController *p = [[UIImagePickerController alloc]init];
                p.delegate=self;
                p.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:p animated:YES completion:nil];
            }
                break;
                
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *p = [[UIImagePickerController alloc]init];
                    p.delegate=self;
                    p.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:p animated:YES completion:nil];
                    
                    
                }else{
                    [[self getErrorAlert:@"There is no camera available."] show];
                }
                
                
            }
        }
    }else{
    switch (buttonIndex) {
        case 0:
            if (alertView.tag==1) {
                [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"favorite_delete.png"] ];
                [[ntabbar.items objectAtIndex:0]setTitle:@"Remove" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=NO;
            }else if (alertView.tag==2){
                [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
                [[ntabbar.items objectAtIndex:0]setTitle:@"Favorite" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=YES;
            }
            break;
        case 1:{
            if (alertView.tag==10) {
                [[UIApplication sharedApplication] openURL:turl];
            }else if(alertView.tag==3){
                [self doSyncPhoneList];
            }
        }
            break;
            
    }
    }
    
    
}



-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Phone List..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Phone List...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];

        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: result.mastercia EquipmentType: @"3"];
    }
    
}

- (void) xGetPhoneListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result7 = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result7 andidcia:result.mastercia];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync: result.mastercia:@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [ntabbar setSelectedItem:nil];
    phoneDetail *pd =[phoneDetail alloc];
    pd.idmaster=result.mastercia;
    pd.menulist=self.menulist;
    pd.detailstrarr=self.detailstrarr;
    pd.tbindex=self.tbindex;
    pd.managedObjectContext=self.managedObjectContext;
    pd.email =xtoemail;
    pd.ename=xtoename;
    [self.navigationController pushViewController:pd animated:NO];
    
}



-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetProject:self action:@selector(xGetProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject xtype: 0 EquipmentType: @"3"];
        
    }
    
}

- (void) xGetProjectHandler: (id) value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }

    
    
	// Do something with the wcfProjectItem* result
    result = (wcfProjectItem*)value;
    [self drawScreen1];
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [service xGetProjectFiles:self action:@selector(xGetProjectFilesHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject EquipmentType: @"3"];
    }
    
    
    
    
    
}

- (void) xGetProjectFilesHandler: (id) value {
    
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
    rtnfiles = (NSMutableArray*)value;
	[self drawScreen2];
    
 
        cl_project *cp =[[cl_project alloc]init];
        cp.managedObjectContext=self.managedObjectContext;
        [cp updProject:result andId:idproject];
        
        cl_favorite *cf =[[cl_favorite alloc]init];
        cf.managedObjectContext=self.managedObjectContext;
        [cf updProject:result andId:idproject];
        
    [ntabbar setSelectedItem:nil];
}

-(void) drawScreen1{
    y=10;
    int dwidth = self.uw.frame.size.width;
    sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, dwidth, self.uw.frame.size.height)];
    sv.backgroundColor=[UIColor whiteColor];
    [self.uw addSubview:sv];
    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    

    
    UITableView *uv =(UITableView *)[sv viewWithTag:4];
    if (uv !=nil) {
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:5];
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:6];
        [uv reloadData];
        
        uv=(UITableView *)[sv viewWithTag:10];
        [uv reloadData];
    }else{
        UILabel *lbl;
        float rowheight=32.0;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth-20, 21)];
        lbl.text=[NSString stringWithFormat:@"Project # %@", idproject];
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int tmpheight =rowheight*4;
        if ([result.Status isEqualToString:@"Sold"]|| [result.Status isEqualToString:@"Closed"]) {
            tmpheight=tmpheight+9;
        }
        if(result.Stage !=nil){
        tmpheight=tmpheight+9;
        }
        UILabel *borderLabel;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth-20,tmpheight )];
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lbl.layer.cornerRadius=10.0;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        borderLabel = lbl;
        [sv addSubview:lbl];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, rowheight-1)];
        lbl.text=result.Name;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
          UITableView *ciatbview;
        if(result.Stage ==nil){
             lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-1)];
            lbl.text=@"Schedule Not Started";
            lbl.textColor=[UIColor redColor];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [sv addSubview:lbl];
 y=y+rowheight;
        }else{
//            lbl.text=result.Stage;
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, dwidth-20, 40)];
            ciatbview.tag=17;
            ciatbview.backgroundColor=[UIColor clearColor];
            ciatbview.separatorColor=[UIColor clearColor];
            [ciatbview setRowHeight:40];
            ciatbview.autoresizingMask =UIViewAutoresizingFlexibleWidth;
            [sv insertSubview:ciatbview belowSubview:borderLabel];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
             y=y+41;
        }
        
              
        if ([result.Status isEqualToString:@"Sold"]|| [result.Status isEqualToString:@"Closed"]) {
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, dwidth-20, rowheight-1)];
//            ciatbview.tag=18;
//            ciatbview.backgroundColor=[UIColor clearColor];
//            ciatbview.separatorColor=[UIColor clearColor];
//            [ciatbview setRowHeight:rowheight-1];
//            ciatbview.autoresizingMask =UIViewAutoresizingFlexibleWidth;
//            [sv addSubview:ciatbview];
//            ciatbview.delegate = self;
//            ciatbview.dataSource = self;
            
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, dwidth-20, 40)];
            ciatbview.tag=18;
            ciatbview.backgroundColor=[UIColor clearColor];
            ciatbview.separatorColor=[UIColor clearColor];
            [ciatbview setRowHeight:40];
            ciatbview.autoresizingMask =UIViewAutoresizingFlexibleWidth;
            [sv addSubview:ciatbview];
            [sv insertSubview:ciatbview belowSubview:borderLabel];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+41;
            
            
        }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-20, rowheight-1)];
        lbl.text=result.Status;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
            y=y+rowheight;
        }
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-20, rowheight-1)];
        if ([result.Status isEqualToString:@"Specs"]) {
            lbl.text=[NSString stringWithFormat:@"Asking  $ %@", result.Asking];
        }
        if (![result.Status isEqualToString:@"Specs"] && [result.Sold intValue]>0){
            lbl.text=[NSString stringWithFormat:@"Sold  $ %@", result.Sold];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:lbl];
        y=y+rowheight;
        
        
        
        y=y+10;
        
     
        if (result.Askingyn && [result.Status isEqualToString:@"Specs"]) {
            y=y+5;
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, 44)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=16;
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [ciatbview setRowHeight:44];
            ciatbview.layer.borderWidth = 1.2;
            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+44+10;
        }
        
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Legal Description";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth-20, rowheight*4)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:lbl];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, rowheight-1)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if (result.Permit !=nil) {
            lbl.text=[NSString stringWithFormat:@"City Permit:  %@", result.Permit ];
            lbl.font=[UIFont systemFontOfSize:16.0];

            [sv addSubview:lbl];
        }else{
           lbl.text=@"City Permit:";
            CGRect rect2 = CGRectMake(20, y+4, 92, rowheight-1);
            lbl.frame=rect2;
            rect2 = CGRectMake(lbl.frame.size.width+10, 0, 295, 32);
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
            rect2 = CGRectMake(110, y+4, 92, rowheight-1);
            UILabel * label1= [[UILabel alloc]initWithFrame:rect2];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.font=[UIFont systemFontOfSize:16.0];
            label1.text=@"n / a";
            label1.textColor=[UIColor redColor];
            [sv addSubview:label1];
        }
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-1)];
        if(result.Lot ==nil){
            lbl.text=@"Lot:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Lot:  %@", result.Lot ];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-20, rowheight-1)];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if(result.Block ==nil){
            lbl.text=@"Block:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Block:  %@", result.Block ]; }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-30, rowheight-1)];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if(result.Section ==nil){
            lbl.text=@"Section:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Section:  %@", result.Section ];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight+10;
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Floorplan";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int rtn =4;
        if (result.Reverseyn ) {
            rtn=rtn+1;
        }
        if (result.Repeated){
            rtn=rtn+1;
        }
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth-20, rowheight*rtn)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:lbl];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-30, rowheight-1)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if (result.IDFloorplan !=nil) {
            lbl.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
        }else{
            lbl.text=@"Plan No.";
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-30, rowheight-1)];
        if (result.PlanName==nil) {
            lbl.text=@"n / a";
            lbl.textColor=[UIColor redColor];
        }else{
            lbl.text=result.PlanName;
        }
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-30, rowheight-1)];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if (result.Bedrooms ==nil || result.Baths == nil) {
            lbl.text=@"Beds  / Baths ";
        }else if (result.Bedrooms ==nil ) {
            lbl.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
        }else if(result.Baths==nil){
            lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
        }else{
            lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
        }   
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-30, rowheight-1)];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        if(result.Garage !=nil){
            lbl.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
        }else{
            lbl.text=@"Garage";
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        if (result.Reverseyn ) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-20, rowheight-1)];
            lbl.text=@"Builder Reverse";
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [sv addSubview:lbl];
            y=y+rowheight-1;
        }
        
        if (result.Repeated){
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, dwidth-20, rowheight-1)];
            lbl.text=@"Repeated Plan";
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [sv addSubview:lbl];
            y=y+rowheight-1;
        }
        y=y+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Brochure";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        rtn=1;
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44)];
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        ciatbview.tag=10;
        [ciatbview setRowHeight:44.0f];
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+rtn*44+10;
        
        uploadLs =[[NSMutableArray alloc]init];
        if ([result.AddPhoto intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload Photos (%@)", result.AddPhoto]];
        }
        if ([result.AddPMNotes intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload PM Notes (%@)", result.AddPMNotes]];
        }
        
        if ([uploadLs count]>0) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, [uploadLs count]*44)];
            ciatbview.layer.borderWidth = 1.2;
            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            ciatbview.tag=30;
            
            [ciatbview setRowHeight:44.0f];
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+[uploadLs count]*44+10;
        }
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Quick Link";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        
        qllist=[[NSMutableArray alloc]init];
        
        if (result.HasVendorYN) {
            [qllist addObject:@"Preferred Vendors"];
        }else{
            [qllist addObject:@"Preferred vendors not assigned"];
        }
        if (![result.requestvpo isEqualToString:@"0"]) {
            [qllist addObject:@"Requested VPO"];
        }
        
        if (result.poyn) {
            [qllist addObject:@"Purchase Order"];
        }
        if (result.coyn) {
            [qllist addObject:@"Change Order"];
        }
        if (result.contractyn) {
//            [qllist addObject:[NSString stringWithFormat:@"Contract(%@)", result.contractCnt]];
            if (![result.contractCnt isEqualToString:@"0"]){
                [qllist addObject:[NSString stringWithFormat:@"Contract(%@)", result.contractCnt]];
            }
        }
        if ([result.Status isEqualToString:@"Sold"] || [result.Status isEqualToString:@"Closed"]) {
            [qllist addObject:@"Addendum C"];
        }
        
        [qllist addObject:@"Start Pack"];
        [qllist addObject:@"Interior Selection List"];
        [qllist addObject:@"Interior Selection Pictures"];
        [qllist addObject:@"Exterior Selection List"];
        [qllist addObject:@"Exterior Selection Picture"];
        
        if (![result.IdQaInspection isEqualToString:@"0"]) {
            [qllist addObject:@"QA Inspection"];
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, [qllist count]*44.0)];
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

        ciatbview.layer.cornerRadius = 10;
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        ciatbview.tag=15;
        [ciatbview setRowHeight:44.0f];
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+[qllist count]*44+10;
        
        sv.contentSize=CGSizeMake(320.0,y+25);
    }
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}

- (void)scaleImage:(UIImage *)image

{
    
    ProjectPhotoName *pn =[ProjectPhotoName alloc];
    pn.managedObjectContext=self.managedObjectContext;
    pn.idproject=self.idproject;
    pn.isDevelopment=NO;
    pn.imgsss=image;
    pn.isPhoto=NO;
    pn.detailstrarr=self.detailstrarr;
    pn.menulist=self.menulist;
    pn.tbindex=self.tbindex;
    [self.navigationController pushViewController:pn animated:NO];
    
}

-(void) drawScreen2{
    int dwidth = self.uw.frame.size.width;
  
    UITableView *uv =(UITableView *)[sv viewWithTag:7];
    if (uv !=nil) {
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:8];
        [uv reloadData];
        
        uv=(UITableView *)[sv viewWithTag:11];
        [uv reloadData];
        
    }else{
        
        float rowheight=32.0;
        UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth-20, 21)];
        lbl.text= [NSString stringWithFormat:@"Base Plans (Rev.%d)", result.Revision];
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        UITableView* ciatbview;
        int  rtn=[rtnfiles count];
        if (result.UnderRevision ||result.ForPermitting) {
            
            rtn=0;
            if (result.UnderRevision) {
                rtn=rtn+1;
            }
            if (result.ForPermitting) {
                rtn=rtn+1;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44)];
            ciatbview.layer.cornerRadius = 10;
             ciatbview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            ciatbview.separatorColor=[UIColor clearColor];
            ciatbview.tag=9;
            ciatbview.layer.borderWidth = 1.2;
            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

            [ciatbview setRowHeight:rowheight];
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+44*rtn+10;
        }else{
            if (rtn==0) {
                rtn=1;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=7;
            ciatbview.layer.borderWidth = 1.2;
            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

            [ciatbview setRowHeight:44.0f];
             ciatbview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            
            y=y+44*rtn+10;
        }
        
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Project Manager";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        pmLs=[[NSMutableArray alloc]init];
        pmEmailLs=[[NSMutableArray alloc]init];
        if (result.PM1) {
            [pmLs addObject:result.PM1];
//            [pmEmailLs addObject:result.PM1Email];
            if (result.PM1Email) {
                [pmEmailLs addObject:result.PM1Email];
            }else{
                [pmEmailLs addObject:@""];
            }
        }
        if (result.PM2) {
            [pmLs addObject:result.PM2];
            if (result.PM2Email) {
                [pmEmailLs addObject:result.PM2Email];
            }else{
                [pmEmailLs addObject:@""];
            }
//            [pmEmailLs addObject:result.PM2Email];
        }
        //        NSLog(@"%@ %@ %@ %@", result.PM3, result.PM4, result.PM3Email, result.PM4Email);
        if (result.PM3) {
            [pmLs addObject:result.PM3];
            if (result.PM3Email) {
            [pmEmailLs addObject:result.PM3Email];
            }else{
            [pmEmailLs addObject:@""];
            }
            
        }
        if (result.PM4) {
            [pmLs addObject:result.PM4];
            if (result.PM4Email) {
                [pmEmailLs addObject:result.PM4Email];
            }else{
                [pmEmailLs addObject:@""];
            }
//            [pmEmailLs addObject:result.PM4Email];
        }

        
        if ([pmLs count]==0) {
            rtn=1;
        }else{
            rtn=[pmLs count];
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=8;
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

        [ciatbview setRowHeight:44.0f];
         ciatbview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Sales Consultant";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        rtn=2;
        if (!result.Sales1) {
            rtn=rtn-1;
        }
        if(!result.Sales2){
            rtn=rtn-1;
        }
        if (rtn==0) {
            rtn=1;
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=11;
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [ciatbview setRowHeight:44.0f];
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;

        
        sv.contentSize=CGSizeMake(320.0,y+25);
    }
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
                if (tableView.tag==30) {
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                    cell.contentView.backgroundColor = [UIColor redColor];
                    cell.textLabel.text =[uploadLs objectAtIndex:indexPath.row];
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    cell.layoutMargins = UIEdgeInsetsZero;
                    [cell .imageView setImage:nil];
                }else if (tableView.tag!=7 && tableView.tag!=10 && tableView.tag!=8 && tableView.tag!=11 && tableView.tag!=15 && tableView.tag!=16 && tableView.tag!=17 && tableView.tag!=18) {
                cell=[[BAUITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 32)];
                CGRect rect = CGRectMake(10, 0, 295, 32);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                switch (tableView.tag) {
                    case 9:{
                        switch (indexPath.row){
                            case 0:
                                if (result.UnderRevision) {
                                    label.text =@"Plans Under Revision";
                                    label.textColor=[UIColor redColor];
                                }else{
                                    label.text =@"For Permitting Only";
                                    label.textColor=[UIColor redColor];
                                }
                                
                                
                                break;
                            default:
                                if (result.UnderRevision && result.ForPermitting) {
                                    label.text =@"For Permitting Only";
                                    label.textColor=[UIColor redColor];
                                }
                                
                                break;
                        }
                    }
                        
                        break;
                        
                        
                        
                        
                    default:
                        break;
                        
                }
                
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else if(tableView.tag==8){
                
                if (result.PM1==nil && result.PM2==nil) {
                    cell=[[BAUITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                    CGRect rect = CGRectMake(10, 0, 295, 44);
                    UILabel * label= [[UILabel alloc]initWithFrame:rect];
                    label.textAlignment=NSTextAlignmentLeft;
                    label.font=[UIFont systemFontOfSize:16.0];
                    label.text=@"n / a";
                    label.textColor=[UIColor redColor];
                    [cell.contentView addSubview:label];
                    cell.userInteractionEnabled = NO;
                }else{
                    if (cell == nil){
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    
                    [cell .imageView setImage:nil];
                    
                    cell.textLabel.text=[pmLs objectAtIndex:indexPath.row];
                    
                }
                
            }else if(tableView.tag==11){
                if (result.Sales1==nil && result.Sales2==nil) {
                    cell=[[BAUITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                    CGRect rect = CGRectMake(10, 0, 295, 44);
                    UILabel * label= [[UILabel alloc]initWithFrame:rect];
                    label.textAlignment=NSTextAlignmentLeft;
                    label.font=[UIFont systemFontOfSize:16.0];
                    label.text=@"n / a";
                    label.textColor=[UIColor redColor];
                    [cell.contentView addSubview:label];
                    cell.userInteractionEnabled = NO;
                }else{
                    if (cell == nil){
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    [cell .imageView setImage:nil];
                    switch (indexPath.row){
                        case 0:
                            if (result.Sales1 !=nil) {
                                cell.textLabel.text=result.Sales1;
                            }else{
                                cell.textLabel.text=result.Sales2;
                            }
                            break;
                        case 1:
                            cell.textLabel.text=result.Sales2;
                            break;
                    }
                }
            }else if(tableView.tag==10){
                if (result.Brochure) {
                    if (cell == nil){
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    cell.textLabel.text =@"Download Brochure";
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    
                    [cell .imageView setImage:nil];
                    
                }else{
                    cell=[[BAUITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                    CGRect rect = CGRectMake(10, 0, 295, 44);
                    UILabel * label= [[UILabel alloc]initWithFrame:rect];
                    label.textAlignment=NSTextAlignmentLeft;
                    label.font=[UIFont systemFontOfSize:16.0];
                    label.text=@"n / a";
                    label.textColor=[UIColor redColor];
                    [cell.contentView addSubview:label];
                    cell.userInteractionEnabled = NO;
                }
                
            }else if(tableView.tag==7){
                
                if ([rtnfiles count]==0) {
                    cell=[[BAUITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                    CGRect rect = CGRectMake(10, 0, 295, 44);
                    UILabel * label= [[UILabel alloc]initWithFrame:rect];
                    label.textAlignment=NSTextAlignmentLeft;
                    label.font=[UIFont systemFontOfSize:16.0];
                    label.text=@"n / a";
                    label.textColor=[UIColor redColor];
                    [cell.contentView addSubview:label];
                    cell.userInteractionEnabled = NO;
                }else{
                    if (cell == nil){
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    wcfProjectFile *pf =[rtnfiles objectAtIndex:indexPath.row];
                    cell.textLabel.text =pf.Name;
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    [cell .imageView setImage:nil];
                    
                }
            }else if(tableView.tag==15){
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell .imageView setImage:nil];
                if (indexPath.row==0 && !result.HasVendorYN) {
                    cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.textColor=[UIColor redColor];
                    cell.userInteractionEnabled = NO;
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else{
                    cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
                }
                
            }else if(tableView.tag==16){
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell.imageView setImage:nil];
                cell.textLabel.text=@"Suggest New Price";
            }else if(tableView.tag==18){
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell.imageView setImage:nil];
                cell.textLabel.text=result.Status;
             }else{
                 if (cell == nil){
                     cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                 }
                 cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                 [cell.imageView setImage:nil];
                 cell.textLabel.text=[NSString stringWithFormat:@"%@", result.Stage];
             }
        }
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    
    int rtn;
    switch (tableView.tag) {
        case 30:
            rtn=[uploadLs count];
            break;
        case 15:
            rtn=[qllist count];
            break;
        case 16:
        case 17:
         case 18:
            rtn=1;
            break;
        case 8:
            if ([pmLs count]==0) {
                rtn=1;
            }else{
                rtn=[pmLs count];
            }
            break;
        case 11:
            rtn=2;
            if (!result.Sales1) {
                rtn=rtn-1;
            }
            if(!result.Sales2){
                rtn=rtn-1;
            }
            if (rtn==0) {
                rtn=1;
            }
            break;
        case 7:{
            rtn=[rtnfiles count];
            if (rtn==0) {
                rtn=1;
            }
        }
            break;
        case 9:
            rtn=0;
            if (result.UnderRevision) {
                rtn=rtn+1;
            }
            if (result.ForPermitting) {
                rtn=rtn+1;
            }
            break;
        case 10:
            rtn=1;
            break;
            
        default:
            rtn=4;
            break;
    }
    return rtn;
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [ntabbar setSelectedItem:nil];
    [self getDetail];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        tbview=tableView;
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
            [alert show];
        }else{
            wcfService* service = [wcfService service];
            NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler3:) version:version];
        }
    }
}

- (void) xisupdate_iphoneHandler3: (id) value {
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
//        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            if (tbview.tag==7) {
                key =(wcfProjectFile *)[rtnfiles objectAtIndex:indexPath.row];
                
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project File..." delegate:self otherButtonTitles:nil];
//                isshow=YES;
//                [alertViewWithProgressbar show];
               
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Download Project File...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                
                NSString *str;
                
                wcfService *service=[wcfService service];
                
                
                str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"<view> %@", key.FName] stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
                
                [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                

                
            } else if (tbview.tag==30) {
                NSString *key1 =[uploadLs objectAtIndex:indexPath.row];
                if ([key1 hasPrefix:@"Upload Photos"]) {
                    
                    projectPhotoFolder *pf =[projectPhotoFolder alloc];
                    pf.managedObjectContext=self.managedObjectContext;
                    pf.idproject=self.idproject;
                    pf.detailstrarr=self.detailstrarr;
                    pf.menulist=self.menulist;
                    pf.tbindex=self.tbindex;
                    pf.isDevelopment=NO;
                    [self.navigationController pushViewController:pf animated:NO];
                }else{
                    
                    UIAlertView *alert = nil;
                    alert = [[UIAlertView alloc]
                             initWithTitle:@"BuildersAccess"
                             message:nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"New Photo",@"Choose from Library", nil];
                    alert.tag = 101;
                    [alert show];
                }
                 } else if (tbview.tag==8) {
                     [self contactPm1:indexPath.row];
            } else if (tbview.tag==11) {
                if (indexPath.row==0) {
                    if ( result.Sales1) {
                        [self contactSales1];
                    }else{
                        [self contactSales2];
                    }
                    
                }else{
                    [self contactSales2];
                }
                
                
            } else if (tbview.tag==10) {
                // @"Download Project Brochure..."
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project Brochure..." delegate:self otherButtonTitles:nil];
//                isshow=YES;
//                [alertViewWithProgressbar show];
                
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Download Project Brochure...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];

                
                NSString *str;
                
                wcfService *service=[wcfService service];
                str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"<view> %@_brochure.pdf", result.Name] stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
                
                [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Download Brochure" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                

            }else if (tbview.tag==16) {
                wcfService* service = [wcfService service];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [service xFoundForApprove:self action:@selector(xFoundForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject];
                
            } else if (tbview.tag==17) {
                newSchedule1 *ns =[newSchedule1 alloc];
                ns.managedObjectContext=self.managedObjectContext;
                ns.menulist=self.menulist;
                ns.detailstrarr=self.detailstrarr;
                ns.tbindex=self.tbindex;
                ns.isshowTaskDue=!result.ArchiveYN;
                ns.xidproject=self.idproject;
                [self.navigationController pushViewController:ns animated:NO];
            } else if (tbview.tag==18) {
                if (result.IdContract==nil) {
                    UIAlertView *alert=[self getErrorAlert:@"There is no Contract with this project."];
                    [alert show];
                }else{
                    contractforapproveupd *a =[contractforapproveupd alloc];
                    a.managedObjectContext=self.managedObjectContext;
                    a.menulist=self.menulist;
                    a.detailstrarr=self.detailstrarr;
                    a.tbindex=self.tbindex;
                    a.oidcia=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
                    a.xfromtype=2;
                    //                    a.title=[NSString stringWithFormat:@"Contract-%@", @"1025"];
                    a.ocontractid=result.IdContract;
                    [self.navigationController pushViewController:a animated:NO];
                }
            }else if (tbview.tag==15) {
                
                UITableViewCell *ccell = [tbview cellForRowAtIndexPath:indexPath];
                NSString *str =[qllist objectAtIndex:indexPath.row];
                
                NSString *surl;
                if ([str isEqualToString:@"Purchase Order"]) {
                    //po
                    [self getProjectPo];
                    
//                }else if ([str isEqualToString:@"Create Purchase Order"]) {
//                        //po
//                        [self getPoAssembly];
                }else if([str isEqualToString:@"Requested VPO"]){
                    
                    
                    requestedvpols *LoginS=[requestedvpols alloc];
                    LoginS.tbindex=self.tbindex;
                    LoginS.menulist=self.menulist;
                    LoginS.detailstrarr=self.detailstrarr;
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.xtype=8;
                    LoginS.idproject=self.idproject;
                    [self.navigationController pushViewController:LoginS animated:NO];
                }else if([str isEqualToString:@"Addendum C"]){
                    projectaddc *a =[projectaddc alloc];
                    a.menulist=self.menulist;
                    a.detailstrarr=self.detailstrarr;
                    a.tbindex=self.tbindex;
                    a.managedObjectContext=self.managedObjectContext;
                    a.idproject=self.idproject;
                    [self.navigationController pushViewController:a animated:NO];
                    
                }else if([str isEqualToString:@"Change Order"]){
                    
                    [self getCols];
                }else if([str hasPrefix:@"Contract("]){
                                        [self gotoContractFiles: str];
                }else if ([str isEqualToString:@"Preferred Vendors"]) {
                    developmentVendorLs *dl = [developmentVendorLs alloc];
                    dl.managedObjectContext=self.managedObjectContext;
                    dl.idproject=self.idproject;
                      dl.idmaster=result.mastercia;
                    dl.tbindex=self.tbindex;
                    dl.menulist=self.menulist;
                    dl.detailstrarr=self.detailstrarr;
                    [self.navigationController pushViewController:dl animated:NO];
                }else if([str isEqualToString:@"Start Pack"]){
                    startPark *cc =[[startPark alloc]init];
                    cc.idproject=self.idproject;
                    cc.menulist=self.menulist;
                    cc.detailstrarr=self.detailstrarr;
                    cc.tbindex=self.tbindex;
                    cc.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cc animated:NO];
                }else if([str isEqualToString:@"QA Inspection"]){
                    
                    wcfService* service = [wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [service xGetQACalendarStatus:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:result.IdQaInspection EquipmentType:@"5"];

                }else{
                    if ([str isEqualToString:@"Interior Selection List"]) {
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewlist.aspx?xidcia=%@&xidproject=%@&xtype=1", result.Elovecia, idproject];
                    }else if([str isEqualToString:@"Interior Selection Pictures"]){
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewselection.aspx?xidcia=%@&xidproject=%@&xtype=1", result.Elovecia, idproject];
                    }else if([str isEqualToString:@"Exterior Selection List"]){
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewlist.aspx?xidcia=%@&xidproject=%@&xtype=2", result.Elovecia, idproject];
                    }else{
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewselection.aspx?xidcia=%@&xidproject=%@&xtype=2", result.Elovecia, idproject];
                    }
                    website *LoginS=[website alloc];
                    LoginS.detailstrarr=self.detailstrarr;
                    LoginS.menulist=self.menulist;
                    LoginS.tbindex=self.tbindex;
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.atitle=ccell.textLabel.text;
                    LoginS.Url = surl;
                    [self.navigationController pushViewController:LoginS animated:NO];
                
                }
            }
        }
    }
    
    
}

- (void) xisupdate_iphoneHandler5: (id) value {
    
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
    if ([result2 isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Something wrong happened. Please try it again later."];
        [alert show];
        return;
        
    }else{
        
        if ([result2 isEqualToString:@"Not Started"] || [result2 isEqualToString:@"Not Ready"]) {
            qainspection *qt =[qainspection alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=result.IdQaInspection;
            qt.fromtype=1;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            [self.navigationController pushViewController:qt animated:NO];
        }else{
            qainspectionb *qt =[qainspectionb alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=result.IdQaInspection;
            qt.fromtype=1;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            [self.navigationController pushViewController:qt animated:NO];
        }
        
        
        
    }
}


-(void)getProjectPo{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:@""EquipmentType:@"5"];
}

- (void) xGetStartPackListHandler: (id) value {
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
    
    NSMutableArray*  poresult=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    [poresult removeObjectAtIndex:0];
    [poresult removeObjectAtIndex:0];
    if ([poresult count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Purchase order not found for this project"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        projectpo *cc =[projectpo alloc];
        cc.menulist=self.menulist;
        cc.detailstrarr=self.detailstrarr;
        cc.tbindex=self.tbindex;
        cc.idproject=self.idproject;
        cc.result=poresult;
        cc.idmaster=result.mastercia;
        if ([result.Status isEqualToString:@"Closed"]) {
            cc.xtype=1;
        }else{
            cc.xtype=0;
        }
        cc.isfromdevelopment=NO;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:NO];
    }
}




-(void)getCols {
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetProjectCOList:self action:@selector(xGetProjectCOListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject EquipmentType:@"5"];
}
- (void) xGetProjectCOListHandler: (id) value {
    
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    
   NSMutableArray* coresult =[(wcfArrayOfCOListItem*)value toMutableArray];
    [coresult removeObjectAtIndex:0];
    
    if ([coresult count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Change order not found for this project"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        projectcols *cc =[projectcols alloc];
        cc.menulist=self.menulist;
        cc.detailstrarr=self.detailstrarr;
        cc.tbindex=self.tbindex;
        cc.idproject=self.idproject;
        cc.result=coresult;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:NO];
    }
    
}


- (void) xFoundForApproveHandler: (id) value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
    
	// Do something with the NSString* result
    NSString* result8 = (NSString*)value;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if ([result8 isEqualToString:@"1"]) {
        projectSuggestPrice *ps =[projectSuggestPrice alloc];
        ps.menulist=self.menulist;
        ps.detailstrarr=self.detailstrarr;
        ps.tbindex=self.tbindex;
        ps.managedObjectContext=self.managedObjectContext;
        ps.idproject=self.idproject;
        ps.xsqft=result.sqft;
        [self.navigationController pushViewController:ps animated:NO];
    }else if([result8 isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@""
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:result8
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];

    }

    
}


- (void) xAddUserLogHandler: (BOOL) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Do something with the BOOL result
    
    if ([HUD.labelText hasPrefix:@"Download Project's Contract"]){return;}
    
	if ([HUD.labelText isEqualToString:@"Download Project File..."]) {
        NSString *str;
        
       
        str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname=%@", key.ID,[[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue], [Mysql md5:key.FSize],[key.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSURL *url = [NSURL URLWithString:str];
        if (turl==url) {
            BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                NSString *filePath = [self GetTempPath:key.FName];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[self GetTempPath:key.FName] atomically:NO];
                
                BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    NSString *filePath = [self GetTempPath:key.FName];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }
                
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:[self GetTempPath:key.FName] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                NSString *filePath = [self GetTempPath:key.FName];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        }
    }else{
        NSString *str;
        str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/brochure.aspx?email=%@&password=%@&idfloorplan=%@&idcia=%d", [userInfo getUserName], [userInfo getUserPwd], result.IDFloorplan, [userInfo getCiaId]];
//        NSLog(@"%@", str);
        NSURL *url = [NSURL URLWithString:str];
        if (turl==url) {
            NSString *pdfname =[NSString stringWithFormat:@"%@_brochure.pdf", result.Name];
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
                
                BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    
                    NSString *filePath = [self GetTempPath:pdfname];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }
                
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *pdfname =[NSString stringWithFormat:@"%@_broshure.pdf", result.Name];
            [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        }
    }
     NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
     [tbview deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)UTIForURL:(NSURL *)url
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
    return (__bridge NSString *)UTI;
}

- (void)openDocumentInteractionController:(NSURL *)fileURL{
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    docController.delegate = self;
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
   
    if(!isValid){
        
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?",
                                                                         @"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?"), deviceType];
      
        // Display alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil];
        alert.delegate=self;
        alert.tag=10;
        [alert show];
    }
}



-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoContractFiles:(NSString *) str{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetProjectContractFiles:self action: @selector(xGetProjectContractFilesHandler:)  xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  projectid:idproject EquipmentType:@"3"];
    
}

- (void) xGetProjectContractFilesHandler: (id) value {
    
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
    
    wcfArrayOfProjectFile* result2 = (wcfArrayOfProjectFile*)value;
    if (result2.count == 1) {
        wcfProjectFile *item = [result2.items firstObject];
        [self perpareDownLoadContractFile:item];
        
        //                NSData *data = [NSData dataWithContentsOfURL:url];
    }else{
        projectContractFiles *pl =[[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectContractFiles"];
//        pl.managedObjectContext=self.managedObjectContext;
        pl.title=@"Contract Files";
        pl.idproject = self.idproject;
        pl.projectname = result.Name;
        pl.fileListresult = result2.items;
        pl.delegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
//        [self presentModalViewController:modalVC animated:YES];
        
        [self.navigationController presentViewController:pl animated:YES completion:^{
            
        }];
//
//        [self.navigationController pushViewController:pl animated:YES];
    }
    
}

-(void)perpareDownLoadContractFile:(wcfProjectFile *)item{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Download Project's Contract File...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString *str;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSString *url1 = [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname%@", item.ID, [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue], item.FSize, [item.FName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    wcfService* service = [wcfService service];
    str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
         NSASCIIStringEncoding];
    
    NSString* escapedUrlString =
    [[NSString stringWithFormat:@"<view> %@", item.FName] stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    
    [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
    
    NSURL *url = [NSURL URLWithString:url1];
    turl = url;
    [self downloadFile: url];
}

-(void) downloadFile:(NSURL *)url
{
    //    NSURL * url = [NSURL URLWithString:@"https://s3.amazonaws.com/hayageek/downloads/SimpleBackgroundFetch.zip"];
    
    //    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
    //    dispatch_async(dispatch_get_global_queue(qos, 0)) {
    //        let imageData = NSData(contentsOfURL: url)
    //        dispatch_async(dispatch_get_main_queue()){
    //            if url == self.imageURL{
    //                if imageData != nil{
    //                    self.image = UIImage(data: imageData!)
    //                }else{
    //                    self.image = nil
    //                }
    //            }
    //
    //        }
    //    }
    
    //    id qos = [QOS_CLASS_USER_INITIATED rawValue];
    NSString *pdfname = @"tmp.pdf";
    dispatch_async((dispatch_get_global_queue(0, 0)), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        });
    });
    
}

-(void)openFiles:(wcfProjectFile *)fileNm{
    [self perpareDownLoadContractFile:fileNm];
}


@end
