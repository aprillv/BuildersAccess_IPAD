//
//  contractforapproveupd1.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "contractforapproveupd1.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "contractforapprove.h"
#import "MBProgressHUD.h"
#import "forapprove.h"

@interface contractforapproveupd1 ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    NSTimer *myTimer;
}

@end

@implementation contractforapproveupd1

@synthesize xtype, idcia, idcontract1, projectname, idproject, atitle;

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
	[self setTitle:atitle];
    int dwith = self.uw.frame.size.width;
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, dwith, self.uw.frame.size.height)];
    [self.uw addSubview:uv];
    uv.backgroundColor = [UIColor whiteColor];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
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
    
    
    int x=10;
    int y=10;
    uv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
    uv.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl;
    dwith=dwith-20;
    lbl0 =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwith, 21)];
//    lbl0.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl0.backgroundColor=[UIColor clearColor];
    lbl0.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl0];
    y=y+21+x;
    
    lbl1 =[[UITableView alloc]initWithFrame:CGRectMake(10, y, dwith, 28)];
    lbl1.layer.cornerRadius = 7;
    lbl1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl1.layer.borderWidth = 1.2;
    lbl1.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

    lbl1.rowHeight=28;
    y=y+32+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwith, 21)];
    lbl.text=@"To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField * text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwith, 30)];
    
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
//    text1.layer.borderWidth = 1.2;
//    text1.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.text=@"";
    [uv addSubview: text1];
    
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(18, y+4, dwith-16, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    
    y=y+30+x;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwith, 21)];
    lbl.text=@"Message";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwith, 105)];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwith-4, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
     txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    y=y+110+x;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwith, 36)];
    if (xtype==1) {
        [loginButton setTitle:@"Submit Approve" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
         loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    }else if (xtype==3) {
        [loginButton setTitle:@"Submit Acknowledge" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doacknowledge) forControlEvents:UIControlEventTouchUpInside];
        

    }else{
        [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
          loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    }
    [uv addSubview:loginButton];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(doRefresh) ];
    
    
    [self getemailInfo];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self doRefresh];
    }
}

-(void)doRefresh{
    [self getemailInfo];
}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]] ) {
            [self.navigationController popToViewController:temp animated:NO];
        }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text=projectname;
            cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell .imageView setImage:nil];
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }
    
}


-(IBAction)doapprove:(id)sender{
    
    [self autoUpd:1];
}



-(IBAction)dodisapprove:(id)sender{
    [self autoUpd:2];
    }

-(void)doacknowledge{
 [self autoUpd:3];
}
-(void)autoUpd:(int) xt{
    ctag=xt;
    
    if (ctag==2) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to disapprove?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 2;
        [alert show];
    }  else if (ctag==3) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure you want to acknowledge?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
            alert.tag = 3;
            [alert show];
        
    }else{
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to approve?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
    }

    
    
    
}
- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        HUD.progress=0.5;
        if (ctag == 1){
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                [HUD hide];
                self.view.userInteractionEnabled=YES;
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"5" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"5"];
                
//                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"5" toemail:@"xiujun_85@163.com" msg:txtNote.text EquipmentType:@"5"];
            }
            
            
        }else if (ctag == 2){
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                [HUD hide];
                self.view.userInteractionEnabled=YES;
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"3" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"5"];
            }
        }else if (ctag == 3){
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                [HUD hide];
                self.view.userInteractionEnabled=YES;
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"4" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"5"];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
}

-(void)getemailInfo{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [service xGetContractApproveEmailTo:self action:@selector(xGetContractApproveEmailToHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia:idcia contractid: idcontract1];
        

    }
    
    
}
- (void) xGetContractApproveEmailToHandler: (id) value {
    
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
    
    
	// Do something with the wcfUserCOEmail* result
    result = (wcfKeyValueItem*)value;
	
    
    // [result.Email componentsSeparatedByString:@";"]
    pickerArray =[NSArray arrayWithObjects:result.Key, nil];
    lbl0.text=[NSString stringWithFormat:@"Project # %@", idproject];
    lbl1.delegate=self;
    lbl1.dataSource=self;
    [uv addSubview:lbl1];
    
    [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    if (xtype==1) {
         [txtNote setText:@"I approve the following Contract."];
    }else  if (xtype==3) {
        [txtNote setText:@"I acknowledge the following Contract."];
    }else{
    [txtNote setText:@"I disapprove the following Contract."];
    }
    [ntabbar setSelectedItem:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
    
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex==1) {
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                
//                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                [self.navigationController.view addSubview:HUD];
//                HUD.labelText=@"   Updating...   ";
//                HUD.dimBackground = YES;
//                HUD.delegate = self;
//                [HUD show:YES];
                
                self.view.userInteractionEnabled=NO;
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                
//                [alertViewWithProgressbar show];
//                alertViewWithProgressbar.progress=1;
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Sending Email to Queue...";
                
                HUD.progress=0.01;
                [HUD layoutSubviews];
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];

                
                wcfService* service = [wcfService service];
                NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
            }
            
        }else{
            [ntabbar setSelectedItem:nil];
        }
}

- (void) doupdate: (int) value {
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if(value==0){
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else if(value==1){
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        
    }else{
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
        
        
    }
	
    
}

-(void)targetMethod{
    [myTimer invalidate];
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[contractforapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
    
}

-(IBAction)popupscreen2:(id)sender{
    
 UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Select"
                                                    otherButtonTitles:nil];
    
    [actionSheet setTag:2];
    
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }
    
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle 
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
}

@end
