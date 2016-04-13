//
//  development.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "development.h"
#import "Mysql.h"
#import "userInfo.h"
#import "cl_favorite.h"
#import "cl_project.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h> // For UTI
#import "phoneDetail.h"
#import "MBProgressHUD.h"
#import "cl_phone.h"
#import "cl_sync.h"
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "projectpo.h"
#import "requestedvpols.h"
#import "developmentVendorLs.h"
#import "projectPhotoFolder.h"
#import "ProjectPhotoName.h"

@interface development ()<MBProgressHUDDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    MBProgressHUD *HUD;
     NSMutableArray *qllist;
    BOOL isaddfavorite;
    UIAlertView *myAlertView;
    BOOL isshow;
    wcfProjectFile *key;
    int y;
    NSString *xtoemail;
    NSString *xtoename;
    wcfProjectItem* result;
    NSMutableArray *rtnfiles;
    NSURL *turl;
    NSMutableArray *uploadLs;
    NSMutableArray *pmLs;
    NSMutableArray *pmEmailLs;
}


@end

@implementation development
@synthesize idproject, docController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self setTitle:[userInfo getCiaName]];
    
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
    
   
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
    [self getDetail];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self addtoFavorite: nil];
    }else if(item.tag == 2){
        [self refreshPrject: nil];
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
    pn.isDevelopment=YES;
    pn.imgsss=image;
    pn.isPhoto=NO;
    pn.detailstrarr=self.detailstrarr;
    pn.menulist=self.menulist;
    pn.tbindex=self.tbindex;
    [self.navigationController pushViewController:pn animated:NO];
    
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
        sv.contentSize=CGSizeMake(self.uw.frame.size.width, sv.contentSize.height);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
        sv.contentSize=CGSizeMake(self.uw.frame.size.width, sv.contentSize.height);
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        xtoemail=xemail;
        [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"5"]) {
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
            }else{
                [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
                [[ntabbar.items objectAtIndex:0]setTitle:@"Favorite" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=YES;
            }
            break;
        case 1:{
            if (alertView.tag==10) {
                [[UIApplication sharedApplication] openURL:turl];
            }else if(alertView.tag==3) {
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
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"3"];
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
    NSMutableArray* result2 = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result2];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [ntabbar setSelectedItem:nil];
    phoneDetail *pd =[phoneDetail alloc];
    pd.menulist=self.menulist;
    pd.detailstrarr=self.detailstrarr;
    pd.tbindex=self.tbindex;
    pd.idmaster=result.mastercia;
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
        [service xGetProject:self action:@selector(xGetProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject xtype: 1 EquipmentType: @"3"];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [self refreshPrject:nil];
    [ntabbar setSelectedItem:nil];
}

- (void) xGetProjectHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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

    
    
	// Do something with the wcfProjectItem* result
    result = (wcfProjectItem*)value;
    [self drawScreen1];
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
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
        uv =(UITableView *)[sv viewWithTag:5];
        [uv reloadData];
    }else{
        
        UILabel *lbl;
        dwidth=dwidth-20;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=[NSString stringWithFormat:@"Development # %@", idproject];
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int rowheight=32;
        UITableView *ciatbview;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y,dwidth , rowheight*6)];
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        

        lbl.layer.cornerRadius=10.0;
        [sv addSubview:lbl];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth-20, rowheight-1)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.text=result.Name;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Total Units: %d", result.TotalUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, dwidth-10, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Closed: %d", result.ClosedUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, dwidth-10, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Sold: %d", result.SoldUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-10, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Specs: %d", result.SpecsUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight-1;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, dwidth-10, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Active Projects: %d", result.ActiveUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight-1;
        y=y+10;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Sitemap";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44)];
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=5;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+44+10;
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;

        
        uploadLs =[[NSMutableArray alloc]init];
        if ([result.AddPhoto intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload Photos (%@)", result.AddPhoto]];
        }
        if ([result.AddPMNotes intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload PM Notes (%@)", result.AddPMNotes]];
        }
        
        if ([uploadLs count]>0) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, [uploadLs count]*44)];
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

        
        qllist =[[NSMutableArray alloc]init];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Quick Link";
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        if (result.HasVendorYN) {
              [qllist addObject:@"Preferred Vendors"];
        }else{
          [qllist addObject:@"Preferred vendors not assigned"];
        }
      
        
        if (result.poyn || ![result.requestvpo isEqualToString:@"0"]) {
           
            
            if (result.poyn) {
                [qllist addObject:@"Purchase Order"];
            }
            if (![result.requestvpo isEqualToString:@"0"]) {
                [qllist addObject:@"Requested VPO"];
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, [qllist count]*44)];
            ciatbview.layer.borderWidth = 1.2;
            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=15;
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+[qllist count]*44+10;
            
        }
        
        if (y<self.uw.frame.size.height+1) {
            sv.contentSize=CGSizeMake(dwidth+20,self.uw.frame.size.height+1);
        }else{
            sv.contentSize=CGSizeMake(dwidth+20,y+25);
        }
        
    }
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
        
        UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text= @"Development Files";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int  rtn=[rtnfiles count];
        if (rtn==0) {
            rtn=1;
        }
        UITableView* ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=7;
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [ciatbview setRowHeight:44.0f];
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
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
            [pmEmailLs addObject:result.PM1Email];
        }
        if (result.PM2) {
            [pmLs addObject:result.PM2];
            [pmEmailLs addObject:result.PM2Email];
        }
        //        NSLog(@"%@ %@ %@ %@", result.PM3, result.PM4, result.PM3Email, result.PM4Email);
        if (result.PM3) {
            [pmLs addObject:result.PM3];
            [pmEmailLs addObject:result.PM3Email];
        }
        if (result.PM4) {
            [pmLs addObject:result.PM4];
            [pmEmailLs addObject:result.PM4Email];
        }
        if ([pmLs count]==0) {
            rtn=1;
        }else{
            rtn=[pmLs count];
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=8;
        [ciatbview setRowHeight:44.0f];
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
       ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
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
        if(rtn==0){
            rtn=1;
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=11;
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
        sv.contentSize=CGSizeMake(dwidth,y+25);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            if (tableView.tag==30) {
                cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                
                cell.textLabel.text =[uploadLs objectAtIndex:indexPath.row];
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell .imageView setImage:nil];
            }else if(tableView.tag==5){
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

                }
                if (result.SiteMapyn) {
                    cell.textLabel.text =@"View Sitemap";
                    
                }else{
                    cell.textLabel.text =@"Sitemap not found";
                    cell.textLabel.textColor=[UIColor redColor];
                    cell.userInteractionEnabled=NO;
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }                
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                
                [cell .imageView setImage:nil];
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
                    if (cell == nil)
                    {
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;                    }
                    
                    
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    
                    [cell .imageView setImage:nil];
                    
                   cell.textLabel.text=[pmLs objectAtIndex:indexPath.row];
                }
            }else if(tableView.tag==15){
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                }
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
                    if (cell == nil)
                    {
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
            }else{
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
                    if (cell == nil)
                    {
                        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;                    }
                    wcfProjectFile *pf =[rtnfiles objectAtIndex:indexPath.row];
                    cell.textLabel.text =pf.Name;
                    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                    
                    [cell .imageView setImage:nil];
                }
                
            }
        }
        return cell;
    }
    
}
- (void)orientationChanged{
    [super orientationChanged];
    if (y<self.uw.frame.size.height+1) {
        sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    }else{
        sv.contentSize=CGSizeMake(self.uw.frame.size.width, y+25);
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
            case 5:
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
            case 7:
                rtn=[rtnfiles count];
                if (rtn==0) {
                    rtn=1;
                }
                break;
                
            default:
                rtn=4;
                break;
        }
        return rtn;
    }
    
}

