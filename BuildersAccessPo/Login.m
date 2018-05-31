//
//  Login.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import "Mysql.h"
#import "Login.h"
#import "wcfService.h"
#import "forgetps1.h"
#import "SignUp.h"
#import "cl_cia.h"
#import "cl_project.h"
#import "cl_pin.h"
#import "mainmenu.h"
#import "Reachability.h"
#import "cl_sync.h"
#import "cl_favorite.h"
#import "cl_phone.h"
#import "cl_vendor.h"
#import "cl_reason.h"
#import "ViewController.h"
#import "baControl.h"
#import <QuartzCore/QuartzCore.h>

#define NAVBAR_HEIGHT   44
#define PROMPT_HEIGHT   70
#define DIGIT_SPACING   10
#define DIGIT_WIDTH     61
#define DIGIT_HEIGHT    40
#define MARKER_WIDTH    16
#define MARKER_HEIGHT   16
#define MARKER_X        22
#define MARKER_Y        18
#define MESSAGE_HEIGHT  74
#define FAILED_LCAP     19
#define FAILED_RCAP     19
#define FAILED_HEIGHT   26
#define FAILED_MARGIN   10
#define TEXTFIELD_MARGIN 8
#define SLIDE_DURATION  0.3

@interface Login ()@end





@implementation Login{
//    UISwitch *switchView;
    NSString     *name;
    BOOL transiting;
    BOOL isenter;
    
    NSString* xget;
    UIButton *checkButton;
    BOOL isup;
}
@synthesize usernameField;
@synthesize passwordField;
//@synthesize checkButton;
@synthesize pwd,  ddpicker, pickerArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    //    NSLog(@"%@", _aaa.tintColor);
//    self.title=@"BuildersAccess";
    //    [_aaa setHidden:YES];
    isup=NO;
    
    self.navigationController.navigationBarHidden=YES;
      [self doInitPage];
    
    //    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1.f];
	
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        //NSData *reader = [NSData dataWithContentsOfFile:filePath];
		NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
		self.usernameField.text = [arr objectAtIndex:0];
		self.pwd=[arr objectAtIndex:1];
        name=self.usernameField.text;
        
		self.passwordField.text = @"******";
		self.ischecked=YES;
         [checkButton setImage: [UIImage imageNamed:@"chked.png"] forState:UIControlStateNormal];
//		switchView.on=YES;
    }else{
        self.ischecked=NO;
     [checkButton setImage: [UIImage imageNamed:@"chk.png"] forState:UIControlStateNormal];
    }
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [passwordField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
    usernameField.returnKeyType=UIReturnKeyGo;
    passwordField.returnKeyType=UIReturnKeyGo;
    isenter=YES;
  }

-(void)viewDidAppear:(BOOL)animated{
    if (![[self unlockPasscode] isEqualToString:@"0"] && isenter) {
        [self enterPasscode:nil];
        
    }
    isenter=NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    transiting=NO;
    isup=NO;
    [self orientationChanged];
}


// custom keyboard
- (void)nextClicked{
    [passwordField becomeFirstResponder];
     [self textFieldShouldBeginEditing:passwordField];
}

- (void)previousClicked{
    [usernameField becomeFirstResponder];
     [self textFieldShouldBeginEditing:usernameField];
}

- (void)doneClicked{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if (isup) {
        UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:10];
        [sv setContentOffset:CGPointMake(0,0) animated:YES];
        isup=NO;
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (!isup) {
        UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:10];
        [sv setContentOffset:CGPointMake(0,textField.frame.origin.y-85) animated:YES];
        isup=YES;
    }
    return YES;
}



//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//
//
//
//
//
//    return YES;
//}

- (IBAction)textFieldDoneEditing:(id)sender {
    
	[self login:nil];
}

