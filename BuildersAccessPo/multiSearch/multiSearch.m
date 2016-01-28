//
//  multiSearch.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/23/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "multiSearch.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "multiSearchRslt.h"
#import "Reachability.h"
#import "wcfService.h"
//#import "NSString+Color.h"
#import "baControl.h"
#import "developmentVendorLs.h"
#import "userInfo.h"

@interface multiSearch() <CustomKeyboardDelegate>

@end

@implementation multiSearch{
    UIScrollView *sv;
    UITextField *usernameField;
    CustomKeyboard *keyboard;
    int donext;
//    UIButton *dd1;
//    UIPickerView *ddpicker;
//    NSMutableArray *pickerArray;
    UIButton *btnNext;
}
@synthesize atitle, isfrommainmenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doneClicked{
    [usernameField resignFirstResponder];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack: nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int y=10;
    int x =5;
    donext=0;
    if (isfrommainmenu) {
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
        //    UITabBarItem *t = [ntabbar.items objectAtIndex:6];
        //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
        //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
        
        [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    }
    
   
       
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
        
   
        
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=atitle;
    int dwidth = self.uw.frame.size.width;
    int dheight = self.uw.frame.size.height;
    
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, dwidth, dheight)];
    sv.contentSize=CGSizeMake(dwidth, dheight+1);
    [self.uw addSubview:sv];
    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-40, 42)];
    if ([atitle hasPrefix:@"Project"]) {
        lbl.text=@"Search by project number, name or plan name";
 
    }else{
        
        lbl.text=@"Search by vendor name ";
    }
    
    [sv addSubview:lbl];
    y=y+lbl.frame.size.height+x;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, dwidth-40, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    usernameField.returnKeyType=UIReturnKeyDone;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :NO]];
    
    [sv addSubview: usernameField];
    y=y+30+x+10;
    
    
    //    [btn1.layer setBackgroundColor:[UIColor redColor].CGColor];
    UIButton *btn1 =[baControl getGrayButton];
    [btn1 setFrame:CGRectMake(20, y, dwidth-40, 44)];
    [btn1 setTitle:@"Search" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dosearch:) forControlEvents:UIControlEventTouchDown];
    btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [sv addSubview:btn1];
    
    //    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn1 setFrame:CGRectMake(200, y, 100, 36)];
    //    [btn1 setTitle:@"Sign Up" forState:UIControlStateNormal];
    //    [btn1 addTarget:self action:@selector(SingUpOnclick:) forControlEvents:UIControlEventTouchDown];
    //    [sv addSubview:btn1];
    
    y=y+50+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(30, y, dwidth-60, 147)];
    lbl.font=[UIFont systemFontOfSize:13.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    if ([atitle hasPrefix:@"Project"]) {
        lbl.text=@"* Notes: You can use any combination of keywords to find your projects, but search will only return the first 100 records that match your criteria. \n\nA minimum of 4 characters are required to search.";
    }else{
     lbl.text=@"* Notes: You can use any combination of keywords to find your vendors, but search will only return the first 100 records that match your criteria. \n\nA minimum of 4 characters are required to search.";
    }
    
    
    lbl.numberOfLines=7;
    [lbl sizeToFit];
    [sv addSubview:lbl];
    
	// Do any additional setup after loading the view.
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self orientationChanged];
}
//-(IBAction)popupscreen2:(id)sender{
//    
//   
//    
//    [usernameField resignFirstResponder];
////    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self
////                                                    cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
////    [actionSheet setTag:1];
////    
////    if (ddpicker ==nil) {
////        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
////        ddpicker.showsSelectionIndicator = YES;
////        ddpicker.delegate = self;
////        ddpicker.dataSource = self;
////    }
////    
////    [actionSheet addSubview:ddpicker];
////    
////    //    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
////    // show from our table view (pops up in the middle of the table)
////    
////    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
////    [actionSheet showFromRect:dd1.frame inView:sv animated:YES];
//    
//    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
//                                                     cancelButtonTitle:nil
//                                                destructiveButtonTitle:@"Select"
//                                                     otherButtonTitles:nil];
//    
//    [actionSheet setTag:1];
//    actionSheet.delegate=self;
//    if (ddpicker ==nil) {
//        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
//        ddpicker.showsSelectionIndicator = YES;
//        ddpicker.delegate = self;
//        ddpicker.dataSource = self;
//    }
//    
//    [actionSheet addSubview:ddpicker];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showFromRect:dd1.frame inView:sv animated:YES];
//    
//    
//}
//
//-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 0) {
//        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
//    }
//    
//    
//    
//}
//
//
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//
//-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return [pickerArray count];
//}
//-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [pickerArray objectAtIndex:row];
//}



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
            {
                multiSearchRslt *mr =[multiSearchRslt alloc];
                mr.managedObjectContext=self.managedObjectContext;
                mr.detailstrarr=self.detailstrarr;
                mr.menulist=self.menulist;
                mr.tbindex=self.tbindex;
                mr.keyWord=[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [self.navigationController pushViewController:mr animated:NO];
            }
                break;
            case 2:
            {
                developmentVendorLs *mr =[developmentVendorLs alloc];
                mr.managedObjectContext=self.managedObjectContext;
                mr.tbindex=self.tbindex;
                mr.menulist=self.menulist;
                mr.idmaster=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
                mr.detailstrarr=self.detailstrarr;
                mr.searchkey=[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                mr.idproject=@"-1";
                [self.navigationController pushViewController:mr animated:NO];
            }
                break;
            default:
                break;
        }
    }
}


-(void)orientationChanged{
    [super orientationChanged];
    int dwidth = self.uw.frame.size.width;
    int dheight = self.uw.frame.size.height;
    sv.contentSize=CGSizeMake(dwidth, dheight+1);
    
}

-(IBAction)dosearch:(id)sender{
    if ([usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length<4) {
      
        
        UIAlertView *alert =[self getErrorAlert:@"A minimum of 4 characters are required to search."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    [usernameField resignFirstResponder];
    if ([atitle hasPrefix:@"Project"]) {
        donext=1;
    }else if([atitle hasPrefix:@"Vendor"]){
        donext=2;
    }else{
        donext=1;
    }
    [self doupdateCheck];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
