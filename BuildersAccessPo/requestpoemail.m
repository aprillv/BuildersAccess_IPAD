
//
//  poemail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "requestpoemail.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "projectpols.h"
#import "forapprove.h"
#import "project.h"
#import "development.h"
#import "MBProgressHUD.h"

@interface requestpoemail ()<MBProgressHUDDelegate>{
    UIButton *dd1;
    UIScrollView *uv;
    UIButton *btnNext;
    MBProgressHUD *HUD;
    NSTimer *myTimer;
    
}

@end

@implementation requestpoemail

@synthesize txtNote, pickerArray, ddpicker, xtype, aemail, idnum;
@synthesize xxdate, xxreason, xxstr, xxtotle, xxnotes, fromforapprove;

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
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    [self.uw addSubview:uv];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    if (fromforapprove==1) {
        [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    }else{
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
    
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    switch (xtype) {
        case 0:
            self.title=@"Acknowledge Requested VPO";
            break;
        case 1:
            self.title=@"Disapprove Requested VPO";
            break;
        case 3:
            self.title=@"Hold Requested VPO";
            break;
   
        default:
            self.title=@"Void Requested VPO";
            break;
    }
    
    
    [self drawpageg];
	
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:nil];
        //            }else if(item.tag == 2){
        //                [self dorefresh:nil];
    }
}



-(void)drawpageg{
    UILabel *lbl;
    int y=10;
    
     int dwidth = self.uw.frame.size.width-20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"To";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame: CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, dwidth-20, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    y=y+25+10;
    [uv addSubview:dd1];
    
       
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Message";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(15, y+3, dwidth-10, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    txtNote.text=@"";
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    switch (xtype) {
        case 0:
        {
            [loginButton setTitle:@"Submit Acknowledge" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [loginButton setTitle:@"Submit Hold" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [loginButton setTitle:@"Submit Void" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
    }
   
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
     uv.contentSize=CGSizeMake(dwidth+20,self.uw.frame.size.height+1);
    
    pickerArray =[[NSMutableArray alloc]init];
    [pickerArray addObject:aemail];
    [dd1 setTitle:aemail forState:UIControlStateNormal];
    
}




-(IBAction)doapprove:(id)sender{
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


-(IBAction)gobig:(id)sender{
    [super gobig:sender];
     uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
      uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
}
-(void)orientationChanged{
    [super orientationChanged];
   uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
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
        NSString *nstatus;
        switch (xtype) {
            case 0:
                nstatus=@"Acknowledge";
                break;
            case 1:
                nstatus=@"Disapprove";
                break;
            case 3:
                nstatus=@"Hold";
                break;
     
            default:
                nstatus=@"Void";
        }
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Are you sure you want to %@?", nstatus]
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        alert.tag = 0;
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0){
	    switch (buttonIndex) {
			case 0:
				break;
			default:
                 [self updatepo];				
				break;
		}
    }else if (alertView.tag == 1){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self updatepo];
				break;
		}
    }
}


-(void)updatepo{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.labelText=@"Updating...";
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    [HUD show:YES];
    self.view.userInteractionEnabled=NO;
//    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//    
//    [alertViewWithProgressbar show];
//    alertViewWithProgressbar.progress=30;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Sending Email to Queue... ";
    
    HUD.progress=0.3;
    [HUD layoutSubviews];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];

    

    NSString *nmsg=[txtNote.text stringByReplacingOccurrencesOfString:@"\n" withString:@";"];
    wcfService *service=[wcfService service];
    switch (xtype) {
        case 0:
            [service xAprroveRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum reason:xxreason xtotal:xxtotle xdate:xxdate xnotes:xxnotes xstr:xxstr emailbody:nmsg EquipmentType:@"5"];
            break;
        case 1:
            [service xDisAprroveRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody: nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"5"];
            break;
        case 3:
            [service xHoldRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody: nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"5"];
            break;
        default:
            [service xVoidRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody:nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"5"];
        break;    }
   
}

- (void) xisupdate_iphoneHandler2: (id) value {
    
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString *rtn =(NSString *)value;
    if ([rtn isEqualToString:@"1"]) {
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
    }else if ([rtn isEqualToString:@"2"]) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        UIAlertView *alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        [self goback1:nil];
    }
    
}
-(void)targetMethod{
    [myTimer invalidate];
    [HUD hide];
    [self goback1:nil];
}

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
            
        }else if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:NO];
            
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        
        }
        
    }
}

- (void)doneClicked{
//     [txtNote resignFirstResponder];
    [txtNote resignFirstResponder];
   
}


-(IBAction)popupscreen2:(id)sender{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    [actionSheet setTag:1];
    actionSheet.delegate=self;
    
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }
    
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:dd1.frame inView:self.uw animated:YES];
    
//    int y=0;
//    if (self.view.frame.size.height>480) {
//        y=80;
//    }
//    
//    [actionSheet setFrame:CGRectMake(0, 177+y, 320, 383)];
//    
//    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,180, 120, 46)];
//    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,180, 120, 46)];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