-(void)doInitPage{
    
    
    
    int x;
    int y;
    int xw;
    int xh;
    int xx;
    if (self.view.bounds.size.width==748.0f) {
        xx =135;
        xw= self.view.bounds.size.height;
        xh=self.view.bounds.size.width+1;
    }else{
        xx =112;
        xw= self.view.bounds.size.width;
        xh=self.view.bounds.size.height+1;
    }
    
    UIView *aaaa=[[UIView alloc]initWithFrame:CGRectMake(0, 0, xw, xh-1)];
    aaaa.backgroundColor=[UIColor whiteColor];
    UIView *v1 =[[UIView alloc]initWithFrame:CGRectMake(10, 0, xw-20, 120)];
    [aaaa addSubview:v1];
    
    UIImageView *iv =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top1.gif"]];
    [v1 addSubview:iv];
    UILabel *tt1 =[[UILabel alloc]initWithFrame:CGRectMake(410, 38, 500, 50)];
//    if ([stitle hasPrefix:@"Future"]) {
//        tt =[[UILabel alloc]initWithFrame:CGRectMake(340, 20, 500, 50)];
//    }
    tt1.text=@"BuildersAccess";
    tt1.font=[UIFont boldSystemFontOfSize:25.0f];
    [v1 addSubview:tt1];
    UIView *v2=[[UIView alloc]initWithFrame:CGRectMake(0, 120, xw, 20)];
    v2.backgroundColor=[UIColor lightGrayColor];
    [aaaa addSubview:v2];
    
    
    v2=[[UIView alloc]initWithFrame:CGRectMake(0, xh-45, xw, 44)];
    v2.backgroundColor=[UIColor lightGrayColor];
    [aaaa addSubview:v2];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, xw-20, 40)];
    lbl.text=@"Copyright © 2016 All Rights Reserved";
    lbl.font=[UIFont systemFontOfSize:14.0f];
//    lbl.textColor = [UIColor darkGrayColor];
//    lbl.backgroundColor=[UIColor clearColor];
    [v2 addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:aaaa];
    
    UIScrollView *v3=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 160, xw, xh-185)];
    [self.view addSubview:v3];
    v3.tag=10;
    UIScrollView *sv=v3;
    
    y=30;
    x=15;
    sv.contentSize=CGSizeMake(xw,xh-183);
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx+320, y, 544, 21)];
    lbl.text=@"Members Login";
    lbl.font=[UIFont boldSystemFontOfSize:18.0];
    [sv addSubview:lbl];
    y=y+61+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx, y, 544, 21)];
    lbl.text=@"Email";
    [sv addSubview:lbl];
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx+400, y, 544, 21)];
    lbl.text=@"Password";
    [sv addSubview:lbl];
    y=y+21+x;
    
    
    UITextField * emailField=[[UITextField alloc]initWithFrame:CGRectMake(xx, y, 350, 40)];
    [emailField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [emailField setBorderStyle:UITextBorderStyleNone];
    //    emailField.layer.cornerRadius=0.0f;
    //    emailField.layer.masksToBounds=YES;
    //    emailField.layer.borderColor=[[UIColor grayColor]CGColor];
    //    emailField.layer.borderWidth= 3.0f;
    emailField.enabled=NO;
    [sv addSubview: emailField];
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(xx+3, y+9, 344, 31)];
    //    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField setBorderStyle:UITextBorderStyleNone];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.keyboardType=UIKeyboardTypeEmailAddress;
    [sv addSubview: usernameField];
    
    
    emailField=[[UITextField alloc]initWithFrame:CGRectMake(xx+400, y, 350, 40)];
    [emailField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [emailField setBorderStyle:UITextBorderStyleNone];
    //    emailField.layer.cornerRadius=0.0f;
    //    emailField.layer.masksToBounds=YES;
    //    emailField.layer.borderColor=[[UIColor grayColor]CGColor];
    //    emailField.layer.borderWidth= 3.0f;
    emailField.enabled=NO;
    [sv addSubview: emailField];
    
    passwordField=[[UITextField alloc]initWithFrame:CGRectMake(xx+403, y+9, 344, 31)];
    //    [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordField setBorderStyle:UITextBorderStyleNone];
    [passwordField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordField setSecureTextEntry:YES];
    [sv addSubview: passwordField];
    y=y+55+x;
    
    //    UITextField *text1=[[UITextField alloc]initWithFrame:CGRectMake(xx, y-3, 350, 44)];
    //    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    //    text1.enabled=NO;
    //    text1.text=@"";
    //    [sv addSubview: text1];
    
    checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame:CGRectMake(xx, y, 50, 40)];
    [checkButton addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventTouchDown];
    [checkButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, -10.0, 5.0, 5.0)];
    
    [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 0.0, 5.0, 5.0)];
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //     [checkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    self.ischecked=YES;
    [checkButton setTitle:@"" forState:UIControlStateNormal];
    [sv addSubview:checkButton];
    
    //    lbl =[[UILabel alloc]initWithFrame:CGRectMake(xx+55, y+8, 120, 21)];
    //    lbl.text=@"Remember Me";
    //    [sv addSubview:lbl];
    
    UIButton *tt=[UIButton buttonWithType:UIButtonTypeCustom];
    [tt setFrame:CGRectMake(xx+45, y, 120, 44)];
    
    [tt setTitleColor: [UIColor blackColor] forState:UIControlStateNormal ];
    //    [tt.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //    [tt.titleLabel setText:@" Remember Me"];
    [tt setTitle:@"Remember Me" forState:UIControlStateNormal];
    [tt addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:tt];
    
    //    switchView= [[UISwitch alloc] initWithFrame:CGRectMake(xx+117, y+4, 100.0f, 28.0f)];
    //    ischecked = NO;
    //    [sv addSubview:switchView];
    //    [switchView addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventValueChanged];
    baControl *bc =[[baControl alloc]init];
    UIButton *btn1 = [bc getButton:[UIColor grayColor] andrect:CGRectMake(0, 0, 150, 44)];
    [btn1 setFrame:CGRectMake(xx+600, y, 150, 44)];
    [btn1 setTitle:@"Login" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn1];
    y=y+43+x;
    
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(xx, y, 180, 44)];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"Forgot Your Password" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(ForgotPasOnclick:) forControlEvents:UIControlEventTouchDown];
        [sv addSubview:btn1];
    
    usernameField.delegate=self;
    passwordField.delegate=self;
}