-(void)getProjectPo{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:@"" EquipmentType:@"5"];
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
        cc.idmaster=result.mastercia;
        if ([result.Status isEqualToString:@"Closed"]) {
            cc.xtype=1;
        }else{
            cc.xtype=0;
        }
        cc.result=poresult;
        cc.idproject=self.idproject;
        cc.isfromdevelopment=YES;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (tableView.tag==15) {
            if ([[qllist objectAtIndex:indexPath.row]isEqualToString:@"Purchase Order"]) {
                 [self getProjectPo];
            }else if ([[qllist objectAtIndex:indexPath.row]isEqualToString:@"Preferred Vendors"]) {
                developmentVendorLs *dl = [developmentVendorLs alloc];
                dl.managedObjectContext=self.managedObjectContext;
                dl.tbindex=self.tbindex;
                  dl.idmaster=result.mastercia;
                dl.menulist=self.menulist;
                dl.detailstrarr=self.detailstrarr;
                dl.idproject=self.idproject;
                [self.navigationController pushViewController:dl animated:NO];
            }else{
                requestedvpols *LoginS=[requestedvpols alloc];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.tbindex=self.tbindex;
                LoginS.menulist=self.menulist;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.xtype=8;
                LoginS.idproject=self.idproject;
                [self.navigationController pushViewController:LoginS animated:NO];
            }
         }else if (tableView.tag==30) {
             NSString *key1 =[uploadLs objectAtIndex:indexPath.row];
             if ([key1 hasPrefix:@"Upload Photos"]) {
                 
                 projectPhotoFolder *pf =[projectPhotoFolder alloc];
                 pf.managedObjectContext=self.managedObjectContext;
                 pf.idproject=self.idproject;
                 pf.detailstrarr=self.detailstrarr;
                 pf.menulist=self.menulist;
                 pf.tbindex=self.tbindex;
                 pf.isDevelopment=YES;
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
        }else if (tableView.tag==8) {
            [self contactPm1:indexPath.row];
        } else if (tableView.tag==11) {
            if (indexPath.row==0) {
                if ( result.Sales1) {
                    [self contactSales1];
                }else{
                    [self contactSales2];
                }
                
            }else{
                [self contactSales2];
            }
        }else{
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
                [alert show];
            }else{
                if (tableView.tag==5) {
                    ViewController *si=[ViewController alloc];
                    si.managedObjectContext=self.managedObjectContext;
                    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%d&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], [userInfo getCiaId], idproject];
                    si.menulist=self.menulist;
                    si.detailstrarr=self.detailstrarr;
                    si.tbindex=self.tbindex;
                    si.atitle=@"Site Map";
                    
                    [self.navigationController pushViewController:si animated:NO];
                }else{
                    key =(wcfProjectFile *)[rtnfiles objectAtIndex:indexPath.row];
                    isshow=YES;
//                    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Development File..." delegate:self otherButtonTitles:nil];
//                    
//                    [alertViewWithProgressbar show];
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Download Development File...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    
                    NSString *str;
                    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                    
                    wcfService *service=[wcfService service];
                    str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                         NSASCIIStringEncoding];
                    
                    NSString* escapedUrlString =
                    [[NSString stringWithFormat:@"<view> %@", key.FName] stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                    
                    [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Development File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                    
                    
                }
            }
        }
    }
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




-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}


-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}

-(IBAction)refreshPrject:(id)sender{
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

- (void) xAddUserLogHandler: (BOOL) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Do something with the BOOL result
    NSString *str;
    
    
    
    
    
str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname=%@", key.ID,[[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue], [Mysql md5:key.FSize], [key.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    
    
    
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
            if (data!=nil) {
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
            }else{
                
                HUD.progress=1;
                [HUD hide];
                
                UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
                [a show];
            }
            
            
            
        }
        
    }else{
        turl=url;
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=nil) {
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
        }else{
            
            HUD.progress=1;
            [HUD hide];
            
            UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
            [a show];
        }
        
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
