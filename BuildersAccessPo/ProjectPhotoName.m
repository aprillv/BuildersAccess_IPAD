//
//  ProjectPhotoName.m
//  BuildersAccess
//
//  Created by roberto ramirez on 11/1/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "ProjectPhotoName.h"
#import "baControl.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Reachability.h"
#import "Mysql.h"
#import "MBProgressHUD.h"
#import "CustomKeyboard.h"
#import "development.h"
#import "project.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectPhotoName ()<MBProgressHUDDelegate, CustomKeyboardDelegate>

@end

@implementation ProjectPhotoName{
    UIScrollView *uv;
    UITextField *usernameField;
    UITextView *txtNote;
    MBProgressHUD *HUD;
    CustomKeyboard *keyboard;
    UIButton *btnNext;
}

@synthesize idproject,imgsss, ki, isDevelopment, isPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[development class]] || [temp isKindOfClass:[project class]]){
            [self.navigationController popToViewController:temp animated:NO];
        }
        
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//     [self.navigationItem setHidesBackButton:YES animated:NO];
    
//    [self.navigationItem setHidesBackButton:YES];
    
//    [self.navigationController.navigationItem setHidesBackButton:YES];
     
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
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height);
    [self.uw addSubview:uv];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    
    
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[UIView new] ]];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    if (isPhoto) {
        self.title=@"Upload Photos";
        
    }else{
    self.title=@"Upload PM Notes";
    }
    [self drawPage];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 1) {
        [self goBack1];
    }
}

//-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationItem setHidesBackButton:YES animated:NO];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
//}

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

-(void)orientationChanged{
    [super orientationChanged];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
}

-(void)drawPage{
    
    
    int x=0;
    int y=10;
    y=y+20;
    x=10;

    int dwidth = self.uw.frame.size.width-40;
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth, 21)];
    lbl.text=@"Name";
    [uv addSubview:lbl];
    y=y+21+x;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    //    usernameField.returnKeyType=UIReturnKeyDone;
    [uv addSubview: usernameField];
    if (isPhoto) {
         usernameField.text=[NSString stringWithFormat:@"%@ + %@_%@", ki.Value, [userInfo getUserNameService], [self getSystemTime]];
    }else{
        usernameField.text=[NSString stringWithFormat:@"%@_%@", [userInfo getUserNameService], [self getSystemTime]];
    }
   
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 10, 21)];
    lbl.text=@"*";
    lbl.textColor=[UIColor redColor];
    [uv addSubview:lbl];
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(30, y, dwidth-10, 21)];
    lbl.text=@"Tag";
    [uv addSubview:lbl];
    y=y+21+x;
    
//    passwordField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth, 30)];
//    [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
//    passwordField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [passwordField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    [uv addSubview: passwordField];
//    y=y+30+x+35;
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    dispatch_async(dispatch_get_main_queue(), ^{
        txtNote = [[UITextView alloc]initWithFrame:CGRectMake(25, y+3, dwidth-10, 98) ];
        txtNote.layer.cornerRadius=10;
        txtNote.font=[UIFont systemFontOfSize:17.0];

        [uv addSubview:txtNote];
        txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    });
    y=y+105+x+35;
    
    UIButton *btn1 = [baControl getGrayButton];
    [btn1 setFrame:CGRectMake(20, y, dwidth, 44)];
    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [btn1 setTitle:@"Submit" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doSubmit:) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn1];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];

}


-(void)doneClicked{
    [usernameField resignFirstResponder];
    [txtNote resignFirstResponder];
}

-(void)previousClicked{
    [txtNote becomeFirstResponder];
}

-(void)nextClicked{
    [txtNote becomeFirstResponder];
}


-(IBAction)doSubmit:(id)sender{
    
   
	if ([Mysql TrimText:usernameField.text].length==0){
       
		UIAlertView *alert = [self getErrorAlert: @"Name is required"];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
	}else if([Mysql TrimText:txtNote.text].length==0){
        
		UIAlertView *alert = [self getErrorAlert: @"Tag is required"];
        [alert show];
        [txtNote becomeFirstResponder];
        return;
    }

    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler1:) version:version];
    }
}

- (void) xisupdate_iphoneHandler1: (id) value {
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
        wcfService *service =[wcfService service];
        NSData *photoData=UIImageJPEGRepresentation(imgsss, 1.0);
        Mysql *mysql =[[Mysql alloc]init];
        NSString * strphotodata = [mysql Base64Encode:photoData];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Uploading to the server...   ";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        if (isDevelopment) {
            if (isPhoto) {
                //photes
                [ service xUploadPhotos:self action:@selector(asyuyuy:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:idproject xFolderid:@"14" xFolder1id:@"31" xFolder2id:ki.Key xFolder2Name:ki.Value fname:[Mysql TrimText:usernameField.text] ftype:@"JPG" ftags:[Mysql TrimText:txtNote.text] fileBase64String:strphotodata EquipmentType:@"3"];
            }else{
                
                //pm notes
                [ service xUploadPhotos:self action:@selector(asyuyuy:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:idproject xFolderid:@"14" xFolder1id:@"399" xFolder2id:@"" xFolder2Name:@"" fname:[Mysql TrimText:usernameField.text] ftype:@"JPG" ftags:[Mysql TrimText:txtNote.text] fileBase64String:strphotodata EquipmentType:@"3"];
            }
        }else{
            if (isPhoto) {
                //photes
                [ service xUploadPhotos:self action:@selector(asyuyuy:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:idproject xFolderid:@"6" xFolder1id:@"30" xFolder2id:ki.Key xFolder2Name:ki.Value fname:[Mysql TrimText:usernameField.text] ftype:@"JPG" ftags:[Mysql TrimText:txtNote.text] fileBase64String:strphotodata EquipmentType:@"3"];
            }else{
                
                //pm notes
                [ service xUploadPhotos:self action:@selector(asyuyuy:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:idproject xFolderid:@"6" xFolder1id:@"400" xFolder2id:@"" xFolder2Name:@"" fname:[Mysql TrimText:usernameField.text] ftype:@"JPG" ftags:[Mysql TrimText:txtNote.text] fileBase64String:strphotodata EquipmentType:@"3"];
            }
        }
    }
}


- (void) asyuyuy: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HUD hide];
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
    
    NSString *rtn = value;
    if ([rtn isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update fail."];
        [alert show];
        [self goBack1];
    }else  if ([rtn isEqualToString:@"1"]) {
        [self goBack1];
//        [self refreshPrject:nil];
    }else{
        UIAlertView *alert = [self getErrorAlert:[rtn stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"]];
        [alert show];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}

- (void)scaleImage:(UIImage *)image

{
    
    ProjectPhotoName *pn =[ProjectPhotoName alloc];
    pn.managedObjectContext=self.managedObjectContext;
    pn.idproject=self.idproject;
    pn.isDevelopment=YES;
    pn.imgsss=image;
    pn.isPhoto=NO;
    [self.navigationController pushViewController:pn animated:YES];
    
}

-(NSString *)getSystemTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMdd_hhmmss"];
    NSString*locationString=[formatter stringFromDate: [NSDate date]];
    formatter=nil;
    return locationString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