//-(IBAction)popupscreen2:(id)sender{
//
//    [usernameField resignFirstResponder];
//    [passwordField resignFirstResponder];
//
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
//                                                        cancelButtonTitle:nil
//                                                   destructiveButtonTitle:@"Select"
//                                                        otherButtonTitles:nil];
//
//    [actionSheet setBackgroundColor:[UIColor clearColor]];
//
//    ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,270,90)];
//    ddpicker.delegate = self;
//    pickerArray = [NSArray arrayWithObjects:@"Builder", nil];
//    ddpicker.dataSource = self;
//    ddpicker.showsSelectionIndicator = YES;
//
//
//    [actionSheet addSubview:ddpicker];
//     UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
//   [actionSheet showFromRect:dd1.frame inView:sv animated:NO];
//
//
//
//
//
//
//}

- (void)orientationChanged
{
    int xw;
    int xh;
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
    
    
    if (self.view.bounds.size.width==748.0f) {
        xw= self.view.bounds.size.height;
        xh=self.view.bounds.size.width+1;
        
    }else{
        xw= self.view.bounds.size.width;
        xh=self.view.bounds.size.height+1;
    }
    
    if (self.view.bounds.size.width==1024.0f && usernameField.frame.origin.x!=240) {
        
        for (UIView *uh in sv.subviews) {
            uh.frame=CGRectMake(uh.frame.origin.x+128, uh.frame.origin.y, uh.frame.size.width, uh.frame.size.height);
        }
//        [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0, -(xw-614), 5.0, 5.0)];
//        [checkButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, -(xw-604), 5.0, 5.0)];
        
        
    }else if (self.view.bounds.size.width==768.0f && usernameField.frame.origin.x!=112){
        
        for (UIView *uh in sv.subviews) {
            uh.frame=CGRectMake(uh.frame.origin.x-128, uh.frame.origin.y, uh.frame.size.width, uh.frame.size.height);
        }
//        [checkButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, -(xw-346), 5.0, 5.0)];
//        [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0, -(xw-356), 5.0, 5.0)];
    }
    
    sv.contentSize=CGSizeMake(xw,xh);
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate
{
    return YES;
}




//-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
//    }
//
//}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"save"];
}

- (void)creatFiles: (NSString *)pwd1 {
    
    NSString *user_name = [Mysql TrimText:self.usernameField.text];
    NSString *filePath = [self dataFilePath];
	//NSFileManager *fileManager =[NSFileManager defaultManager];
	if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
		NSError* error;
		[[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
	}
	//NSData *data = (NSData *)[self TrimText:self.usernameField.text];
	//[fileManager createFileAtPath:filePath contents:data attributes:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:user_name];
	[array addObject:pwd1];
    [array writeToFile:filePath atomically:YES];
    
}

- (IBAction) ForgotPasOnclick: (id) sender{
    if (transiting) {
        return;
    }else{
        transiting=YES;
        forgetps1 *fp = [forgetps1 alloc];
        fp.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:fp animated:YES];
    }
}

