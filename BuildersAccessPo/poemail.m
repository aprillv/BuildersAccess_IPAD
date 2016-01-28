//
//  poemail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "poemail.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "projectpols.h"
#import "MBProgressHUD.h"

@interface poemail ()<MBProgressHUDDelegate>{
MBProgressHUD *HUD;
    NSTimer *myTimer;
    NSDateFormatter *formatter;
}

@end

@implementation poemail

@synthesize dd1, txtNote, pickerArray, ddpicker, xtype, idpo1,xmcode, isfromassign, idvendor;

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
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width;
    dheight=cs.height;
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    for (UIView *u in uv.subviews) {
        [u removeFromSuperview];
    }

    
    isreleased=YES;
    isDraftorForapprove=NO;
    oldemail=@"";
    [self getPoDetail];
	
}

-(void)getPoDetail{
    wcfService *service=[wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (isfromassign) {
        [service xGetPODetailForSubmit:self action:@selector(xGetPODetailForSubmitHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xvendorid: idvendor xcode: xmcode EquipmentType: @"5"];
    }else{
        [service xGetPODetailForSubmit:self action:@selector(xGetPODetailForSubmitHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xvendorid: @"" xcode: xmcode EquipmentType: @"5"];
    }
    
}

- (void) xGetPODetailForSubmitHandler: (id) value {
    
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
    
	// Do something with the NSMutableArray* result
    pd = (wcfPODetail*)value;
    
    if([pd.Status isEqualToString:@"Draft"] ||[pd.Status isEqualToString:@"For Approve"]){
        isDraftorForapprove=YES;
    }
    
    if ([pd.Oldvendoremail isEqualToString:@"0"]) {
        oldemail=@"";
    }else{
        oldemail=[pd.Oldvendoremail copy];
    }
    
    if(!isfromassign){
        oldemail=@"";
    }
    
    NSString * btntitle ;
    NSString *btnimg;
    switch (xtype) {
        case 6:
            self.title=@"Re-Open PO";
            btntitle=@"Submit Re-Open";
            btnimg=@"greenButton.png";
            break;
            
        case 0:
        case 4:
            if(![pd.Release isEqualToString:@"1"]){
                self.title=@"Submit For Approve PO";
                btntitle=@"Submit";
                btnimg=@"greenButton.png";
            }else{
                self.title=@"Release PO";
                btntitle=@"Submit Release";
                btnimg=@"greenButton.png";
            }
            break;
        case 3:
            self.title=@"Disapprove PO";
            btntitle=@"Submit Disapprove";
            btnimg=@"redButton.png";
            break;
        case 10:
            self.title=@"Hold PO";
            btntitle=@"Submit Hold";
            btnimg=@"redButton.png";
            break;
        case 7:
            self.title=@"Void PO";
            btntitle=@"Submit Void";
            btnimg=@"redButton.png";
            
            break;
            
    }
    [self drawpage:btntitle andImg:btnimg];
}

-(void)drawpage: (NSString *)btntitle andImg:(NSString *)btnimg{
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width-20;
    dheight=cs.height;

    
    UILabel *lbl;
    int y=10;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=[NSString stringWithFormat:@"%@", pd.Doc];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
//    lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
//    lbl.layer.cornerRadius =5.0;
//    lbl.layer.borderWidth = 1.2;
//    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:lbl];
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, 21)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.text=[NSString stringWithFormat:@"Total: %@", pd.Total];
    [uv addSubview:lbl];
    
    y = y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, dwidth-30, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    y=y+25+10;
    [uv addSubview:dd1];
    
    if (xtype!=7) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Delivery Date";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+30;
        
        text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
        [text1 setBorderStyle:UITextBorderStyleRoundedRect];
        text1.enabled=NO;
        text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        text1.text=@"";
        [uv addSubview: text1];
        
        txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
        [txtDate setFrame:CGRectMake(18, y+4,dwidth-16, 21)];
        txtDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
        [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
        [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
        if ([pd.Delivery isEqualToString:@"01/01/1980"] || pd.Delivery==nil) {
            [txtDate setTitle:@"" forState:UIControlStateNormal];
        }else{
            [txtDate setTitle:pd.Delivery forState:UIControlStateNormal];
        }
        
        [uv addSubview: txtDate];
        y=y+30+10;
        
    }
    
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
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwidth-4, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.delegate=self;
     txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    if (xtype==7) {
        txtNote.text=[NSString stringWithFormat:@"Please disregard %@. It's no longer effective.", pd.Doc];
    }else if (xtype==10) {
        txtNote.text=[NSString stringWithFormat:@"%@. It's on hold.", pd.Doc];
    }else{
        txtNote.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    }
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton setTitle:btntitle forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:btnimg] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    uv.contentSize=CGSizeMake(dwidth+20,dheight+1);
    
    [self getEmaills];
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

-(void)getEmaills{
//    if ((xtype==4 || xtype==0)&& ![pd.Release isEqualToString:@"1"]) {
//        pickerArray =[[NSMutableArray alloc]init];
//        isreleased=NO;
//        [pickerArray addObject:@"Submit For Approve"];
//        [dd1 setTitle:@"Submit For Approve" forState:UIControlStateNormal];
//    }else{
//        
//        wcfService *service =[wcfService service];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//        
//        if (xtype==3) {
//            [service xGetEmailListDisapprove:self action:@selector(xGetEmailListDisapproveHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] poid: idpo1];
//        }else{
//            [service xGetEmailList:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] idvendor:[[NSNumber numberWithLong:pd.Idvendor] stringValue]];
//        }
//    }
    
    if ((xtype==4 || xtype==0)&& ![pd.Release isEqualToString:@"1"]) {
        //        pickerArray =[[NSMutableArray alloc]init];
        //        isreleased=NO;
        //        [pickerArray addObject:@"Submit For Approve"];
        //        [dd1 setTitle:@"Submit For Approve" forState:UIControlStateNormal];
        wcfService *service =[wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==0) {
            [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"1"];
        }else{
            [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"3"];
        }
        
        
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        if (xtype==3) {
            [service xGetEmailListDisapprove:self action:@selector(xGetEmailListDisapproveHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] poid: idpo1];
        }else{
            if (xtype==6 || xtype==4 || xtype==0) {
                if (xtype==0) {
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"1"];
                }else  if (xtype==4) {
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"3"];
                }else{
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"2"];}
            }else {
                [service xGetEmailList:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] idvendor:[[NSNumber numberWithLong:pd.Idvendor] stringValue]];
            }
            
        }
    }

    
}


