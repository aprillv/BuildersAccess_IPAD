//
//  codisapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "codisapprove.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "calendarforapprove.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "forapprove.h"

@interface codisapprove ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    NSTimer *myTimer;
}

@end

@implementation codisapprove

@synthesize dd1, pickerArray, xemail, xmsg, ddpicker, disapprove, idnumber, calendardata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    int x=10;
    int y=10;
   
    [self setTitle:@"Disapprove" ];
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self getIsTwoPart]) {
        btnNext.frame = CGRectMake(10, 26, 40, 32);
    }else{
        btnNext.frame = CGRectMake(60, 26, 40, 32);
    }
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setImage: [UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [self.navigationBar addSubview:btnNext];
    
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    uv.contentSize=CGSizeMake(dwidth, dheight+1);
    dwidth=dwidth-20;
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField * text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(15, y+4, dwidth-10, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1 setTitle:xemail forState:UIControlStateNormal];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    y=y+30+x;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Message";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwidth-4, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    [txtNote setText:xmsg];
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:txtNote];
    y=y+110+x;
    
    if (disapprove) {
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, dwidth, 36)];
        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
        
        [uv addSubview:loginButton];
    }
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 1){
        [self goBack1];
    }
}


-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}
-(IBAction)dodisapprove:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to disapprove?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
    
}

-(void)orientationChanged{
    [super orientationChanged];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}
- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [HUD hide];
            self.view.userInteractionEnabled=YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            HUD.progress=0.5;
            wcfService *service = [wcfService service];
            
            calendardata =[calendardata stringByAppendingFormat:@",'ToMessage':'%@'}", txtNote.text];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xUpdateCalendarDisApprove1:self action:@selector(xUpdateCalendarApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] calendarData:calendardata xidnumber:self.idnumber EquipmentType:@"5"];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1 && buttonIndex==1){
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
            [alert show];
        }else{
            
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"   Updating...   ";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
            
            self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
//            alertViewWithProgressbar.progress=1;
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

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
    
}

- (void) xUpdateCalendarApproveHandler: (id) value {
    
    NSString *str =(NSString *)value;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if([str isEqualToString:@"0"]){
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else if([str isEqualToString:@"-1"]){
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
        if ([temp isKindOfClass:[calendarforapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}


//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
//	return YES;
//    
//}

-(IBAction)popupscreen2:(id)sender{
    
   
   UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:@"Select"
                                     otherButtonTitles:nil];
    
    [actionSheet setTag:2];
    actionSheet.delegate=self;
    
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
        pickerArray = [NSArray arrayWithObjects:xemail, nil];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:dd1.frame inView:uv animated:YES];
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
