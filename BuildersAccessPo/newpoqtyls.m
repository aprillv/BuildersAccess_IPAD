//
//  newpoqtyls.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "newpoqtyls.h"
#import "Mysql.h"
#import "wcfService.h"
#import "userInfo.h"
#import "cl_reason.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "project.h"
#import "development.h"
#import "MBProgressHUD.h"

@interface newpoqtyls ()<MBProgressHUDDelegate>{
MBProgressHUD* HUD;
}

@end

@implementation newpoqtyls

@synthesize xnvendor, xidreason, xnreason, xidproject, xidvendor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)doAttatch:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:nil
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"New Photo",@"Choose from Library", nil];
    alert.tag = 1;
    [alert show];
}

- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
    UIScrollView *uv1=uv;
    [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    
    if (self.view.frame.size.width==1024 && sender == txtTotal) {
        [uv setContentOffset:CGPointMake(0,42) animated:YES];
    }
	return YES;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1: nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Submit VPO"];
    
    
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
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
   
    uv.backgroundColor=[UIColor whiteColor];
    UILabel *lbl;
    
   int  y=10;
    dwidth=dwidth-20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Email To";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
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
    dd1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    
    [uv addSubview:dd1];
    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Delivery Date";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(15, y+4, dwidth-20, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    txtDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [txtDate setTitle:[Mysql stringFromDate2:[NSDate date]] forState:UIControlStateNormal];
    [uv addSubview: txtDate];
    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes (255 char)";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
//    txtNote.delegate=self;
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [uv addSubview:txtNote];
    y=y+110;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Total $";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    txtTotal=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [txtTotal setBorderStyle:UITextBorderStyleRoundedRect];
    [txtTotal addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    txtTotal.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtTotal.delegate=self;
    txtTotal.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview: txtTotal];
    y=y+30+20;
    
    
    
    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(10, y, dwidth, 44)];
    [btn1 setTitle:@"Attatch Picture" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doAttatch:) forControlEvents:UIControlEventTouchDown];
    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:btn1];
    y=y+50;
    
    loginButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
    loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [loginButton setTitle:@"Submit" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    uv.contentSize=CGSizeMake(dwidth+20,dheight+1);
    [txtTotal setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
    

    
    [self getEmail];
	// Do any additional setup after loading the view.
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height+1;
    int y=loginButton.frame.origin.y+104;
    if (y<dheight) {
        y=dheight;
    }
    [uv setContentSize:CGSizeMake(dwidth, y)];}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    int y=loginButton.frame.origin.y+104;
    if (y<self.uw.frame.size.height+1) {
        y=self.uw.frame.size.height+1;
    }
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    int y=loginButton.frame.origin.y+104;
    if (y<self.uw.frame.size.height+1) {
        y=self.uw.frame.size.height+1;
    }
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


-(void)getEmail{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetNewPoVendorEmail:self action:@selector(xGetNewPoVendorEmailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidvendor:xidvendor EquipmentType:@"5"];
    }
    
}


-(void)xGetNewPoVendorEmailHandler: (id) value {
    // Handle errors
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
    
    pickerArray = value;
    
    if ([pickerArray count]>0) {
        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    }else{
        [dd1 setTitle:@"Email Not Found" forState:UIControlStateNormal];
    }
}


-(IBAction)doupdate1:(id)sender{
        
    NSString *tnote = [txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tnote isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please input Notes."];
        [alert show];
        [txtNote becomeFirstResponder];
        return;
    }    
    NSString *ttotal =[txtTotal.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([ttotal isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please input Total."];
        [alert show];
        [txtTotal becomeFirstResponder];
        return;
    }
    
    
    if (![self isNumeric:ttotal]) {
        
        UIAlertView *alert = [self getErrorAlert: @"Total must be a number."];
        [alert show];
        [txtTotal setText:@""];
        return;
    }
    
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to save?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self dosubmit];
				break;
		}
    }else if(alertView.tag==1){
        switch (buttonIndex) {
            case 2:
            {                UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc]init];
                m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                m_imagePicker.delegate = self;
                [m_imagePicker setAllowsEditing:NO];
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:m_imagePicker];
                popoverController = popover;
                CGRect f =txtTotal.frame;
                f.origin.y=f.origin.y+20;
                [popoverController presentPopoverFromRect:f inView:uv permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }
				break;
                
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *p = [[UIImagePickerController alloc]init];
                    p.delegate=self;
                    p.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:p animated:YES completion:nil];
                    
                    
                }else{
                    [[self getErrorAlert:@"There is no camera available."] show];
                }
                
                
            }
		}
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}