- (void) xGetEmailListDisapproveHandler: (id) value {
    
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
    
    
    pickerArray =[[NSMutableArray alloc]init];
    if (value) {
        [pickerArray addObject:value];
    }
    if ([pickerArray count]==0) {
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }else{
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
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
    
    if (value) {
        pickerArray =(NSMutableArray*)value;
        if ([pickerArray count]==0) {
            [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
        }else{
            [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
            [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
        }
    }else{
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }
    
}

-(IBAction)doapprove:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSString *nstatus;
        switch (xtype) {
            case 7:
                nstatus=@"Void";
                break;
            case 6:
                nstatus=@"Re-Open";
                break;
            case 3:
                nstatus=@"Disapprove";
                break;
            case 10:
                nstatus=@"Hold";
                break;
            default:
                if(!isreleased){
                    nstatus=@"Submit For Approve";
                    xtype=5;
                }else{
                    nstatus=@"Release";
                    xtype=4;
                }
        }
         UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Are you sure you want to %@ this po?", nstatus]
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
                if (xtype==7) {
                    UIAlertView *alert = nil;
					alert = [[UIAlertView alloc]
							 initWithTitle:@"BuildersAccess"
							 message:@"If record is voided you will not be able to recover it.\nAre you sure you want to void?"
							 delegate:self
							 cancelButtonTitle:@"Cancel"
							 otherButtonTitles:@"OK", nil];
					alert.tag = 1;
					[alert show];
                }else{
                    [self updatepo];
                }
				
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

-(IBAction)popupscreen:(id)sender{
    
    [txtNote resignFirstResponder];
        
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    
    [actionSheet setTag:2];
    actionSheet.delegate=self;

    
    if (pdate ==nil) {
        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 270, 90)];
        pdate.datePickerMode=UIDatePickerModeDate;
        Mysql *msql=[[Mysql alloc]init];
        if ([pd.Delivery rangeOfString:@"1980"].location == NSNotFound) {
            [pdate setDate:[msql dateFromString:pd.Delivery]];
        }
        
    }
    [actionSheet addSubview:pdate];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtDate.frame inView:uv animated:YES];
//    if (self.view.frame.size.height>500) {
//        [actionSheet setFrame:CGRectMake(0, 207, 320, 383)];
//    }else{
//        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
//    }
//    
//    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,236, 120, 46)];
//    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,236, 120, 46)];
    
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.width==1024){
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-205) animated:YES];
    }
    
	return YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)updatepo{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.labelText=@"Updating...";
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    [HUD show:YES];
    
    self.view.userInteractionEnabled=NO;
    if([dd1.titleLabel.text isEqualToString:@"Email not found"] ||[dd1.titleLabel.text isEqualToString:@"Submit For Approve"]){
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Message..." delegate:self otherButtonTitles:nil];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Sending Message...  ";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }else{
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Sending Email to Queue...  ";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }
    
    
//    [alertViewWithProgressbar show];
//    alertViewWithProgressbar.progress=1;
    
	NSString *dl = txtDate.titleLabel.text;
	if ([dl isEqualToString:@""]|| dl==nil) {
		dl = @"01/01/1980";
	}
    
    wcfService *service=[wcfService service];
        if(isfromassign){
            [service xUpdateUserPurchaseOrder:self action:@selector(xUpdateUserPurchaseOrderHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xtype: [[NSNumber numberWithInt:xtype]stringValue] update: @"1" vendorid: idvendor delivery: dl xlgsel:@"" xcode: xmcode EquipmentType: @"5"];
        }else{
    
    [service xUpdateUserPurchaseOrder:self action:@selector(xUpdateUserPurchaseOrderHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xtype: [[NSNumber numberWithInt:xtype]stringValue] update: @"" vendorid: [[NSNumber numberWithInt:pd.Idvendor] stringValue] delivery: dl xlgsel:@"" xcode: xmcode EquipmentType: @"5"];
    
       }
}


- (void) xUpdateUserPurchaseOrderHandler: (id) value {
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
    
    
    if(!value){
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        UIAlertView *alert =[self getErrorAlert:@"Update failed, please try it again later"];
        alert.tag=2;
        [alert show];
    }else{
        HUD.progress=0.5;
        NSString *nmsg=[txtNote.text stringByReplacingOccurrencesOfString:@"\n" withString:@";"];
        wcfService *service=[wcfService service];
        if([dd1.titleLabel.text isEqualToString:@"Email not found"] ||[dd1.titleLabel.text isEqualToString:@"Submit For Approve"]){
            [service xSendMessage:self action:@selector(xSendMessageHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 oldvendoremail: @"" xmsg: nmsg EquipmentType: @"5" xtype: [[NSNumber numberWithInt:xtype] stringValue]];
        }else{
            [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xto: dd1.titleLabel.text oldvendoremail: @"" xmsg: nmsg EquipmentType: @"5" xtype: [[NSNumber numberWithInt:xtype] stringValue]];
            
//             [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xto: @"xiujun_85@163.com" oldvendoremail: @"xiujun_85@163.com" xmsg: nmsg EquipmentType: @"5" xtype: [[NSNumber numberWithInt:xtype] stringValue]];
            
        }
    }
}

- (void) xSendMessageHandler: (BOOL) value {
   
	if (!value) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert=[self getErrorAlert:@"Send message unsuccessfully, please try it again later."];
        [alert show];
    }else{
        HUD.progress=1;
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        bool isgo =NO;
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[projectpols class]]) {
                isgo=YES;
                [self.navigationController popToViewController:temp animated:NO];
            }
        }
        
        if (!isgo) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:NO];
        }

    }
}



- (void) xSendEmailHandler: (BOOL) value {
    
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
      self.view.userInteractionEnabled=YES;
    
    [myTimer invalidate];
    [HUD hide];
    bool isgo =NO;
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[projectpols class]]) {
            isgo=YES;
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
    
    if (!isgo) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:NO];
    }
}



- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
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
    [actionSheet showFromRect:dd1.frame inView:uv animated:YES]; // show from our table view (pops up in the middle of the table)
    
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
    if (actionSheet1.tag==2) {
        if (buttonIndex == 0) {
            if (!formatter) {
                formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM/dd/YYYY"];
            }
            [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
        }
        [uv setContentOffset:CGPointMake(0,0) animated:YES];
        
    }else{
        if (buttonIndex == 0) {
            [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
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
