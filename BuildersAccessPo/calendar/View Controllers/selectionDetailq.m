//
//  selectionDetailq.m
//  BuildersAccess
//
//  Created by roberto ramirez on 1/3/14.
//  Copyright (c) 2014 eloveit. All rights reserved.
//
#define NAVBAR_HEIGHT 44


#import "selectionDetailq.h"
#import "MTPopupWindowCloseButton.h"
#import "CustomKeyboard.h"
#import "wcfCalendarEntryItem.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"

@interface selectionDetailq ()<UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate,UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate, CustomKeyboardDelegate>

@end


@implementation selectionDetailq{
    UIView* contentView;
    
    UITextField *txtSubject;
    UITextField *txtLocation;
    UITextField *txtContractNm;
    UITextField *txtPhone;
    UITextField *txtMobile;
    UITextField *txtemail;
    UIButton *txtDate;
    UIButton *txtStart;
    UIButton *txtEnd;
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    
    UIActionSheet* actionSheet;
    NSArray * pickerArrayStart;
    NSArray * pickerArrayEnd;
    
    UIDatePicker *pdate;
    UIPickerView *pstart;
    UIPickerView *pend;
    wcfCalendarEntryItem* result;
    MBProgressHUD *HUD;
    UIButton *loginButton1;
    UIButton *loginButton;
    int donext;
}
@synthesize idnumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
         self.modalPresentationStyle = UIModalPresentationFullScreen;
        
    }
    return self;
}


-(void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, NAVBAR_HEIGHT)];
        navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        navigationBar.items = @[self.navigationItem];
    [[navigationBar.items objectAtIndex:0] setTitle:@"Calendar Event"];
        [view addSubview:navigationBar];
    
    MTPopupWindowCloseButton *btn = [[MTPopupWindowCloseButton alloc]initWithFrame:CGRectMake(600, 4, 36, 36)];

    [btn addTarget:self action:@selector(doclose:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, view.bounds.size.width, view.bounds.size.height-NAVBAR_HEIGHT)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [view addSubview:contentView];
    
   
    self.view = view;
}


-(IBAction)doclose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self drawpage];
    [self getInfofromService];
}

-(void)drawpage{
    int y = 5;
    int dwidth =contentView.frame.size.width-20;
    
    UIView * uv =contentView;
    int x=0;
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth, 21)];
    lbl.text=@"Subject";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtSubject=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth-20, 30)];
    [txtSubject setBorderStyle:UITextBorderStyleRoundedRect];
    txtSubject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtSubject .delegate=self;
    txtSubject.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtSubject];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Location";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(500, y, 210, 21)];
    lbl.text=@"Date";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    
    y=y+21+x;
    
    txtLocation=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth*.75, 30)];
    [txtLocation setBorderStyle:UITextBorderStyleRoundedRect];
    txtLocation.delegate=self;
    txtLocation.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtLocation.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtLocation];
