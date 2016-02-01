//
//  approvesuggest.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "approvesuggest.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "forapprove.h"
#import "disapprovesuggest.h"
#import "CustomKeyboard.h"
#import "wcfSuggestedPriceItem.h"
#import "MBProgressHUD.h"
#import "ViewController.h"

#define MRScreenHeight     CGRectGetWidth([UIScreen mainScreen].applicationFrame)
@interface approvesuggest ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate>{
    UIScrollView *uv;
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
    UIPickerView *ddpicker;
    UITextField *usernameField;
    UITextField *tsqft;
    wcfSuggestedPriceItem *rsp;
    UITextField *a;
    UIButton *btnNext;
    MBProgressHUD *HUD;
    NSTimer *myTimer;
    UITextField *sendtoField;
    
    int y;
    
}


@end

@implementation approvesuggest

@synthesize xidcia, xidproject, idnumber, xnproject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    y = 10;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL) isNumeric:(NSString *)s
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [ntabbar setSelectedItem:nil];
                    break;
                default:{
                    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                    NetworkStatus netStatus = [curReach currentReachabilityStatus];
                    if (netStatus ==NotReachable) {
                        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
                        [alert show];
                    }else{
//                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                        [self.navigationController.view addSubview:HUD];
//                        HUD.labelText=@"Approve suggested price...";
//                        HUD.dimBackground = YES;
//                        HUD.delegate = self;
//                        [HUD show:YES];
                        
                        self.view.userInteractionEnabled=NO;
//                        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                        
//                        [alertViewWithProgressbar show];
//                        alertViewWithProgressbar.progress=1;
                        
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
                        NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        [service xApproveSuggest:self action:@selector(xApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidnumber:idnumber xidproject:xidproject xsqft:xt xsuggestprice:xs EquipmentType:@"5"];
                    }
                }
                    break;
                    
            }
            break;
    }
}

-(void)xApproveSuggestHandler: (id) value {
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
    
    NSString *t =(NSString *)value;
    if ([t isEqualToString:@"1"]) {
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
//           for (UIViewController *temp in self.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[forapprove class]]) {
//                    [self.navigationController popToViewController:temp animated:YES];
//                }
//            }
    }else if([t isEqualToString:@"0"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        UIAlertView *alert = [self getErrorAlert: @"Send Email Unsuccessfully."];
        [alert show];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[forapprove class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = [self getErrorAlert: @"Update Unsuccessfully."];
        [alert show];
    }
}

-(void)targetMethod{
    [myTimer invalidate];
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
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
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        HUD.progress=0.5;
        [service xCheckApproveSuggest:self action:@selector(xCheckApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidproject:xidproject xsqft:tsqft.text xsuggestprice:usernameField.text];
        
    }
}

- (void) xCheckApproveSuggestHandler: (id) value {
   
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
    
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    if ([result.Key isEqualToString:@"0"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:result.Value];
        [alert show];
    }else{
        HUD.progress=1;
        self.view.userInteractionEnabled=YES;
        [HUD hide];

        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:result.Value
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
    }
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
	return YES;
}

- (void)nextClicked{
    [tsqft becomeFirstResponder];
    
}

- (void)previousClicked{
     [usernameField becomeFirstResponder];
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [usernameField resignFirstResponder];
    [tsqft resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Suggest Price"];
    
    
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
    
    
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    
    UILabel*  lbl;
    
    dwidth=dwidth-20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=[NSString stringWithFormat:@"Project # %@", xidproject];
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
   UITextField* proField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [proField setBorderStyle:UITextBorderStyleRoundedRect];
    proField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    proField.text=xnproject;
    proField.enabled=NO;
    proField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: proField];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=@"Send To";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    sendtoField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [sendtoField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [sendtoField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    sendtoField.enabled=NO;
    sendtoField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: sendtoField];
    y=y+30+5;

    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Comment";
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
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwidth-4, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    [txtNote setEditable:NO];
    [uv addSubview:txtNote];
    
    y=y+110;
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"SQ.FT.";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    tsqft=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [tsqft setBorderStyle:UITextBorderStyleRoundedRect];
    tsqft.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [tsqft addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tsqft.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: tsqft];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=@"Suggested Price";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    usernameField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: usernameField];
    y=y+30+5;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Formula Price";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    a=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [a setBorderStyle:UITextBorderStyleRoundedRect];
    a.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    a.autocapitalizationType = UITextAutocapitalizationTypeNone;
    a.enabled=NO;
    [uv addSubview: a];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Sitemap";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
   
    
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [tsqft setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    y=y+5;
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [tsqft setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
    
    if (y<MRScreenHeight) {
        uv.contentSize=CGSizeMake(320.0,MRScreenHeight+1);
    }else{
        uv.contentSize=CGSizeMake(320.0,y+1);
    }

    [self getDetailInfo];
    
}

-(void)orientationChanged{
    [super orientationChanged];
//     int y1 = self.uw.frame.size.height-121;
//    int dwith =self.uw.frame.size.width;
//    UIButton *loginbutton = (UIButton *)[uv viewWithTag:23];
//    [loginbutton setFrame:CGRectMake(10, y1, dwith-20, 44)];
//   
//    y1= y1+54;
//    loginbutton = (UIButton *)[uv viewWithTag:24];
//    [loginbutton setFrame:CGRectMake(10, y1, dwith-20, 44)];
//     [uv setContentSize:CGSizeMake(dwith, self.uw.frame.size.height+1)];
    
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
//    [self orientationChanged];
    [ntabbar setSelectedItem:nil];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


-(void)myFunction{
    
    ViewController *si = [[ViewController alloc] init];
    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/contractsitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], xidcia, rsp.IDSub, xidproject ];
    si.managedObjectContext=self.managedObjectContext;
    si.menulist=self.menulist;
    si.atitle=@"Site Map";
    si.detailstrarr=self.detailstrarr;
    si.tbindex=self.tbindex;
    [self.navigationController pushViewController:si animated:NO];
}

-(void)getDetailInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
        
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetSuggestedPriceForApprove:self action:@selector(xGetSuggestedPriceForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidnumber:idnumber];
    }
    
}

- (void) xGetSuggestedPriceForApproveHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    rsp=(wcfSuggestedPriceItem *)value;
    
    UIImage *img ;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemapthumb.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], xidcia, rsp.IDSub,xidproject]];
    NSLog(@"%@", rsp);
    NSData *data = [NSData dataWithContentsOfURL:url];
     int dwidth=self.uw.frame.size.width-20;
    if (data!=nil) {
        img =[UIImage imageWithData:data];
        if (img!=nil) {
            if (img!=nil) {
                float f = dwidth/img.size.width;
                if (f>1) {
                    f=1;
                }
                //            NSLog(@"%f %f", img.size.width, img.size.height);
                UIImageView *ui =[[UIImageView alloc]initWithFrame:CGRectMake(10, y, img.size.width*f, img.size.height*f)];
                ui.layer.borderWidth = 1.2;
                ui.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
                ui.image=img;
                ui.userInteractionEnabled = YES;
                ui.layer.cornerRadius=10;
                ui.layer.masksToBounds = YES;
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction)];
                tapped.numberOfTapsRequired = 1;
                [ui addGestureRecognizer:tapped];
                y=y+img.size.height*f+40;
                //            ui.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [uv addSubview:ui];
            }
        }
    }
    
    [usernameField setText:rsp.Suggested];
    [tsqft setText:rsp.SQFT];
    [a setText:rsp.FormulaPrice];
    [txtNote setText:rsp.Comment];
    sendtoField.text=rsp.Email;
