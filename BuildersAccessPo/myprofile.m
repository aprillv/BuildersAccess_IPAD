
//
//  myprofile.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "myprofile.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "cl_phone.h"
#import "Reachability.h"
#import "baControl.h"

@interface myprofile ()

@end

BOOL isChange;
BOOL stayup;
wcfUserProfileItem* result;

@implementation myprofile

@synthesize ciatbview, uname, utitle, phone, fax, mobile, myphoto;

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
    
    isChange=NO;
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [self setTitle: @"My Profile"];
    
   
//    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"save.png"] ];
//    [[ntabbar.items objectAtIndex:0]setTitle:@"Save" ];
//    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(dosave:) ];
//    
//    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
//    [[ntabbar.items objectAtIndex:13]setTitle:@"Cancel" ];
//    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(gohome:) ];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
    
    
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(doRefresh) ];
//    wcfService *service =[wcfService service];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    [service xGetUserProfile:self action:@selector(xGetUserProfileHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] EquipmentType: @"3"];
    [self getDetai];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self doRefresh];
    }
}



-(void)doRefresh{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        [self getDetai];
    }
}
-(void)getDetai{
    wcfService *service =[wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [service xGetUserProfile:self action:@selector(xGetUserProfileHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] EquipmentType: @"3"];
}


- (void) xGetUserProfileHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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

    
    
	// Do something with the wcfUserProfileItem* result
     result = (wcfUserProfileItem*)value;
	
UIScrollView *sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    
    for (UIView *uio in sv.subviews) {
        [uio removeFromSuperview];
    }
//    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    sv.tag=1;
    int x=5;
    int y=15;
    [self.uw addSubview:sv];
    sv.autoresizesSubviews=YES;
    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/userphoto.aspx?email1=%@&email2=%@&password=%@", [userInfo getUserName], [userInfo getUserName], [userInfo getUserPwd]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data!=nil) {
        myphoto =[UIImage imageWithData:data];
        if (myphoto ==nil) {
            myphoto=[UIImage imageNamed:@"nophoto.png"];
        }
    }else{
        myphoto=[UIImage imageNamed:@"nophoto.png"];
    }
   
  
    
    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 120.0f)];
    ciatbview.layer.cornerRadius = 10;
    ciatbview.separatorColor=[UIColor clearColor];
    
    ciatbview.layer.borderWidth = 1.2;
ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [ciatbview setRowHeight:120.0f];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
    ciatbview.tag=12;
    [sv addSubview:ciatbview];
    y=y+130+x+5;
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Name";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [sv addSubview:lbl];
    y=y+21+x;
   
    uname=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 31)];
    [uname setBorderStyle:UITextBorderStyleRoundedRect];
    [uname addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    uname.autocapitalizationType = UITextAutocapitalizationTypeNone;
    uname.text=result.Name;
    uname.delegate=self;
    [sv addSubview: uname];
    y=y+31+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Title";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [sv addSubview:lbl];
    y=y+21+x;
    
    utitle=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 31)];
    [utitle setBorderStyle:UITextBorderStyleRoundedRect];
    [utitle addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    utitle.text=result.Title;
    utitle.delegate=self;
    [sv addSubview: utitle];
    y=y+31+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Office";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [sv addSubview:lbl];
    y=y+21+x;
    
    phone=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 31)];
    [phone setBorderStyle:UITextBorderStyleRoundedRect];
    [phone addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    phone.text=result.Phone;
    phone.delegate=self;
    [sv addSubview: phone];
    y=y+31+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Fax";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [sv addSubview:lbl];
    y=y+21+x;
    
    fax=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 31)];
    [fax setBorderStyle:UITextBorderStyleRoundedRect];
    [fax addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    fax.text=result.Fax;
    fax.delegate=self;
    [sv addSubview: fax];
    y=y+31+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Mobile";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [sv addSubview:lbl];
    y=y+21+x;
    
    mobile=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 31)];
    [mobile setBorderStyle:UITextBorderStyleRoundedRect];
    [mobile addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    mobile.delegate=self;
    mobile.text=result.Mobile;
    [sv addSubview: mobile];
    
     y=y+31+x+5;
    
    UIButton *btn1 = [baControl getGrayButton];
    [btn1 setFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 44)];
    [btn1 setTitle:@"Save" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dosave:) forControlEvents:UIControlEventTouchDown];
    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [sv addSubview:btn1];
    
    sv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
    [uname setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [utitle setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    [phone setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    [fax setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    [mobile setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
     ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
     uname.autoresizingMask=UIViewAutoresizingFlexibleWidth;
     utitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
     phone.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    fax.autoresizingMask=UIViewAutoresizingFlexibleWidth;
     mobile.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [ntabbar setSelectedItem:nil];
}




- (UIImage *)scaleImage1:(UIImage *)image
{
    float h = image.size.height;
    float w = image.size.width;
    float x, y;
    
    float scaleSize;
    scaleSize=120/h;
    h=120;
    y=0;
    w=w*scaleSize;
    x=(160-w)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


-(void)orientationChanged{
    [super orientationChanged];
     
    UIScrollView* uaaa=(UIScrollView*)[self.uw viewWithTag:1];
    uaaa.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.textLabel.text =result.Name;
        cell.detailTextLabel.text=result.Title;
        
        
        [cell .imageView setImage:[self scaleImage1:myphoto]];
        cell.imageView.layer.cornerRadius=10.0;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.tag = indexPath.row;
        
        cell.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
        tapped.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:tapped];
        
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setAlpha:0.0];
        [cell setAccessoryView:spinner];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //    cell.userInteractionEnabled=NO;
        return cell;
    }
    
}

-(IBAction)myFunction :(id) sender
{
    [self getPhoto:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        
        return 1;}
}




-(IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

-(IBAction)dosave:(id)sender{
    
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
        
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to save?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 3;
        [alert show];
    }
    
    
}


- (void) xUpdateUserProfileHandler: (int) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
	// Do something with the int result
    if (value>0) {
        cl_phone *mp =[[cl_phone alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        wcfPhoneListItem *wp =[[wcfPhoneListItem alloc]init];
        wp.Email=[userInfo getUserName];
        wp.Fax=fax.text;
        wp.Office=phone.text;
        wp.Mobile=mobile.text;
        wp.Title=utitle.text;
        wp.Name=uname.text;
        [mp updPhonefrommyprofile:wp];
        
        UIAlertView *alert = [self getSuccessAlert:@"Your profile save successfully."];
        alert.tag=2;
        alert.delegate=self;
        [alert show];
    }else{
        UIAlertView *alert = [self getErrorAlert:@"Your profile save failed"];
        [alert show];
    }
    
}


-(IBAction)getPhoto:(id)sender{
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
-(void)previousClicked{
   if([utitle isFirstResponder]){
       [uname becomeFirstResponder];
    }else if([phone isFirstResponder]){
         [utitle becomeFirstResponder];        
    }else if([fax isFirstResponder]){
        [phone becomeFirstResponder];
        
    }else{
        [fax becomeFirstResponder];        
    }
}
-(void)nextClicked{
    if ([uname isFirstResponder]) {
        [utitle becomeFirstResponder];
    }else if([utitle isFirstResponder]){
        [phone becomeFirstResponder];
    }else if([phone isFirstResponder]){
        [fax becomeFirstResponder];        
    }else if([fax isFirstResponder]){
         [mobile becomeFirstResponder];
    }
}

- (void)doneClicked {
    
    [uname resignFirstResponder];
    [utitle resignFirstResponder];
    [phone resignFirstResponder];
    [fax resignFirstResponder];
    [mobile resignFirstResponder];
     UIScrollView *uv1=(UIScrollView *)[self.uw viewWithTag:1];
   [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
    UIScrollView *uv1=(UIScrollView *)[self.uw viewWithTag:1];
    [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    if (self.view.frame.size.width==1024.0f) {
        UIScrollView *uv1=(UIScrollView *)[self.uw viewWithTag:1];
        if (sender == self.fax) {
            [uv1 setContentOffset:CGPointMake(0,115) animated:YES];
        }else if(sender == phone){
            [uv1 setContentOffset:CGPointMake(0,50) animated:YES];
        }else if(sender == mobile){
            [uv1 setContentOffset:CGPointMake(0,180) animated:YES];
        }else{
            [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
        }

    }
   	return YES;
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}


- (UIImage *)scaleImage:(UIImage *)image

{
    float h = image.size.height;
    float w = image.size.width;
    float x, y;
    
    float scaleSize;
    scaleSize=120/h;
    h=120;
    y=0;
    w=w*scaleSize;
    x=(160-w)/2;
        
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    isChange=YES;
    myphoto=scaledImage;
    [ciatbview reloadData];
    [ntabbar setSelectedItem:nil];
    return image;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1){
	    switch (buttonIndex) {
            case 2:
            {
                UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc]init];
                m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                m_imagePicker.delegate = self;
                [m_imagePicker setAllowsEditing:NO];
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:m_imagePicker];
                popoverController = popover;
                CGRect f=ciatbview.frame;
                f.size.width=40;
                [popoverController presentPopoverFromRect:f inView:self.uw permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
	}else if (alertView.tag==2){
        [self gohome:nil];
    }else if(alertView.tag==3 ){
        if ( buttonIndex==1) {
            if (isChange) {
                NSData *photoData=UIImageJPEGRepresentation(myphoto, 1.0);
                Mysql *mysql =[[Mysql alloc]init];
                NSString * strphotodata = [mysql Base64Encode:photoData];
                
                wcfService *service =[wcfService service];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                
                [service xUpdateUserProfile:self action:@selector(xUpdateUserProfileHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] title: [Mysql TrimText:utitle.text] name: [Mysql TrimText:uname.text] fax: [Mysql TrimText:fax.text] mobile: [Mysql TrimText:mobile.text] phone: [Mysql TrimText:phone.text] photoBase64String: strphotodata EquipmentType: @"3"];
            }else{
                
                wcfService *service =[wcfService service];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                
                [service xUpdateUserProfileWithoutPhoto:self action:@selector(xUpdateUserProfileHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] title: [Mysql TrimText:utitle.text] name: [Mysql TrimText:uname.text] fax: [Mysql TrimText:fax.text] mobile: [Mysql TrimText:mobile.text] phone: [Mysql TrimText:phone.text] EquipmentType: @"3"];
            }
        }else{
            [ntabbar setSelectedItem:nil];
        }
        

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