//    y=y+30+x+5;
    
   
    
    UITextField * text1;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(500,  y, 228, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(505,  y+5, 218, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    txtDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [uv addSubview: txtDate];
    y=y+30+x+5;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Contact Name";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(500, y, 200, 21)];
    lbl.text=@"Start Time";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    y=y+21+x;
    
    txtContractNm=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth*.75, 30)];
    [txtContractNm setBorderStyle:UITextBorderStyleRoundedRect];
    txtContractNm.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtContractNm.delegate=self;
    txtContractNm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtContractNm];
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(500, y, 228, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview: text1];
    
    txtStart=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtStart setFrame:CGRectMake(505, y+4, 218, 21)];
    [txtStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtStart addTarget:self action:@selector(popupscreen1:) forControlEvents:UIControlEventTouchDown];
    [txtStart setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtStart setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtStart.titleLabel setFont:[UIFont systemFontOfSize:17]];
    txtDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview: txtStart];
    
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 200, 21)];
    lbl.text=@"Phone";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(260, y, 200, 21)];
    lbl.text=@"Mobile";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(500, y, 200, 21)];
    lbl.text=@"End Time";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];

    
    
    y=y+21+x;
    
    txtPhone=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 305, 30)];
    [txtPhone setBorderStyle:UITextBorderStyleRoundedRect];
    txtPhone.delegate=self;
    txtPhone.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtPhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtPhone];
    
    txtMobile=[[UITextField alloc]initWithFrame:CGRectMake(260, y, 305, 30)];
    [txtMobile setBorderStyle:UITextBorderStyleRoundedRect];
    txtMobile.delegate=self;
    txtMobile.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtMobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtMobile];
    
    
    
    text1=[[UITextField alloc]initWithFrame:CGRectMake(500, y, 228, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview: text1];
    
    txtEnd=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtEnd setFrame:CGRectMake(505, y+4, 218, 21)];
    txtEnd.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtEnd addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [txtEnd setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtEnd setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtEnd.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [uv addSubview: txtEnd];
    
    y=y+30+x+5;
        
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Email";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtemail=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth*.75, 30)];
    [txtemail setBorderStyle:UITextBorderStyleRoundedRect];
    txtemail.delegate=self;
    txtemail.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtemail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtemail];
    y=y+30+x+5;
    
    
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Notes";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth-20, 75)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(22, y+3, dwidth-24, 68) ];
    txtNote.layer.cornerRadius=10;
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    [uv addSubview:txtNote];
    y=y+80+15;

    
    
    
  
    loginButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton1 setFrame:CGRectMake(20, y, 290, 44)];
    [loginButton1 setTitle:@"Save" forState:UIControlStateNormal];
    [loginButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton1 setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton1 addTarget:self action:@selector(dosave:) forControlEvents:UIControlEventTouchUpInside];
//    [uv addSubview:loginButton1];
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(340, y, 290, 44)];
    [loginButton setTitle:@"Delete" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton addTarget:self action:@selector(dodelete:) forControlEvents:UIControlEventTouchUpInside];
//    [uv addSubview:loginButton];
    y=y+54;
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtSubject setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [txtLocation setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtContractNm setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtPhone setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtMobile setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtemail setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
    
}

-(void)getInfofromService{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetSelectionCalendarEntry:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber: idnumber EquipmentType: @"3"];
        
    }
}

