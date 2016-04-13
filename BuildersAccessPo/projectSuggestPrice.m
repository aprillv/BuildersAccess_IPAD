//
//  projectSuggestPrice.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectSuggestPrice.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "CustomKeyboard.h"

@interface projectSuggestPrice ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate>{
    UIScrollView *uv;
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
    UIPickerView *ddpicker;
    
    UITextField *usernameField;
    UITextField *tsqft;
    UIButton *btnNext;
    
    MBProgressHUD *HUD;
    NSTimer *myTimer;
}

@end

@implementation projectSuggestPrice

@synthesize idproject, xsqft;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(IBAction)goproject:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
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

-(IBAction)dosubmit:(id)sender{
    
    if ([usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input Suggested Price"];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    if(![self isNumeric:usernameField.text]){
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
    if(![self isNumeric:[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""]]){
        UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
    }
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to submit?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
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
//                        HUD.labelText=@"Submit Price...";
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
                        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                        
                        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
                    }
                }
                    break;

            }
            break;
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
        HUD.progress=0.5;
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        [service xSubmitSuggestPrice:self action:@selector(xSubmitSuggestPriceHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject suggestedPrice:usernameField.text sqft:[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""] comment:txtNote.text toemail:dd1.titleLabel.text EquipmentType:@"5"];
        
    }
}

- (void) xSubmitSuggestPriceHandler: (id) value {
    
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

    
    
	// Do something with the wcfKeyValueItem* result
     
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    if ([result.Key isEqualToString:@"0"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert=[self getErrorAlert:result.Value];
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
[self.navigationController popViewControllerAnimated:NO];
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
//{
//    
//    UIScrollView *uv1=uv;
//    
//    if (self.view.frame.size.height>500) {
//        
//        if (sender == tsqft) {
//            [uv1 setContentOffset:CGPointMake(0,60) animated:YES];
//        }else{
//            [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }else{
//        if (sender == tsqft) {
//            [uv1 setContentOffset:CGPointMake(0,60) animated:YES];
//        }else{
//            [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }
//	return YES;
//}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
//	return YES;
//}

- (void)nextClicked{
    if ([usernameField isFirstResponder]) {
        [tsqft becomeFirstResponder];
    }else if([tsqft isFirstResponder]){
        [txtNote becomeFirstResponder];
    }
    
}

- (void)previousClicked{
    if ([tsqft isFirstResponder]) {
        [usernameField becomeFirstResponder];
    }else if([txtNote isFirstResponder]){
        [tsqft becomeFirstResponder];
    }
}

- (void)doneClicked{
    
    [usernameField resignFirstResponder];
    [tsqft resignFirstResponder];
    [txtNote resignFirstResponder];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goproject: nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Suggest Price"];
    
    
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
    
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goproject:) ];
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    
    dwidth=dwidth-20;
   
    int y=10;
    UILabel*  lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Send To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, dwidth-20, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    y=y+30+10;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Suggested Price";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: usernameField];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"SQ.FT.";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    tsqft=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [tsqft setBorderStyle:UITextBorderStyleRoundedRect];
    tsqft.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: tsqft];
    tsqft.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    tsqft.text=xsqft;
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
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, 98) ];
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
    [uv addSubview:txtNote];
    
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [tsqft setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
    y=y+120;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(10, y, dwidth, 40)];
    btn1.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    btn1.layer.cornerRadius = 8.0f;
//    btn1.layer.borderWidth = 1.0f;
    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [btn1 setTitle:@"Submit Price" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dosubmit:) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn1];
    uv.contentSize=CGSizeMake(dwidth,dheight+1);

    
    [self getEmail];
	// Do any additional setup after loading the view.
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
        [service xGetSuggestedPrice:self action:@selector(xGetSuggestedPriceHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject];
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
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


- (void) xGetSuggestedPriceHandler: (id) value {
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
    
	// Do something with the wcfSuggestedPriceItem* result
    wcfSuggestedPriceItem* result = (wcfSuggestedPriceItem*)value;
    pickerArray =[[result.Email componentsSeparatedByString:@";"]mutableCopy] ;
   
    if ([pickerArray count]>0) {
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    }else{
      [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];   
    }
    
}

-(IBAction)popupscreen2:(id)sender{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Select"
                                                    otherButtonTitles:nil];
    
    [actionSheet setBackgroundColor:[UIColor clearColor]];
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
    [actionSheet showFromRect:dd1.frame inView:uv animated:NO];     
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
