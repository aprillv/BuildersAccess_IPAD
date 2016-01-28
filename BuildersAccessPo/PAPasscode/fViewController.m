//
//  fViewController.m
//  CoreData
//
//  Created by amy zhao on 13-2-26.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fViewController.h"
#import "userInfo.h"
#import "cl_pin.h"
#import "cl_project.h"
#import "cl_favorite.h"
#import "cl_cia.h"
#import "Login.h"
#import "kirbytitle.h"

@interface fViewController ()

@end

@implementation fViewController


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
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self //Add yourself as an observer
           selector:@selector(orientationChanged)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
	// Do any additional setup after loading the view.
}
- (void)orientationChanged{}
-(UIAlertView *)getErrorAlert:(NSString *)str{
    UIAlertView *alertView = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:str
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
        
    return alertView;
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


-(IBAction)logout:(id)sender{
   
    [userInfo setUserName:[userInfo getUserName] andPwd:nil];
    [userInfo initCiaInfo:0 andNm:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setPasscode:(id)sender {
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
    passcodeViewController.delegate = self;
    passcodeViewController.simple = _simpleSwitch.on;
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

- (IBAction)enterPasscode:(id)sender {
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = [self unlockPasscode];
    passcodeViewController.simple = _simpleSwitch.on;
    if ([self isKindOfClass:[kirbytitle class]]) {
        [self.parentViewController presentViewController:passcodeViewController animated:YES completion:nil];
    }else
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}


-(void)changePin{}

- (IBAction)changePasscode:(id)sender {
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionChange];
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = [self unlockPasscode];
    passcodeViewController.simple = _simpleSwitch.on;
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

#pragma mark - PAPasscodeViewControllerDelegate

- (void)g:(PAPasscodeViewController *)controller{
    
    
    [self dismissViewControllerAnimated:YES completion:^() {
        cl_pin *mp=[[cl_pin alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletePin];
        
        cl_cia *ma =[[cl_cia alloc]init];
        ma.managedObjectContext=self.managedObjectContext;
        [ma deletaAll];
        
        cl_project *mj =[[cl_project alloc]init];
        mj.managedObjectContext=self.managedObjectContext;
        [mj deletaAllCias];
        
        cl_favorite *mf =[[cl_favorite alloc]init];
        mf.managedObjectContext =self.managedObjectContext;
        [mf deletaAllCias];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"save"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            NSError* error;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        }
        [userInfo setUserName:nil andPwd:nil];
        
        Login * a =[[self.navigationController childViewControllers] objectAtIndex:0];
        a.passwordField.text=@"";
//        [a.checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        a.ischecked=NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        [self CancletPin];
    }];
    
}

-(void)CancletPin{

}
- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Passcode entered correctly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
   
}

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        
       
        cl_pin *mp=[[cl_pin alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp addToXpin:[userInfo getUserName] andpincode:controller.passcode];
        [self changePin];
    }];
}

- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        cl_pin *mp=[[cl_pin alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletePin];
        [self changePin];
    }];
}

- (void)viewDidUnload {
    [self setSimpleSwitch:nil];
    [super viewDidUnload];
}



- (NSString *)unlockPasscode
{
    //Provide the ABLockScreen with a code to verify against
    //    return 1234;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Xpin"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pincode"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResult count]==0) {
        return @"0";
    }else{
        NSManagedObject *entry1 = [mutableFetchResult objectAtIndex:0];
        return [entry1 valueForKey:@"pincode"];
        
        
    }
    
}

- (NSString *)lastUser
{
    //Provide the ABLockScreen with a code to verify against
    //    return 1234;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Xpin"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pincode"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResult count]==0) {
        return @"0";
    }else{
        NSManagedObject *entry1 = [mutableFetchResult objectAtIndex:0];
        return [entry1 valueForKey:@"email"];
    }
    
}
@end