- (void) xGetCalendarEntryHandler: (id) value {
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
    
    result = (wcfCalendarEntryItem*)value;
    txtSubject.text=result.Subject;
    if (result.Location ==nil) {
        result.Location=@"";
    }
    if (result.DailyCharge==nil) {
        result.DailyCharge=@"";
    }
    txtLocation.text=result.Location;
    
    if (![result.TDate isEqualToString:@"01/01/1980"]) {
        [txtDate setTitle:result.TDate forState:UIControlStateNormal];
        //        [txtDate.titleLabel setText:result.TDate];
        //        NSLog(@"%@", result.TDate);
    }else{
        [txtDate setTitle:@"" forState:UIControlStateNormal];
    }
    result.StartTime=  [result.StartTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result.EndTime=  [result.EndTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [txtStart setTitle:result.StartTime forState:UIControlStateNormal];
    
    [txtEnd setTitle:result.EndTime forState:UIControlStateNormal];
    
    [txtContractNm setText: result.ContactName];
    if (![result.Phone isEqualToString:@"(null)"]) {
        [txtPhone setText:result.Phone];
    }
    
    txtMobile.text= result.Mobile;
    txtemail.text=result.Email;
    txtNote.text=result.Notes;
    
    if (result.MApprove) {
        [contentView addSubview:loginButton1];
        [contentView addSubview:loginButton];
        
    }
    //    [ntabbar setSelectedItem:nil];
}


-(void)doRefresh{
    [self getInfofromService];
}

//-(void)goBack1{
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ( [temp isKindOfClass:[forapprove class]]) {
//            [self.navigationController popToViewController:temp animated:NO];
//        }
//    }
//}


-(IBAction)dosave:(id)sender{
    if ([[Mysql TrimText:txtSubject.text]isEqualToString:@""]) {
        UIAlertView *alert =[self getErrorAlert:@"Please enter Subject."];
        [alert show];
        [txtSubject becomeFirstResponder];
        return;
    }
    donext=1;
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to save?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
}

- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        [HUD hide:YES];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide:YES];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [HUD hide:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        if (donext==1) {
            NSString *para;
            if (!txtLocation.text) {
                txtLocation.text=@"";
            }
            if (!txtContractNm.text) {
                txtContractNm.text=@"";
            }
            if (!txtPhone.text) {
                txtPhone.text=@"";
            }
            if (!txtMobile.text) {
                txtMobile.text=@"";
            }
            if (!txtNote.text) {
                txtNote.text=@"";
            }
            if (!txtemail.text) {
                txtemail.text=@"";
            }
            
            if (!txtMobile.text) {
                txtMobile.text=@"";
            }
            
            
            para = [NSString stringWithFormat:@"{'Subject':'%@','Location':'%@','ContactName':'%@','Phone':'%@','Mobile':'%@','Notes':'%@','TDate':'%@','StartTime':'%@','EndTime':'%@', 'Email':'%@', 'MEvent':'%@', 'DailyCharge':'%@'}", txtSubject.text, txtLocation.text, txtContractNm.text, txtPhone.text, txtMobile.text, txtNote.text, txtDate.titleLabel.text, txtStart.titleLabel.text, txtEnd.titleLabel.text, txtemail.text ,result.MEvent, result.DailyCharge];
            
            
            wcfService *service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xSaveSelectionCalendar:self action:@selector(xUpdateCalendarApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] calendarData:para xidnumber:idnumber EquipmentType:@"5"];
        }else{
            wcfService *service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xDeleteSelectionCalendar:self action:@selector(xUpdateCalendarApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:idnumber EquipmentType:@"3"];
        }
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ((alertView.tag == 3 || alertView.tag==1) && buttonIndex==1){
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
                [alert show];
            }else{
                
                HUD = [[MBProgressHUD alloc] initWithView:contentView];
                [contentView addSubview:HUD];
                
                if (donext==1) {
                    HUD.labelText=@"   Saving...   ";
                }else{
                    HUD.labelText=@"   Deleting...   ";
                }
                
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                
                wcfService* service = [wcfService service];
                NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
            }
        }
    }else if(alertView.tag==2 && buttonIndex==1){
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"If record is deleted you will not be able to recover it.\nAre you sure you want to delete?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 3;
        [alert show];
    }else{
        //        [ntabbar setSelectedItem:nil];
    }
    
    
}
-(void)xdelteKirbyTitleHandler:(id)value3{
    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    wcfKeyValueItem* result1 = (wcfKeyValueItem*)value3;
    if ([result1.Key isEqualToString:@"-1"]) {
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:result1.Value];
        [alert show];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) xUpdateCalendarApproveHandler: (id) value3 {
    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSString* result1 = (NSString*)value3;
    //    NSLog(@"%@", result1);
    if ([result1 isEqualToString:@"1"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
    }else if([result1 isEqualToString:@"-1"] || [result1 isEqualToString:@"0"]){
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else{
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:result1];
        [alert show];
        
    }
}


-(IBAction)dodelete:(id)sender{
//    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
//    passcodeViewController.delegate = self;
//    passcodeViewController.passcode = [self unlockPasscode];
//    passcodeViewController.simple = YES;
//     [self presentViewController:passcodeViewController animated:YES completion:nil];
//    
    donext=2;
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to delete?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 2;
    [alert show];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==pend) {
        return [pickerArrayEnd count];
    }else{
        return [pickerArrayStart count];}
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView==pend) {
        return [pickerArrayEnd objectAtIndex:row];
    }else{
        return [pickerArrayStart objectAtIndex:row];
    }
}