- (IBAction) SingUpOnclick: (id) sender{
    if (transiting) {
        return;
    }else{
        transiting=YES;
        SignUp *mysignup = [SignUp alloc];
        mysignup.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:mysignup animated:YES];
    }
}


- (IBAction) CheckboxClicked : (id) sender{
    if (!self.ischecked)  {
        
        self.ischecked=YES;
        [checkButton setImage:[UIImage imageNamed:@"chked.png"] forState:UIControlStateNormal];
        
        
        
    }else {
        self.ischecked=NO;
        [checkButton setImage:[UIImage imageNamed:@"chk.png"] forState:UIControlStateNormal];
        
        NSString *filePath = [self dataFilePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            NSError* error;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        }
        
        passwordField.text=@"";
        
        [self deletealldata];
        
        
	}
}


//- (IBAction) CheckboxClicked : (UISwitch *) sender{
//    if (sender.on) {
//		self.ischecked=YES;
//        //		[self.checkButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
//	}else {
//		self.ischecked=NO;
//        //		[self.checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
//        
//        NSString *filePath = [self dataFilePath];
//        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
//            NSError* error;
//            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
//        }
//        
//        passwordField.text=@"";
//        
//        [self deletealldata];
//	}
//}

-(void)deletealldata{
    cl_pin *mf =[[cl_pin alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    [mf deletePin];
    
    cl_project *mp =[[cl_project alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp deletaAllCias];
    
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    [mcia deletaAll];
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms deleteall];
    
    cl_favorite *mt =[[cl_favorite alloc]init];
    mt.managedObjectContext=self.managedObjectContext;
    [mt deletaAllCias];
    
    cl_phone *mpt =[[cl_phone alloc]init];
    mpt.managedObjectContext=self.managedObjectContext;
    [mpt deletaAllCias];
    
    cl_vendor *mpv =[[cl_vendor alloc]init];
    mpv.managedObjectContext=self.managedObjectContext;
    [mpv deletaAllCias];
    
    cl_reason *mpr =[[cl_reason alloc]init];
    mpr.managedObjectContext=self.managedObjectContext;
    [mpr deletaAllCias];
    
}
- (IBAction) login: (UIButton *) sender{
    [self doneClicked];
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"   Login...   ";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [self autoUpd];
}

-(void)autoUpd{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide:YES];
        for (UIWindow* window in [UIApplication sharedApplication].windows) {
            NSArray* subviews = window.subviews;
            if ([subviews count] > 0){
                for (UIAlertView* cc in subviews) {
                    if ([cc isKindOfClass:[UIAlertView class]]) {
                        [cc dismissWithClickedButtonIndex:0 animated:YES];
                        
                    }
                }
            }
            
        }
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
        transiting=NO;
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [service xisupdate_ipad:self action:@selector(xisupdate_ipadHandler:) version:version];
        
    }
}
- (void) xisupdate_ipadHandler: (id) value {
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide:YES];
        
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
        transiting=NO;
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        [HUD hide:YES];
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        transiting=NO;
        return;
    }
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [HUD hide:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self doLogin];
    }
    
    
}
- (void) doLogin{
    if (transiting) {
        return;
    }else{
        transiting=YES;
    }
    
	NSString *user_name = [Mysql TrimText:self.usernameField.text];
    NSString *pass_word = [Mysql TrimText:self.passwordField.text];
	if (user_name.length==0){
        [HUD hide:YES];
		UIAlertView *alert = [self getErrorAlert: @"Please Input All Fields"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
	}else if(pass_word.length==0){
        [HUD hide:YES];
        UIAlertView *alert = [self getErrorAlert: @"Please Input All Fields"];
        [alert show];
		
        [passwordField becomeFirstResponder];
        transiting=NO;
    }else if ([Mysql IsEmail:user_name]==NO) {
        [HUD hide:YES];
        UIAlertView *alert = [self getErrorAlert: @"Please Input invalid email"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
	} else{
        
        NSString *myMD5Pas;
		if (self.pwd != nil && [pass_word isEqualToString:@"******"]==YES) {
			myMD5Pas = pwd;
		} else {
			myMD5Pas = [Mysql md5:pass_word];
		}
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [HUD hide:YES];
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
            transiting=NO;
        }else{
            wcfService* service = [wcfService service];
            
            //            if([self.dd1.titleLabel.text isEqualToString:@"Builder"]){
            //
            //                [service xCheckLogin:self action:@selector(xCheckLoginHandler:) xemail: user_name xpassword: myMD5Pas EquipmentType:@"5"];
            //
            //            }
            [service xCheckLogin:self action:@selector(xCheckLoginHandler:) xemail: user_name xpassword: myMD5Pas EquipmentType:@"5"];
        }
	}
}

- (void) xCheckLoginHandler: (id) value {
    [HUD hide:YES];
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        transiting=NO;
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        transiting=NO;
        return;
    }
    
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    
    if (![result.Key isEqualToString:@"0"]){
        xget=result.Key ;
        NSString *user_name = [Mysql TrimText:self.usernameField.text];
        cl_pin *mp =[[cl_pin alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        int rtn =[mp IsUser:user_name];
        if (rtn==-1){
            [self deletealldata];
            [mp addToXpin:user_name andpincode:@"0"];
        }else if(rtn==0){
            [self deletealldata];
            [mp addToXpin:user_name andpincode:@"0"];
        }
        
        
        NSString *pass_word = [Mysql TrimText:self.passwordField.text];
        NSString *myMD5Pas;
        if (self.pwd != nil && [pass_word isEqualToString:@"******"]==YES) {
            myMD5Pas = pwd;
        } else {
            myMD5Pas = [Mysql md5:pass_word];
        }
        
        if (self.ischecked == YES) {
            
            if (self.pwd == nil) {
                [self creatFiles:myMD5Pas];
            } else if ([pass_word isEqualToString:@"******"]==NO || ![name isEqualToString:user_name]) {
                [self creatFiles:myMD5Pas];
            }
            
            [userInfo setUserName:user_name andPwd:myMD5Pas];
            
            
            [self CancletPin];
            
            
        }else {
            [userInfo setUserName:user_name andPwd:myMD5Pas];
            NSString *filePath = [self dataFilePath];
            if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                NSError* error;
                [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
            }
            
            [self CancletPin];
        }
        
    }else{
        UIAlertView *alert = [self getErrorAlert: @"Email and Password not found"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
        return;
    }
    
}

-(void)CancletPin{
    cl_sync *ms = [[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    if ([ms isFirttimeToSync:@"0" :@"0"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                          message:@"This is the first time, we will sync all companies with your device, this will take some time, Are you sure you want to continue?"
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"Continue", nil];
        alert.tag = 0;
        [alert show];
        
    }else{
        [self gotomainmenu];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
                transiting=NO;
				break;
			default:
                [self getciaList];
                break;
		}
		return;
	}
}

-(void)getciaList {
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"internet"];
        [alert show];
    }else{
        
        //        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Company..." delegate:self otherButtonTitles:nil];
        //
        //        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Company...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetCiaList:self action:@selector(vGetCiaListHandler:) xemail: [userInfo getUserName] xpassword: [[userInfo getUserPwd] copy] EquipmentType:@"5"];
    }
}


- (void) vGetCiaListHandler: (id) value {
    // Handle errors
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray *result1 = (NSMutableArray*)value;
    
    if([result1 isKindOfClass:[wcfArrayOfKeyValueItem class]]){
        
        cl_cia *mcia = [[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        [mcia addToCia:result1];
        
        cl_sync *ms =[[cl_sync alloc]init];
        ms.managedObjectContext=self.managedObjectContext;
        [ms addToSync:@"0" :@"0" :[[NSDate alloc] init]];
    }
    
    HUD.progress= 1;
    [HUD hide];
    
    [self gotomainmenu];
    
}
-(void)gotomainmenu{
    mainmenu *LoginS=[[mainmenu alloc]init];
    LoginS.managedObjectContext=self.managedObjectContext;
    LoginS.xget=xget;
    LoginS.tbindex=-1;
    LoginS.isTwoPart=YES;
    [self.navigationController pushViewController:LoginS animated:YES];
    
    //    ViewController *vc =[[ViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