//   
//    int y = self.uw.frame.size.height-121;
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    loginButton.tag=23;
    [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doApprove:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:loginButton];
    y=y+54;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    loginButton.tag=24;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doDisApprove:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:loginButton];
    y=y+74;
  

    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goForApprove) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshPrject) ];
    
    
    
    [ntabbar setSelectedItem:nil];
    if (y<MRScreenHeight) {
        y=MRScreenHeight;
    }
    
    uv.contentSize=CGSizeMake(uv.frame.size.width, y+1);
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goForApprove];
    }else if(item.tag == 2){
        [self refreshPrject];
    }
}


-(void)goForApprove{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]] ) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(void)refreshPrject{
[self getDetailInfo];
}
-(IBAction)doApprove:(id)sender{
    
    if ([usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input Suggested Price"];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xs]){
        UIAlertView *alert = [self getErrorAlert: @"Suggested Price must be a Number."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
        
    }
    
    if ([tsqft.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input SQ.FT."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
    }
    NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xt]){
        UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
        
    }
    
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.labelText=@"Checking...";
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        [HUD show:YES];
        self.view.userInteractionEnabled=NO;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Checking..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        alertViewWithProgressbar.progress=1;
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Checking...  ";
        
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

-(IBAction)doDisApprove:(id)sender{
    if ([usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input Suggested Price"];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xs]){
        UIAlertView *alert = [self getErrorAlert: @"Suggested Price must be a Number."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
        
    }
    
    if ([tsqft.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input SQ.FT."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
    }
    NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xt]){
        UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
        
    }
    
    disapprovesuggest * s =[disapprovesuggest alloc];
    s.managedObjectContext=self.managedObjectContext;
    s.idnumber=self.idnumber;
    s.xidproject=self.xidproject;
    s.xsqft1=xt;
    s.menulist=self.menulist;
    s.detailstrarr=self.detailstrarr;
    s.tbindex=self.tbindex;
    s.xidcia=self.xidcia;
    s.xsuggestprice1=xs;
    s.xemail=rsp.Email;
    [self.navigationController pushViewController:s animated:NO];

}

-(IBAction)popupscreen2:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
    [actionSheet setTag:1];
    
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }
    
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    
    int y1=0;
    if (self.view.frame.size.height>480) {
        y1=80;
    }
    
    [actionSheet setFrame:CGRectMake(0, 177+y1, 320, 383)];
    
    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,180, 120, 46)];
    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,180, 120, 46)];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    
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