-(IBAction)popupscreen:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    //     [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-180) animated:YES];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:@"Select"
                                     otherButtonTitles:nil];
    
    
    
    [actionSheet setTag:1];
    
    if (pdate ==nil) {
        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 270, 90)];
        pdate.datePickerMode=UIDatePickerModeDate;
        Mysql *msql=[[Mysql alloc]init];
        if ([txtDate.titleLabel.text isEqualToString:@""]) {
            [pdate setDate:[[NSDate alloc] init]];
        }else{
            
            [pdate setDate:[msql dateFromString:txtDate.titleLabel.text]];
        }
        
    }
    [actionSheet addSubview:pdate];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate=self;
    [actionSheet showFromRect:txtDate.frame inView:contentView animated:NO];
    
}


-(void)orientationChanged{
    //    [super orientationChanged];
    //
    //
    //    int y = txtNote.frame.origin.y +210;
    //    if (y<self.uw.frame.size.height+1) {
    //        y=self.uw.frame.size.height+1;
    //    }
    //    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
}

//-(IBAction)gosmall:(id)sender{
//    [super gosmall:sender];
//    int y = txtNote.frame.origin.y +210;
//    if (y<self.uw.frame.size.height+1) {
//        y=self.uw.frame.size.height+1;
//    }
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
//    btnNext.frame = CGRectMake(10, 26, 40, 32);
//}
//-(IBAction)gobig:(id)sender{
//    [super gobig:sender];
//    int y = txtNote.frame.origin.y +210;
//    if (y<self.uw.frame.size.height+1) {
//        y=self.uw.frame.size.height+1;
//    }
//    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
//    btnNext.frame = CGRectMake(60, 26, 40, 32);
//}

