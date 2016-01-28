//
//  reschedule.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "reschedule.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "project.h"

@interface reschedule ()<CustomKeyboardDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>{
    UITabBar *ntabbar;
    UITextView * txtNote;
    CustomKeyboard *keyboard;
    UITextField *tDate;
    UIDatePicker *pdate;
    NSDateFormatter *formatter;
    UIButton* txtDate;
    UIButton *txtReason;
    UIPickerView *ddpicker;
    NSString *selIndex;
    int donext;
    UIScrollView *uv;
    UIButton *btnNext;
    UIButton *btn1;
     UIButton *btn2;
}

@end

@implementation reschedule
@synthesize result, xidproject, ws, xstartd, idmainstep, iscriticalpath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)loadView {
//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.view = view;
//    if (view.frame.size.height>480) {
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 370+84, 320, 50)];
//    }else{
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 366, 320, 50)];
//    }
//    [view addSubview:ntabbar];
//    UITabBarItem *firstItem0 ;
//    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
//       UITabBarItem*    fi =[[UITabBarItem alloc]init];
//   
//    
//    UITabBarItem *f2 =[[UITabBarItem alloc]init];
//    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
//    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
//    
//    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
//    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
//    
//    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
////    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
////    NSLog(@"%@", result);
//}

-(void)dorefresh{
    donext=1;
    [self doupdateCheck];
}

-(void)doupdateCheck{
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        switch (donext) {
            case 1:
                [self getreschedule];
                break;
            case 2:
               
                [self doreschedule];
                break;
            default:
                break;
        }
    }
}
-(void)doreschedule{
    NSString *comment =[txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([[ws.Name substringToIndex:1] isEqualToString:@"*"]) {
        if (comment.length==0) {
            UIAlertView *alert = [self getErrorAlert: @"Please enter a comment."];
            [alert show];
            [txtNote becomeFirstResponder];
            return;
        }
        
        
        
        if ([txtReason.currentTitle isEqualToString:@""]) {
            
            UIAlertView *alert = [self getErrorAlert: @"Please select a reason."];
            [alert show];
            return;
        }
        
        //    If MenuVal(oStages1.MenuNumber, "xdel=1") = False Then Exit Sub
        //    If MyQuestion("Reschedule " & oStages1.title & " will delete all previous activities" & vbCrLf & "Are you sure you want to continue?", MyIcon.warning) = False Then
        //    Me.Close()
        //    End If
        //    If MyQuestion("Are you sure to Reschedule?" & vbCrLf & "All previous data will be restarted.", MyIcon.warning) = True Then
        //    Me.Cursor = Cursors.WaitCursor
        //    oStages1.dstart = oStages1.reschedule
        //    oStages1.stage = Format(oStages1.item, "#") & " - " & oStages1.title
        //    Application.DoEvents()
        //    If oStages1.RunNew() = True Then
        //    saveyn = True
        //    Me.Close()
        //    End If
        //    Me.Cursor = Cursors.Default
        //    End If
        //    NSLog(@"%@",);
        int subI = 0;
        if (idmainstep<10) {
            subI=6;
        }else{
            subI=7;
        }
        
        //    NSLog(@"%@ %@ %@",ws.MilestoneDstart,  [NSString stringWithFormat:@"*%d.000", idmainstep],[ws.Name substringToIndex:1] );
        formatter.dateFormat=@"MM/dd/yy";
        NSDate *mdate = [formatter dateFromString:ws.MilestoneDstart];
        formatter.dateFormat=@"MM/dd/yyyy";
        if ((![ [ws.Name substringToIndex:subI] isEqualToString:[NSString stringWithFormat:@"*%d.000", idmainstep]]) && [[ws.Name substringToIndex:1] isEqualToString:@"*"]) {
            if ([[formatter dateFromString:[txtDate currentTitle]] compare:mdate]==NSOrderedAscending) {
                UIAlertView *alert = [self getErrorAlert2:  [NSString stringWithFormat:@"Reschedule minimun date is %@", ws.MilestoneDstart]];
                [alert show];
                return;
            }
            
            
        }
    }
    
    if (idmainstep==1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                          message:[NSString stringWithFormat:@"Reschedule %@ will delete all previous activities\nAre you sure you want to continue?", ws.Name]
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"Continue", nil];
        alert.tag = 0;
        [alert show];
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:@"Are you sure you want to Submit?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag =1;
        [alert show];
        
    }
}