- (UIImage *)scaleImage:(UIImage *)image

{
    float h = image.size.height;
    float w = image.size.width;
    float x, y1;
    
    float scaleSize;
    scaleSize=600/h;
    h=600;
    y1=0;
    w=w*scaleSize;
    x=(800-w)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

   int  y =txtTotal.frame.origin.y+40;
//    y=y-120;
    
    if (imageView) {
        imageView.image=nil;
        imageView=nil;
        [imageView removeFromSuperview];
    }
   
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0,y,w*0.375,225)];
    imageView.layer.cornerRadius=10.0f;
    
    imageView.layer.masksToBounds = YES;
    y=y+235;
    imageView.image = image;
    CGRect f =btn1.frame;
    f.origin.y=y;
    btn1.frame=f;
        y=y+50;
    f=loginButton.frame;
    f.origin.y=y;
    loginButton.frame=f;
    y=y+60;
    //    isChange=YES;
    myphoto=scaledImage;
    [uv addSubview:imageView];
    
    uv.contentSize=CGSizeMake(f.size.width+20,y);
//    y=y1;
    //    [ciatbview reloadData];
    //    [ntabbar setSelectedItem:nil];
    return image;
    
}


-(void)dosubmit{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Submiting...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    NSString *tnote = [txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    
    NSString *ttotal =[txtTotal.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *temail;
    if ([pickerArray count]==0) {
        temail=@"";
    }else{
        temail =dd1.titleLabel.text;
    }
    
    NSString *tdate =txtDate.titleLabel.text;
    
    wcfService *service=[wcfService service];
    if (myphoto) {
        NSData *photoData=UIImageJPEGRepresentation(myphoto, 1.0);
        Mysql *mysql =[[Mysql alloc]init];
        NSString * strphotodata = [mysql Base64Encode:photoData];
        [service xNewVPOWithPhoto:self action:@selector(xNewVPOHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:xidproject xidvendor:xidvendor xnvendor:xnvendor xidreason:xidreason xnreason:xnreason toemail:temail delivery:tdate notes:tnote total:ttotal photoBase64String:strphotodata EquipmentType:@"5"];
    }else{
        [service xNewVPO:self action:@selector(xNewVPOHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:xidproject xidvendor:xidvendor xnvendor:xnvendor xidreason:xidreason xnreason:xnreason toemail:temail delivery:tdate notes:tnote quantity:@"1" total:ttotal EquipmentType:@"5"];
    }
    
    
    
}

- (void) xNewVPOHandler: (id) value {
    
    [HUD hide:YES];
    
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
    
    
	// Do something with the NSString* result
    NSString* result = (NSString*)value;
	if ([result isEqualToString:@"1"]) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[project class]] || [temp isKindOfClass:[development class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    }else{
        UIAlertView *alert = [self getErrorAlert: @"Submit unsuccessfully."];
        [alert show];
    }
    
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

- (void)nextClicked{
    [txtTotal becomeFirstResponder];
}

- (void)previousClicked{
    [txtNote becomeFirstResponder];
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtNote resignFirstResponder];
    
    [txtTotal resignFirstResponder];
}

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
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
        
    }
    [actionSheet addSubview:pdate];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtDate.frame inView:uv animated:YES];    
    
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
    [actionSheet showFromRect:dd1.frame inView:uv animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==1) {
        if (buttonIndex == 0) {
            [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
    }else{
        if (buttonIndex == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/YYYY"];
            [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
        }
        [uv setContentOffset:CGPointMake(0,0) animated:YES];
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