-(IBAction)popupscreen1:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
    
    actionSheet=nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:@"Select"
                                     otherButtonTitles:nil];
    [actionSheet setTag:2];
    actionSheet.delegate=self;
    if (pstart ==nil) {
        pstart = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        pstart.showsSelectionIndicator = YES;
        
        pstart.delegate = self;
        pstart.dataSource = self;
        if (pickerArrayStart ==nil) {
            pickerArrayStart = [NSArray arrayWithObjects: @"06:00 AM", @"06:30 AM", @"07:00 AM", @"07:30 AM", @"08:00 AM", @"08:30 AM", @"09:00 AM", @"09:30 AM", @"10:00 AM", @"10:30 AM", @"11:00 AM", @"11:30 AM", @"12:00 PM", @"12:30 PM", @"01:00 PM", @"01:30 PM", @"02:00 PM", @"02:30 PM", @"03:00 PM", @"03:30 PM", @"04:00 PM", @"04:30 PM", @"05:00 PM", @"05:30 PM", @"06:00 PM", @"06:30 PM", @"07:00 PM", @"07:30 PM", @"08:00 PM", @"08:30 PM", @"09:00 PM", nil];
            int j =0;
            for (int i=0; i<[pickerArrayStart count]; i++) {
                
                if ([result.StartTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
                    j=i;
                    [pstart selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
            NSMutableArray *t = [[NSMutableArray alloc]init];
            for (int i=j; i<[pickerArrayStart count]; i++) {
                [t addObject:[pickerArrayStart objectAtIndex:i]];
            }
            pickerArrayEnd=t;
        }
        
        
    }
    
    [actionSheet addSubview:pstart];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtStart.frame inView:contentView animated:NO];
}

-(IBAction)popupscreen2:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
    actionSheet=nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:@"Select"
                                     otherButtonTitles:nil];
    [actionSheet setTag:3];
    actionSheet.delegate=self;
    if (pend ==nil) {
        pend = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        pend.showsSelectionIndicator = YES;
        
        
        if (pickerArrayStart ==nil) {
            pickerArrayStart = [NSArray arrayWithObjects: @"06:00 AM", @"06:30 AM", @"07:00 AM", @"07:30 AM", @"08:00 AM", @"08:30 AM", @"09:00 AM", @"09:30 AM", @"10:00 AM", @"10:30 AM", @"11:00 AM", @"11:30 AM", @"12:00 PM", @"12:30 PM", @"01:00 PM", @"01:30 PM", @"02:00 PM", @"02:30 PM", @"03:00 PM", @"03:30 PM", @"04:00 PM", @"04:30 PM", @"05:00 PM", @"05:30 PM", @"06:00 PM", @"06:30 PM", @"07:00 PM", @"07:30 PM", @"08:00 PM", @"08:30 PM", @"09:00 PM", nil];
            int j =0;
            for (int i=0; i<[pickerArrayStart count]; i++) {
                
                if ([result.StartTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
                    j=i;
                    [pstart selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
            NSMutableArray *t = [[NSMutableArray alloc]init];
            for (int i=j; i<[pickerArrayStart count]; i++) {
                [t addObject:[pickerArrayStart objectAtIndex:i]];
            }
            pickerArrayEnd=t;
            
        }
        
        pend.delegate = self;
        pend.dataSource = self;
        
        
    }
    
    for (int i=0; i<[pickerArrayStart count]; i++) {
        if ([result.EndTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
            [pend selectRow:i inComponent:0 animated:YES];
        }
    }
    
    
    [actionSheet addSubview:pend];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtEnd.frame inView:contentView animated:NO];
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        switch (actionSheet1.tag) {
            case 1:{
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM/dd/YYYY"];
                
                [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];}
                break;
                
            case 2:{
                [txtStart setTitle:[pickerArrayStart objectAtIndex: [pstart selectedRowInComponent:0]] forState:UIControlStateNormal];
                NSMutableArray *t = [[NSMutableArray alloc]init];
                for (int j=[pstart selectedRowInComponent:0]; j<[pickerArrayStart count]; j++) {
                    [t addObject:[pickerArrayStart objectAtIndex:j]];
                }
                pickerArrayEnd=nil;
                pickerArrayEnd=t;
                [pend reloadAllComponents];
                if (![pickerArrayEnd containsObject:txtEnd.currentTitle]) {
                    [txtEnd setTitle:[pickerArrayEnd objectAtIndex: 0] forState:UIControlStateNormal];
                }
                break;
            }
            default:
                [txtEnd setTitle:[pickerArrayEnd objectAtIndex: [pend selectedRowInComponent:0]] forState:UIControlStateNormal];
                break;
        }
    }
}
- (void)doneClicked {
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
//    [contentView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)previousClicked{
    if([txtLocation isFirstResponder]){
        [txtSubject becomeFirstResponder];
    }else if([txtContractNm isFirstResponder]){
        [txtLocation becomeFirstResponder];
    }else if([txtPhone isFirstResponder]){
        [txtContractNm becomeFirstResponder];
    }else if([txtMobile isFirstResponder]){
        [txtPhone becomeFirstResponder];
    }else if([txtemail isFirstResponder]){
        [txtMobile becomeFirstResponder];
    }else if ([txtNote isFirstResponder]){
        
        [txtemail becomeFirstResponder];
        
    }else{
        [txtemail becomeFirstResponder];
    }
}
-(void)nextClicked{
    if([txtSubject isFirstResponder]){
        [txtLocation becomeFirstResponder];
    }else if([txtLocation isFirstResponder]){
        [txtContractNm becomeFirstResponder];
    }else if([txtContractNm isFirstResponder]){
        [txtPhone becomeFirstResponder];
    }else if([txtPhone isFirstResponder]){
        [txtMobile becomeFirstResponder];
    }else if([txtMobile isFirstResponder]){
        [txtemail becomeFirstResponder];
    }else if([txtemail isFirstResponder]){
        
        [txtNote becomeFirstResponder];
        
    }else{
        [txtNote becomeFirstResponder];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0, 0) animated:YES];
//        
//    }
	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    if (self.view.frame.size.width==1024){
//        if (sender != txtSubject && sender!=txtLocation ) {
//            [uv setContentOffset:CGPointMake(0,sender.frame.origin.y-278) animated:YES];
//        }else {
//            [uv setContentOffset:CGPointMake(0,0) animated:YES];
//        }
    }else{
        if (sender==txtemail) {
//            [uv setContentOffset:CGPointMake(0,sender.frame.origin.y-622) animated:YES];
        }
    }
    return YES;
}


- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if (self.view.frame.size.width==1024){
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-236) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-580) animated:YES];
//    }
    
	return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
