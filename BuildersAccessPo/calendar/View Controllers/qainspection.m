//
//  qainspection.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "qainspection.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "mainmenu.h"
#import "Reachability.h"
#import "qainspectionb.h"
#import "qacalendarViewController.h"
#import "project.h"

@interface qainspection ()

@end

@implementation qainspection

@synthesize idnumber, fromtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)doneClicked{
    [txtNote resignFirstResponder];
}

//-(IBAction)goBack1:(id)sender{
//    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[mainmenu class]]) {
//            [self.navigationController popToViewController:temp animated:NO];
//        }
//        
//    }
//}

-(void)dorefresh{
    [self getdetail];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
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
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack1:)];
    if (fromtype==1) {
        [[ntabbar.items objectAtIndex:0]setTitle:@"Calendar" ];
    }else{
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    [self setTitle:@"Inspection"];
	
    [self getdetail];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1: nil];
    }else if(item.tag == 2) {
        [self dorefresh];
    }
}


-(IBAction)goBack1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[qacalendarViewController class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if([temp isKindOfClass:[project class]]){
        [self.navigationController popToViewController:temp animated:NO];
        }
        
    }
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}
-(void)getdetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service=[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetQAInspection:self action:@selector(doGet:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber EquipmentType:@"5"];
    }
    
}
- (void) doGet: (id) value {
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
    
    int dwidth =self.uw.frame.size.width;
    int dheight = self.uw.frame.size.height;
    
    wcfInspectionqa *result = (wcfInspectionqa*)value;
    if (uv) {
        uv=nil;
    }
        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.contentSize=CGSizeMake(dwidth, dheight+1);
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    [self.uw addSubview:uv];
    UILabel *lbl;
    float rowheight=32.0;
    int y=10;
    dwidth=dwidth-20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Project";    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth, rowheight-8)];
    lbl.text=result.Nproejct;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+rowheight+10;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Inspection";    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth, rowheight-8)];
    lbl.text=result.Inspection;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+rowheight+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Assign To";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, dwidth, rowheight-8)];
    lbl.text=result.AssignTo;
    lbl.backgroundColor=[UIColor clearColor];
      lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=@"Remark (max 512 chars)";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(15, y+5, dwidth-10, 95) ];
    txtNote.font=[UIFont systemFontOfSize:17.0];
     txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.text=[result.Notes stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    UIButton* loginButton;
    if ([result.Ready isEqualToString:@"1"]) {
        loginButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton setTitle:@"Ready" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doReady) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
y=y+50;
    }
        
    if ([result.NotReady isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton setTitle:@"Not Ready" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(donotReady) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
    }
   
        
    [ntabbar setSelectedItem:nil];
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
}

-(void)doReady{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure is ready?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    [alert show];
}

-(void)donotReady{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure is not ready?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 0;
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Minus 10 points will be assigned, Are you sure is not ready?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
                alert.tag = 1;
                [alert show];
            }
                break;
		}
		return;
	}else if (alertView.tag == 1) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                NetworkStatus netStatus = [curReach currentReachabilityStatus];
                if (netStatus ==NotReachable) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
                    [alert show];
                }else{
                    
                    wcfService *service=[wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [service xUpdQANotReady:self action:@selector(donotReady1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"5"];
                }
                
            }
                break;
		}
    }else if (alertView.tag == 2) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                NetworkStatus netStatus = [curReach currentReachabilityStatus];
                if (netStatus ==NotReachable) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
                    [alert show];
                }else{
                    wcfService *service=[wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [service xUpdQAReady:self action:@selector(doReady1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"5"];
                }
                
            }
                break;
		}
    }
}
-(void)doReady1:(id)value{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HUD hide:YES];
    [HUD removeFromSuperview];
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
    
    NSString *rtn = (NSString *)value;
    if ([rtn isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update fail. Please try again later."];
        [alert show];
    }else{
        qainspectionb *qb =[qainspectionb alloc];
        qb.managedObjectContext=self.managedObjectContext;
        qb.tbindex=self.tbindex;
        qb.menulist=self.menulist;
        qb.detailstrarr=self.detailstrarr;
        qb.idnumber=self.idnumber;
        qb.fromtype=fromtype;
        [self.navigationController pushViewController:qb animated:NO];
        
    }
}

-(void)donotReady1:(id)value{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     [HUD hide:YES];
    [HUD removeFromSuperview];
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
    
    NSString *rtn = (NSString *)value;
    if ([rtn isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update fail. Please try again later."];
        [alert show];
    }else{
        [self goBack1:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
