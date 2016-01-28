//
//  addItem.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "addItem.h"
#import "wcfService.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "viewImage.h"
#import "qainspectionb.h"
#import "qacalendarViewController.h"
#import "MBProgressHUD.h"
#import "project.h"

@interface addItem()<CustomKeyboardDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate, MBProgressHUDDelegate>{
    UIScrollView *uv;
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    NSString *donext;
    UIImageView *uview;
    
    int imgy;
    bool ishaveimg;
    
    UIButton *btnAddPic;
    UIButton *btnFail;
    UIButton *btnFinish;
    UIImage* scaledImage;
    MBProgressHUD *HUD;
    UIButton *btnNext;
     UIPopoverController *popoverController;
}
@end

@implementation addItem

@synthesize idnumber, isshow, category, fromtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(IBAction)goBack1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[qacalendarViewController class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
        
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1:nil];
//    }else if(item.tag == 2){
//        [self dorefresh:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack1:)];
    if (fromtype==1) {
         [[ntabbar.items objectAtIndex:0]setTitle:@"Calendar" ];
    }else{
     [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh:)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh2.png"] ];
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
    

    
    ishaveimg=NO;
    int x=10;
    int y=15;
    
    [self setTitle:@"Inspection"];
    
    if (uv) {
        [uv removeFromSuperview];
    }
    
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
     uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    
    [self.uw addSubview:uv];
    
    dwidth=dwidth-20;
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Category";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth, rowheight-6)];
    lbl.text=category;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes (max 512 chars)";
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwidth-4, 98) ];
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.layer.cornerRadius=10.0;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    imgy=y;
    
    uview =[[UIImageView alloc]init];
    [uv addSubview:uview];
    
    btnAddPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddPic setFrame:CGRectMake(10, y, dwidth, 44)];
     btnAddPic.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [btnAddPic setTitle:@"Attatch Picture" forState:UIControlStateNormal];
    [btnAddPic.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnAddPic setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnAddPic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAddPic addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnAddPic];
        y= y+50;
    
    
    
    if ([isshow isEqualToString:@"1"]) {
        btnFail = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFail setFrame:CGRectMake(10, y, dwidth, 44)];
        btnFail.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [btnFail setTitle:@"Item > Save & Fail" forState:UIControlStateNormal];
        [btnFail.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnFail setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnFail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFail addTarget:self action:@selector(doFail) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnFail];
        y= y+50;

        btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFinish setFrame:CGRectMake(10, y, dwidth, 44)];
         btnFinish.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [btnFinish setTitle:@"Item > Save & Pass" forState:UIControlStateNormal];
        [btnFinish.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFinish addTarget:self action:@selector(doFinish) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnFinish];
        y= y+50;
    }

    
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
	// Do any additional setup after loading the view.
}
-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=self.uw.frame.size.height;
    [uv setContentSize:CGSizeMake(dwidth, dheight+1)];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)addPic{
    donext=@"1";
    [self autoUpd];
}

-(void)doFail{
    donext=@"2";
    [self autoUpd];
}

-(void)doFinish{
    donext=@"3";
    [self autoUpd];
}

-(void)autoUpd{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
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
        if ([donext isEqualToString:@"1"]) {
            // attatch picture
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:nil
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"New Photo",@"Choose from Library", nil];
            alert.tag = 1;
            [alert show];
        }else if([donext isEqualToString:@"2"]){
            // save & fail
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure this item fails?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 2;
            [alert show];
            
            
        }else if([donext isEqualToString:@"3"]){
            // save & finish
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure this item pass?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 3;
            [alert show];
        }
        
    }
    
    
}

- (void) xisupdate_iphoneHandler2: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HUD hide:YES];
    [HUD removeFromSuperview];
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
    
    NSString *rtn =(NSString *)value;
    if ([rtn isEqualToString:@"1"]) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[qainspectionb class]]) {
                [self.navigationController popToViewController:temp animated:NO];
            }            
        }

    }
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
                CGRect f=btnAddPic.frame;
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
	}else if(alertView.tag==2){
        if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            if (ishaveimg) {
                
                UIGraphicsBeginImageContext(CGSizeMake(800, 600));
                [scaledImage drawInRect:CGRectMake(0, 0, 800, 600)];
                scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *photoData=UIImageJPEGRepresentation(scaledImage, 1.0);
                Mysql *mysql =[[Mysql alloc]init];
                NSString * strphotodata = [mysql Base64Encode:photoData];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Updating...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                [service xQaCalendarInspection2bAddWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"5"];
            }else{
                [service xQaCalendarInspection2bAdd:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text EquipmentType:@"5"];
            }

        }
    }else if(alertView.tag==3){
        if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            if (ishaveimg) {
                
                UIGraphicsBeginImageContext(CGSizeMake(800, 600));
                [scaledImage drawInRect:CGRectMake(0, 0, 800, 600)];
                scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *photoData=UIImageJPEGRepresentation(scaledImage, 1.0);
                Mysql *mysql =[[Mysql alloc]init];
                NSString * strphotodata = [mysql Base64Encode:photoData];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Updating...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                [service xQaCalendarInspection2bAddPassWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"5"];
                
            }else{
                [service xQaCalendarInspection2bAddPass:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text EquipmentType:@"5"];
            }
            
        }
    }
    
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
    int  dwith =self.uw.frame.size.width-20;
    uview.frame=CGRectMake(10, imgy, 300, 225);
    uview.userInteractionEnabled = YES;
    uview.layer.cornerRadius=10;
    uview.layer.masksToBounds = YES;
    
    int y1 = imgy+250;
    btnAddPic.frame=CGRectMake(10, y1, dwith, 44);
    y1=y1+50;
    
    if (btnFail) {
        btnFail.frame=CGRectMake(10, y1, dwith, 44);
        y1=y1+50;
        
        btnFinish.frame=CGRectMake(10, y1, dwith, 44);
        y1=y1+50;
    }
    uv.contentSize=CGSizeMake(dwith+20, y1+20);
    
    uview.image=image;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [uview addGestureRecognizer:tapped];
     [btnAddPic setTitle:@"Re - Attatch Picture" forState:UIControlStateNormal];
    
//    UIGraphicsBeginImageContext(CGSizeMake(800, 600));
//    [image drawInRect:CGRectMake(0, 0, 800, 600)];
//    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    scaledImage=image;
    [ntabbar setSelectedItem:nil];
     ishaveimg=YES;
    
    return image;
    
}

-(IBAction)myFunction :(id) sender
{
//    viewImage * vi =[viewImage alloc];
//    vi.managedObjectContext=self.managedObjectContext;
//    vi.img=scaledImage;
//    [self.navigationController presentViewController:vi animated:YES completion:nil];
}



- (void)doneClicked{
    [txtNote resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