-(UIAlertView *)getErrorAlert2:(NSString *)str{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:str
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
    NSArray *subViewArray = alertView.subviews;
    for(int x=0;x<[subViewArray count];x++){
        if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]])
        {
            UILabel *label = [subViewArray objectAtIndex:x];
            if (![label.text isEqualToString:@"Error"]) {
                label.textAlignment = NSTextAlignmentLeft;
            }
            
        }
        
    }
    
    
    return alertView;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                               message:@"Are you sure to Reschedule?\nAll previous data will be restarted."
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Continue", nil];
                alert.tag =1;
                [alert show];
            }
                break;
		}
		
}else if (alertView.tag == 1) {
    switch (buttonIndex) {
        case 0:
            break;
        default:{
            
//             NSLog(@"%@", txtDate.currentTitle);
            
            wcfService *service =[wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            //    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
            
            if (iscriticalpath) {
                 [service xSubmitReschedule:self action:@selector(xSubmitRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:ws.Item xidreson:selIndex xnreson:txtReason.currentTitle xredate:txtDate.currentTitle xcomment:[txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] xdays:[NSString stringWithFormat:@"%d", [tDate.text intValue]] EquipmentType:@"5"];
            }else{
            
             [service xSubmitReschedule:self action:@selector(xSubmitRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:ws.Item xidreson:@"" xnreson:@"" xredate:txtDate.currentTitle xcomment:[txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] xdays:@"" EquipmentType:@"5"];}
           
           
            
           
        }
            break;
    }
}
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    tDate.text=[NSString stringWithFormat:@"%d", [tDate.text intValue]];
}
- (void) xSubmitRescheduleHandler: (id) value {
    
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
    
   NSString* result23 = (NSString*)value;
        //    wcfKeyValueItem *ki2=[result objectAtIndex:1];
    if ([result23 isEqualToString:@"-1"]) {
        UIAlertView *alert = [self getErrorAlert: @"Access denied. Contact your administrator to access:\nMenu 1.10 Projects Schedule + Read and Write"];
        [alert show];
    }else  if ([result23 isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update Failed, Please try again later!"];
        [alert show];
    }else  if ([result23 isEqualToString:@"1"]) {
        [self goBack1];
    }else{
        UIAlertView *alert = [self getErrorAlert: result23];
        [alert show];
    }
}


-(void)getreschedule{
    wcfService *service =[wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
    [service xGetReschedule:self action:@selector(xGetRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:ws.Item EquipmentType:@"3"];
}

- (void) xGetRescheduleHandler: (id) value {
    
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
    
    result = (wcfArrayOfKeyValueItem*)value;
    wcfKeyValueItem *ki =[result objectAtIndex:0];
//    wcfKeyValueItem *ki2=[result objectAtIndex:1];
    if ([ki.Key isEqualToString:@"-1"]) {
//        UIAlertView *alert = [self getErrorAlert2: [NSString stringWithFormat:@"%@\n%@ %@",[ki.Value stringByReplacingOccurrencesOfString:@";" withString:@" "], ki2.Key, ki2.Value]];
//        [alert show];
//        return;
        
    }else{
//        reschedule * re=[reschedule alloc];
//        re.xidproject=self.xidproject;
//        re.result=result2;
//        wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
//        
//        
//        
//        
//        if (!formatter) {
//            formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"MM/dd/yy"];
//        }
//        
//        
//        NSDate *destDate= [formatter dateFromString:[event.Dstart substringFromIndex:5]];
//        
//        
//        re.xstartd=destDate;
//        [formatter setDateFormat:@"MM/dd/yyyy"];
//        re.xstart=[formatter stringFromDate:destDate];
//        [formatter setDateFormat:@"MM/dd/yy"];
//        re.managedObjectContext=self.managedObjectContext;
//        [self.navigationController pushViewController:re animated:YES];
        
        wcfKeyValueItem *kv =[result objectAtIndex:0];
        //    NSLog(@"%@", kv);
        [txtReason setTitle:kv.Value forState:UIControlStateNormal];
        [txtDate setTitle:ws.Dstart forState:UIControlStateNormal];
        [txtNote setText:@""];
        [tDate setText:@""];
        
    }
}



-(void)goBack1{
    for (UIViewController *uiview in self.navigationController.viewControllers) {
        if ([uiview isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:uiview animated:NO];
        }
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [result count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    wcfKeyValueItem *kv =[result objectAtIndex:row];
    return kv.Value;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=@"Reschedule";
    
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack1)];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
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
    
	// Do any additional setup after loading the view.
    
    int x=10;
    int y=10;
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.uw addSubview:uv];
    
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"New Requested Date";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth-20, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(20, y+4, dwidth-55, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [txtDate setTitle:ws.Dstart forState:UIControlStateNormal];
    
    [uv addSubview: txtDate];
    y=y+30+10;
    
    if (iscriticalpath) {
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
        lbl.text=@"Reschedule Reason";
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+x;
        
        text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth-20, 30)];
        text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [text1 setBorderStyle:UITextBorderStyleRoundedRect];
        text1.enabled=NO;
        text1.text=@"";
        [uv addSubview: text1];
        
        txtReason=[UIButton buttonWithType: UIButtonTypeCustom];
        [txtReason setFrame:CGRectMake(20, y+4, dwidth-55, 21)];
        
        [txtReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [txtReason addTarget:self action:@selector(popupscreen2) forControlEvents:UIControlEventTouchDown];
        [txtReason setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [txtReason setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
        [txtReason.titleLabel setFont:[UIFont systemFontOfSize:17]];
        wcfKeyValueItem *kv =[result objectAtIndex:0];
        //    NSLog(@"%@", kv);
        [txtReason setTitle:kv.Value forState:UIControlStateNormal];
        
        [uv addSubview: txtReason];
        y=y+30+10;
        
    }
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Comment";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, 296, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    //    if (xtype==7) {
    //        txtNote.text=[NSString stringWithFormat:@"Please disregard %@. It's no longer effective.", pd.Doc];
    //    }else if (xtype==10) {
    //        txtNote.text=[NSString stringWithFormat:@"%@. It's on hold.", pd.Doc];
    //    }else{
    //        txtNote.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    //    }
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    txtNote.text=@"";
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    
    [uv addSubview:txtNote];
    
    y=y+110;
    if (iscriticalpath) {
       
    
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
        lbl.text=@"Days #";
        lbl.backgroundColor=[UIColor clearColor];
        
        [uv addSubview:lbl];
        y=y+21+x;
        
        tDate=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth-20, 30)];
        [tDate setBorderStyle:UITextBorderStyleRoundedRect];
        tDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        tDate.text=@"0";
        tDate.delegate=self;
        tDate.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tDate.keyboardType =UIKeyboardTypeNumberPad;
        [tDate setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
        //    usernameField.returnKeyType=UIReturnKeyDone;
        [uv addSubview: tDate];
        y=y+30+x+25;
       

    }
    
    
    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(10, y, (dwidth-120)/2, 36)];
    [btn1 setTitle:@"Submit" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame:CGRectMake((dwidth-120)/2+110, y, (dwidth-120)/2, 36)];
    [btn2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn2];
    
    
    //    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn1 setFrame:CGRectMake(200, y, 100, 36)];
    //    [btn1 setTitle:@"Sign Up" forState:UIControlStateNormal];
    //    [btn1 addTarget:self action:@selector(SingUpOnclick:) forControlEvents:UIControlEventTouchDown];
    //    [sv addSubview:btn1];
    
    y=y+50+x;
    
    uv.contentSize=CGSizeMake(dwidth,dheight+1);
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *candidate = [[textField text] stringByReplacingCharactersInRange:range withString:string];
//    if (!candidate || [candidate length] < 1 || [candidate isEqualToString:@""])
//    {
//        return YES;
//    }
//    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:candidate];
//    if (!number || [number isEqualToNumber:[NSDecimalNumber notANumber]])
//    {
//        return NO;
//    }
//    return YES;
//}

-(void)previousClicked{
    [txtNote becomeFirstResponder];
}

-(void)nextClicked{
    [tDate becomeFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.view.frame.size.width>768) {
       
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-270) animated:YES];    }
	return YES;
}
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-140) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-54) animated:YES];    }
//	return YES;
//    
//}

