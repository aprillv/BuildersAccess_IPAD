//
//  forgetPs.m
//  BuildersAccess
//
//  Created by Bin Bob on 7/18/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import "forgetPs.h"
#import "Mysql.h"
#import "wcfService.h"
#import "Reachability.h"

@implementation forgetPs
@synthesize txtEmail;

- (IBAction)doCancel:(id)sender {
	#pragma unused(sender)
	
	[self.navigationController popViewControllerAnimated:YES];
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


- (void)sendeamil {
    NSString *stremail = [Mysql TrimText: self.txtEmail.text];
	
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


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Forgot Password";
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, 40, 40, 40);
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back.png"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnNext]];
    

    
    int x=5;
    UIScrollView *sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    sv.contentSize=CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+1);
    [self.view addSubview:sv];
    int y=20;
    
   
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-40, 65)];
    lbl.text=@"Please enter the email address you used to create your account, and we will send you a link to reset your password.";
    
    lbl.numberOfLines=0;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [lbl sizeToFit];
    [sv addSubview:lbl];
    y=y+90+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-40, 21)];
    lbl.text=@"Email";
    [sv addSubview:lbl];
    y=y+21+x;
    
    txtEmail=[[UITextField alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-40, 30)];
    [txtEmail setBorderStyle:UITextBorderStyleRoundedRect];
    [txtEmail addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    txtEmail.delegate=self;
    [sv addSubview: txtEmail];
    y=y+30+x+5;

    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    txtEmail.inputAccessoryView=[keyboard getToolbarWithDone];

}


- (BOOL)textFieldShouldReturn:(id)sender
{
    UIScrollView *sv =( UIScrollView *)[self.view viewWithTag:1];
    [sv setContentOffset:CGPointMake(0, 0) animated:YES];
    
	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    
    UIScrollView *sv =( UIScrollView *)[self.view viewWithTag:1];
    if (self.view.frame.size.height<500) {
     [sv setContentOffset:CGPointMake(0,15) animated:YES];
    }
    
        
	return YES;
}


-(void)doneClicked{
    [txtEmail resignFirstResponder];
}
- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	txtEmail = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
