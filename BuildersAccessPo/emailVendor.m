//
//  emailVendor.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-7.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "emailVendor.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "projectpols.h"
#import "development.h"
#import "project.h"
#import "MBProgressHUD.h"
#import "CustomKeyboard.h"
#import "wcfPODetail.h"

@interface emailVendor ()<UITextViewDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate>{
    UIScrollView *uv;
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
//    UIPickerView *ddpicker;
    UIButton *btnNext;

    MBProgressHUD *HUD;
    NSTimer *myTimer;
}

@end

@implementation emailVendor

@synthesize xidvendor, pd, poid, fromforapprove;

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

    
    
    if (fromforapprove==3) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    }else   if (fromforapprove==2){
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    }
   
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];

    [self getEmail];
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1: nil];
    }
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


-(void)getEmail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetEmailList:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] idvendor:[[NSNumber numberWithLong:pd.Idvendor] stringValue]];
    }
}

- (void) xGetEmailListHandler: (id) value {
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
    pickerArray =(NSMutableArray*)value;
    [self drawpage];
    
}

-(void)drawpage{
    NSLog(@"%@", @"april test");
    UILabel *lbl;
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width-20;
    dheight=cs.height;
    
    int y=10;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=[NSString stringWithFormat:@"%@ # %@", pd.Doc, pd.IdDoc];
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    lbl.layer.cornerRadius =5.0;
    lbl.layer.borderWidth = 1.2;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, 24)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.text=[NSString stringWithFormat:@"Total: %@", pd.Total];
    [uv addSubview:lbl];
    
    y = y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=@"To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
      lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, dwidth-20, 21)];
      dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    if ([pickerArray count]==0) {
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }else{
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    }
    y=y+30+10;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Message";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton setTitle:@"Send" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
     uv.contentSize=CGSizeMake(dwidth+20,dheight+1);
}

-(IBAction)sendEmail:(id)sender{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.labelText=@"Sending email...";
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        [HUD show:YES];
        self.view.userInteractionEnabled=NO;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        alertViewWithProgressbar.progress=1;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Sending Email to Queue... ";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
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
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height-+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

- (void) xisupdate_iphoneHandler: (id) value {
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        HUD.progress=0.5;
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: poid xto: dd1.titleLabel.text oldvendoremail: @"" xmsg: txtNote.text EquipmentType: @"3" xtype:  @""];
        
//        [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: poid xto: @"april@buildersaccess.com" oldvendoremail: @"" xmsg: txtNote.text EquipmentType: @"3" xtype:  @""];
        

    }
}

- (void) xSendEmailHandler: (NSString*) value {
    
	if (!value) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"Send email unsuccessfully, please try it again later."];
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
    [HUD hide];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[projectpols class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}

-(IBAction)popupscreen2:(id)sender{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Select"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    for(int i = 0; i< pickerArray.count; i++) {
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:[pickerArray objectAtIndex:i]
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //                                 NSLog(@"Resolving UIAlert Action for tapping OK Button");
                                 [dd1 setTitle:action.title forState:UIControlStateNormal];
                                 [alert dismissViewControllerAnimated:YES  completion:^{
                                     
                                 }];
                                 
                                 
                             }];
        [alert addAction:ok];
    }
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
//                                                    cancelButtonTitle:nil
//                                               destructiveButtonTitle:@"Select"
//                                                    otherButtonTitles:nil];
//    
//    [actionSheet setBackgroundColor:[UIColor clearColor]];
//    [actionSheet setTag:1];
//    actionSheet.delegate=self;
//    if (ddpicker ==nil) {
//        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
//        ddpicker.showsSelectionIndicator = YES;
//        ddpicker.delegate = self;
//        ddpicker.dataSource = self;
//    }
//    
//    [actionSheet addSubview:ddpicker];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showFromRect:dd1.frame inView:uv animated:YES];; // show from our table view (pops up in the middle of the table)
//    
////    int y=0;
////    if (self.view.frame.size.height>480) {
////        y=80;
////    }
////    
////    [actionSheet setFrame:CGRectMake(0, 177+y, 320, 383)];
////    
////    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,180, 120, 46)];
////    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,180, 120, 46)];
    
}

//-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];    
//    
//}

//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//
//-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return [pickerArray count];
//}
//-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [pickerArray objectAtIndex:row];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