-(void)doSubmit{
    donext =2;
    [self doupdateCheck];
    
    
}
-(void)popupscreen2{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    
    [actionSheet setTag:1];
    actionSheet.delegate=self;
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }

    
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtReason.frame inView:uv animated:YES];
    
  
}


-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=uv.contentSize.height+1;
    [uv setContentSize:CGSizeMake(dwidth, dheight)];
    int y = btn1.frame.origin.y;
    [btn1 setFrame:CGRectMake(10, y, (dwidth-120)/2, 36)];
    [btn2 setFrame:CGRectMake((dwidth-120)/2+110, y, (dwidth-120)/2, 36)];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
    int y = btn1.frame.origin.y;
    int dwidth =self.uw.frame.size.width;

    [btn1 setFrame:CGRectMake(10, y, (dwidth-120)/2, 36)];
    [btn2 setFrame:CGRectMake((dwidth-120)/2+110, y, (dwidth-120)/2, 36)];
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    int dwidth =self.uw.frame.size.width;

    btnNext.frame = CGRectMake(60, 26, 40, 32);
    int y = btn1.frame.origin.y;
    [btn1 setFrame:CGRectMake(10, y, (dwidth-120)/2, 36)];
    [btn2 setFrame:CGRectMake((dwidth-120)/2+110, y, (dwidth-120)/2, 36)];
}

-(void)popupscreen{
    
    [txtNote resignFirstResponder];
    
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-180) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-90) animated:YES];
//    }
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    
    [actionSheet setTag:2];
    actionSheet.delegate=self;
    if (pdate ==nil) {
        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 270, 90)];
        pdate.datePickerMode=UIDatePickerModeDate;
        [pdate setDate:xstartd];
    }
    
    [actionSheet addSubview:pdate];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtDate.frame inView:uv animated:YES];
    
    
   
}


-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        switch (actionSheet1.tag) {
            case 1:
            {
                wcfKeyValueItem *ki =[result objectAtIndex:[ddpicker selectedRowInComponent:0]];
                txtReason.titleLabel.text=ki.Value;
                selIndex=ki.Key;
            }
                break;
            default:
                if (!formatter) {
                    formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"MM/dd/yyyy"];
                }
                
                NSString * str=[formatter stringFromDate:[pdate date] ];
                [txtDate setTitle:str forState:UIControlStateNormal];
                break;
        }
        
        //        @autoreleasepool {
        //            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //            [formatter setDateFormat:@"MM/dd/YY"];
        //            NSString * str=[formatter stringFromDate:[pdate date] ];
        //            [self dochangeCheck: str];
        //        }
       
        
    }
    
    
}

-(void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
    [tDate resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
