//
//  forgetps1.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/19/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "forgetps1.h"
#import "CustomKeyboard.h"
#import "Reachability.h"
#import "wcfService.h"
#import "Mysql.h"

@interface forgetps1 ()<CustomKeyboardDelegate, UITextFieldDelegate>{
    UITextField *txtEmail;
    CustomKeyboard *keyboard;
    UIScrollView *sv;
}

@end

@implementation forgetps1

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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    [super viewDidLoad];
	self.title=@"Forgot Password";
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, 40, 40, 40);
    [btnNext addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back.png"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnNext]];
    
    int xw;
    int xh;
    int xx;
    
    
    if (self.view.frame.size.width==768.0f) {
        xx =112;
        
        
        
    }else{
        xx =240;
        
    }
    
    xw= self.view.frame.size.width;
    xh=self.view.frame.size.height;
    
   
    
  
    int x=5;
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, xw,xh)];
    sv.contentSize=CGSizeMake(xw,xh-310);
    [self.view addSubview:sv];
    int y=20;
    
    sv.backgroundColor=[UIColor whiteColor];
    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx, y, 544, 65)];
    lbl.text=@"Please enter the email address you used to create your account, and we will send you a link to reset your password.";
    
    lbl.numberOfLines=0;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [lbl sizeToFit];
    [sv addSubview:lbl];
    y=y+90+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx, y, 544, 21)];
    lbl.text=@"Email";
    [sv addSubview:lbl];
    y=y+21+x;
    
    txtEmail=[[UITextField alloc]initWithFrame:CGRectMake(xx, y, 544, 30)];
    [txtEmail setBorderStyle:UITextBorderStyleRoundedRect];
    [txtEmail addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    txtEmail.delegate=self;
    [sv addSubview: txtEmail];
    y=y+30+x+5;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    txtEmail.inputAccessoryView=[keyboard getToolbarWithDone];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(xx, y+50, 544, 36)];
    [btn1 setTitle:@"Send" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doSend:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn1];
    
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doneClicked{
    [txtEmail resignFirstResponder];
}
- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)doSend:(id)sender {
    
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
        [self sendeamil];
    }
    
    
}

- (void)orientationChanged{
    
   
    int xw;
    int xh;
    int xx;
    
    
    if (self.view.frame.size.width==768.0f) {
        xx =112;
       
        
        
    }else{
        xx =240;
       
    }
    
    xw= self.view.frame.size.width;
    xh=self.view.frame.size.height;
    CGRect f;
    for (UIView *ue in sv.subviews) {
        f=ue.frame;
        f.origin.x=xx;
        ue.frame=f;
    }
    
    sv.contentSize=CGSizeMake(xw, xh+1);
}

- (void)sendeamil {
    NSString *stremail = [Mysql TrimText: txtEmail.text];
	
	if (stremail.length == 0){
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input All Fields"
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
        [txtEmail becomeFirstResponder];
	} else if ([Mysql IsEmail:stremail]==NO) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input invalid email"
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
        [txtEmail becomeFirstResponder];
	}else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        wcfService* service = [wcfService service];
        
        [service xSendGetPasswordMail:self action:@selector(xSendGetPasswordMailHandler:) xemail: stremail EquipmentType:@"5"];
        
	}
    
}

- (void) xSendGetPasswordMailHandler: (id) value {
    
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
    
    
    
	// Do something with the NSString* result
    NSString* categoryid = (NSString*)value;
	
    if ([categoryid isEqualToString:@"-1"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email not found."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([categoryid isEqualToString:@"1"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email can not be send. Please try again."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([categoryid isEqualToString:@"0"]) {
        
        UIAlertView *alert = [self getSuccessAlert:@"We have send a link to reset your password to your email address.\nIf you are having problems receiving this link, please contact Customer Service."];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else{
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Error happened. Please exit and open again."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    
}

-(UIAlertView *)getErrorAlert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:str
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    return alert;
}

-(UIAlertView *)getSuccessAlert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Success"
                          message:str
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    return alert;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
