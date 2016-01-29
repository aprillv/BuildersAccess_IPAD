//
//  newSchedule2.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "newSchedule2.h"

#import "wcfArrayOfProjectSchedule.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "newSchedule2.h"
#import "project.h"
#import "MBProgressHUD.h"
#import "reschedule.h"
#import "aCell.h"

@interface newSchedule2 ()<MBProgressHUDDelegate, UIActionSheetDelegate>{
    
    wcfArrayOfProjectSchedule * wi;
    wcfProjectSchedule *xidnum;
    UITableView *tbview;
    UIScrollView *uv;
    UIButton *btnNext;
    wcfArrayOfProjectSchedule *wi2;
    MBProgressHUD *HUD;
    int curent;
    UIDatePicker *pdate;
    int selIndex;
    UIButton *scanQRCodeButton;
    int donext;
    
    NSString *atoday;
    
}

@end

@implementation newSchedule2

@synthesize xidproject, xidstep, atitle, formatter=_formatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
//    self.title=atitle;
//    
////    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack1)];
//    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
//    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
//    
////    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh)];
//    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
//    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([self getIsTwoPart]) {
//        btnNext.frame = CGRectMake(10, 26, 40, 32);
//    }else{
//        btnNext.frame = CGRectMake(60, 26, 40, 32);
//    }
//    
//    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back1"];
//    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
//    [self.navigationBar addSubview:btnNext];
    
	// Do any additional setup after loading the view.
}
-(IBAction)goBack:(id)sender{
    [tbview reloadData];
    [super goBack:sender];
}

-(void)orientationChanged{
    [super orientationChanged];
    int dwidth =self.uw.frame.size.width;
    int dheight=uv.contentSize.height+1;
    [uv setContentSize:CGSizeMake(dwidth, dheight)];
}
-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}
-(void)goBack1{
    for (UIViewController *uiview in self.navigationController.viewControllers) {
        if ([uiview isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:uiview animated:NO];
        }
    }
}
-(void)dorefresh{
    [self getMilestoneItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getMilestoneItem];
}
-(void)getMilestoneItem{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        if (![xidstep isEqualToString:@"-1"]) {
            [service xGetNewSchedule2:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject xstep:xidstep EquipmentType:@"3"];
        }else{
            [service xGetTaskDue:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject EquipmentType:@"3"];
        }
        
    }
}

- (void) xisupdate_iphoneHandler5: (id) value {
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
    
    wi=(wcfArrayOfProjectSchedule *)value;
    if (uv) {
        [uv removeFromSuperview];
    }
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.uw addSubview:uv];
    
    
    int xheight=dheight;
    
    
    xheight=0;
    BOOL canupdate=NO;
    for (wcfProjectSchedule *event in wi) {
        if (event.Notes!=nil) {
            xheight+=74;
        }else{
            xheight+=60;
        }
        if (!event.DcompleteYN) {
            canupdate=YES;
        }
    }
    
    
    
    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, xheight)];
    tbview.layer.cornerRadius = 10;
    tbview.delegate=self;
    tbview.dataSource = self;
    tbview.layer.borderWidth = 1.2;
    tbview.tag = 10;
    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    
    [uv addSubview:tbview];
    
    
//    if (([[[userInfo getUserName] lowercaseString] isEqualToString:@"roberto@buildersaccess.com"]||[[[userInfo getUserName] lowercaseString] isEqualToString:@"scotts@intown-homes.com"]) && canupdate) {
     if (canupdate) {
    
        
        
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, xheight+20, dwidth-20, 44)];
        [loginButton setTitle:@"Update Schedule" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [loginButton addTarget:self action:@selector(doapprove1) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        xheight=xheight+74;
        
    }
    
    uv.contentSize=CGSizeMake(dwidth,xheight+10);
    
    
    //    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, dwidth-20, uv.frame.size.height-20)];
    //    tbview.layer.cornerRadius = 10;
    //    tbview.delegate = self;
    //    tbview.dataSource = self;
    //    tbview.layer.borderWidth = 1.2;
    //    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    //    [uv addSubview:tbview];
    //    uv.contentSize=CGSizeMake(dwidth,uv.frame.size.height+1);
    [ntabbar setSelectedItem:nil];
}

-(void)doapprove1{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return [wi count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
        aCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[aCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        [cell setEditing:YES animated:YES];
//        [cell setEditingAccessoryType:UITableViewCellEditingStyleDelete];
//        UIImageView *imageView;
//        if (event.DcompleteYN||event.DcompleteYN2) {
//            
//            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
//        }else {
//            event. DcompleteYN2=NO;
//            imageView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
//        }
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
//        [imageView addGestureRecognizer:tap];
//        imageView.userInteractionEnabled = YES; //added based on @John 's comment
//        cell.accessoryView = imageView;
        if (!(![xidstep isEqualToString:@"-1"] && indexPath.row==0 && !event.DcompleteYN) && event.canEdit) {
            UIImageView *imageView;
            if (event.DcompleteYN||event.DcompleteYN2) {
                
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
            }else {
                event. DcompleteYN2=NO;
                imageView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES; //added based on @John 's comment
            cell.accessoryView = imageView;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell .imageView setImage:nil];
        }
        
        cell.textLabel.text=event.Name;
        NSString *nst;
        
        int n =1;
        if (event.Notes !=nil) {
            n= n+1;
            cell.ismore=YES;
            nst=[NSString stringWithFormat:@"%@\n", event.Notes];
        }else{
            nst=@"";
            cell.ismore=NO;
        }
        
        if (event.DcompleteYN) {
            nst= [NSString stringWithFormat:@"%@%@ %@",nst,event.Dstart ,event.Dcomplete];
        }else{
            if (event.DcompleteYN2) {
                nst= [NSString stringWithFormat:@"%@%@ To %@",nst,event.Dstart,event.DcompleteNew];
            }else{
                nst= [NSString stringWithFormat:@"%@%@",nst, event.Dcomplete];
            }
            
        }
        
        cell.detailTextLabel.numberOfLines=n;
        cell.detailTextLabel.text=nst;
        
        
        [cell.imageView setImage:nil];
        return cell;
    }
}


//- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
//    CGPoint tapLocation = [tapRecognizer locationInView:tbview];
//    NSIndexPath *indexPath = [tbview indexPathForRowAtPoint:tapLocation];
//    [self dochangeCheck:indexPath];
//
//}

//-(void)dochangeCheck:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return;
//    }
//
//    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:indexPath.row]);
//    if (!event.DcompleteYN) {
//        if (event. DcompleteYN2) {
//            event.DcompleteYN2=NO;
//        }else{
//            event.DcompleteYN2=YES;
//        }
//    }
//    NSMutableArray *na =[[NSMutableArray alloc]init];
//    [na addObject:indexPath];
//    [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
//}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return 70.0;
    }else{
        wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
        
        if (event.Notes!=nil) {
            return 74;
        }else {
            return 60;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath2{
    if (tableView.tag==1) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath2];
        
    }else{
       
        
        //    xidnum=((wcfProjectSchedule *)[wi objectAtIndex:indexPath.row]);
        //    [self doupdateCheck];
        
        if ([xidstep intValue]!=-1 && indexPath2.row==0) {
            return;
        }
//        NSLog(@"%d", indexPath2.row);
        selIndex=indexPath2.row;
        [self dostep1];
        
    }
}

-(void)popupscreen{
    if (atoday) {
        [self dochangeCheck: atoday];
    }else{
        if (!_formatter) {
            _formatter = [[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"MM/dd/YY"];
        }
        
        NSString * str=[_formatter stringFromDate:[[NSDate alloc] init] ];
        [self dochangeCheck: str];
        
    }
    
}


//-(void)popupscreen{
//    
//    //    [txtNote resignFirstResponder];
//    //
//    //    if (self.view.frame.size.height>500) {
//    //        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-180) animated:YES];
//    //    }else{
//    //        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-90) animated:YES];
//    //    }
//    
//    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
//                                                     cancelButtonTitle:nil
//                                                destructiveButtonTitle:@"Select"
//                                                     otherButtonTitles:nil];
//    
//    [actionSheet setTag:2];
//    actionSheet.delegate=self;
//    
//    
//    if (pdate ==nil) {
//        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 270, 90)];
//        pdate.datePickerMode=UIDatePickerModeDate;
//         pdate.maximumDate=[NSDate date];
//    }
//    [pdate setDate:[NSDate date]];
//     [actionSheet addSubview:pdate];
//   
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    UITableViewCell *ce = [tbview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selIndex inSection:0]];
//   
//    [actionSheet showFromRect:ce.frame inView:uv animated:YES];
//    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
//    //                                                    cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
//    //    [actionSheet setTag:2];
//    //
//    //    if (pdate ==nil) {
//    //        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    //        pdate.datePickerMode=UIDatePickerModeDate;
//    //        [pdate setDate:[[NSDate alloc]init]];
//    //
//    //    }else{
//    //        [pdate setDate:[[NSDate alloc]init]];
//    //    }
//    //    [actionSheet addSubview:pdate];
//    //
//    //    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    //    [actionSheet showInView:self.view];
//    //    if (self.view.frame.size.height>500) {
//    //        [actionSheet setFrame:CGRectMake(0, 207, 320, 383)];
//    //    }else{
//    //        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
//    //    }
//    //
//    //    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,236, 120, 46)];
//    //    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,236, 120, 46)];
//    
//    
//}
-(void)dealloc{
    _formatter=nil;
    pdate=nil;
}


-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==2) {
        if (buttonIndex == 0) {
            if (!_formatter) {
                 _formatter = [NSDateFormatter new];
                 [_formatter setDateFormat:@"MM/dd/YY"];
            }
           
           
            NSString * str =[_formatter stringFromDate:[pdate date]];
            //            [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
            [self dochangeCheck: str];
            
        }
        //        [uv setContentOffset:CGPointMake(0,0) animated:YES];
        
    }
    
    
}



-(void)dochangeCheck:(NSString *)dates{
    
    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex]);
    //    if (!event.DcompleteYN) {
    //        if (event. DcompleteYN2) {
    //            event.DcompleteYN2=NO;
    //        }else{
    //
    //        }
    //    }
    event.DcompleteYN2=YES;
    event.DcompleteNew=dates;
    NSMutableArray *na =[[NSMutableArray alloc]init];
    [na addObject:[NSIndexPath indexPathForRow:selIndex inSection:0]];
    [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
}


//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}


- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapLocation = [tapRecognizer locationInView:tbview];
    NSIndexPath *indexPath = [tbview indexPathForRowAtPoint:tapLocation];
    
    
    selIndex=indexPath.row;
    [self dostep1];
    //    [self dochangeCheck:indexPath];
    
}


-(void)dostep1{
   
     wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex]);
    
    
   
    if (!event.DcompleteYN) {
        
        
        if (event. DcompleteYN2) {
            event.DcompleteYN2=NO;
            event.DcompleteNew=@"";
            NSMutableArray *na =[[NSMutableArray alloc]init];
            [na addObject:[NSIndexPath indexPathForRow:selIndex inSection:0]];
            [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
            
        }else{
            if (event.canEdit) {
                [self popupscreen];
            }
        
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    //    if ((![xidstep isEqualToString:@"-1"] && indexPath.row==0 && !event.DcompleteYN)) {
    //
    //
    //   return YES;
    //    }else{
    //        return NO;
    //    }
    
    if (!event.DcompleteYN) {
        
        return YES;
    }else{
        return NO;
    }
    
    
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selIndex=indexPath.row;
        donext=2;
        [self doupdateCheck];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Reschedule";
}



//-(void)dochangeCheck:(NSString *)dates{
//
//    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
//    //    if (!event.DcompleteYN) {
//    //        if (event. DcompleteYN2) {
//    //            event.DcompleteYN2=NO;
//    //        }else{
//    //
//    //        }
//    //    }
//    event.DcompleteYN2=YES;
//    event.DcompleteNew=dates;
//    NSMutableArray *na =[[NSMutableArray alloc]init];
//    [na addObject:selIndex];
//    [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
//}

//-(void)doupdateCheck{
//
//
//    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
//    NetworkStatus netStatus = [curReach currentReachabilityStatus];
//    if (netStatus ==NotReachable) {
//        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
//        [alert show];
//    }else{
//        wcfService* service = [wcfService service];
//        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
//    }
//
//}

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
                 [self todoupdate:YES];
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
     
     
    

     wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex]);
    if (selIndex!=0 && ![[event.Name substringToIndex:1] isEqualToString:@"*"]) {
        reschedule * re=[reschedule alloc];
        re.xidproject=self.xidproject;
        re.result=nil;
        re.iscriticalpath=NO;
        wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex]);
        //        re.ws=event.Name;
        re.detailstrarr=self.detailstrarr;
        re.menulist=self.menulist;
        re.tbindex=self.tbindex;
        
        re.ws=event;
        //        NSLog(@"%@", re.ws);
        if (!_formatter) {
            _formatter = [[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"MM/dd/yy"];
        }
        
        
        NSDate *destDate= [_formatter dateFromString:[event.Dstart substringFromIndex:5]];
        re.idmainstep= [self.xidstep intValue];
        //        re.xrefid=event.Item;
        re.xstartd=destDate;
        [_formatter setDateFormat:@"MM/dd/yyyy"];
        re.ws.Dstart=[_formatter stringFromDate:destDate];
        [_formatter setDateFormat:@"MM/dd/yy"];
        //         NSLog(@"%@", re.ws);
        
        re.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:re animated:NO];
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [service xGetReschedule:self action:@selector(xGetRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:event.Item EquipmentType:@"3"];
        
        
    }
    
//    wcfService *service =[wcfService service];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    
//    [service xGetReschedule:self action:@selector(xGetRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:event.Item EquipmentType:@"3"];
    
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
     
//    NSLog(@"%d", selIndex);
    wcfArrayOfKeyValueItem* result2 = (wcfArrayOfKeyValueItem*)value;
    if ([result2 count]>0) {
        
  
    wcfKeyValueItem *ki =[result2 objectAtIndex:0];
    if ([ki.Key isEqualToString:@"-2"]) {
        UIAlertView *alert = [self getErrorAlert: ki.Value];
        [alert show];
        return;
    
    }else{
        
        wcfKeyValueItem *ki2=[result2 objectAtIndex:1];
        if ([ki.Key isEqualToString:@"-1"]) {
            UIAlertView *alert = [self getErrorAlert2: [NSString stringWithFormat:@"%@\n%@ %@",[ki.Value stringByReplacingOccurrencesOfString:@";" withString:@" "], ki2.Key, ki2.Value]];
            [alert show];
            return;
            
        }else{
            reschedule * re=[reschedule alloc];
            re.xidproject=self.xidproject;
            re.result=result2;
            re.iscriticalpath=YES;
            wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex]);
            //        re.ws=event.Name;
            re.detailstrarr=self.detailstrarr;
            re.menulist=self.menulist;
            re.tbindex=self.tbindex;
            
            re.ws=event;
            //        NSLog(@"%@", re.ws);
            if (!_formatter) {
                _formatter = [[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"MM/dd/yy"];
            }
            
  
            NSDate *destDate= [_formatter dateFromString:[event.Dstart substringFromIndex:5]];
            re.idmainstep= [self.xidstep intValue];
            //        re.xrefid=event.Item;
            re.xstartd=destDate;
            [_formatter setDateFormat:@"MM/dd/yyyy"];
            re.ws.Dstart=[_formatter stringFromDate:destDate];
            [_formatter setDateFormat:@"MM/dd/yy"];
            //         NSLog(@"%@", re.ws);
            
            re.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:re animated:NO];
        }

        
        
    }

    }else{
        UIAlertView *alert = [self getErrorAlert: @"Access denied. Contact your administrator to access:\nMenu 1.10 Projects Schedule + Read and Write"];
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

-(void)todoupdate:(BOOL)toCheck{
    wi2=[[wcfArrayOfProjectSchedule alloc]init];
    int nstep=1;
    if ([xidstep isEqualToString:@"-1"]) {
        nstep=0;
    }
    for (int i=nstep; i<[wi count]; i++) {
        wcfProjectSchedule *ws =[wi objectAtIndex:i];
        
        
        if (!ws.DcompleteYN && ws.DcompleteYN2 &&ws.canEdit) {
            Mysql *ms =[[Mysql alloc]init];
            //            NSLog(@"%@", ws.MilestoneDstart);
            if ([[ms dateFromString:ws.DcompleteNew] compare:[ms dateFromString:ws.MilestoneDstart]]==NSOrderedAscending) {
                UIAlertView *alert=[self getErrorAlert:@"Finish date can not be less than main step start date. Please re-schedule the main step in order to assign this date."];
                [alert show];
                return;
            }
            if ([[ms dateFromString:ws.DcompleteNew] compare:[ms dateFromString:[ws.Dstart substringFromIndex:5]]]==NSOrderedAscending && toCheck) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"BuildersAccess"
                                      message:@"Finish date is less than start date.\nAre you sure you want to continue?"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK", nil];
                alert.tag = 1;
                [alert show];
                return;
            }else{
                [wi2 addObject:ws];
            }
            
        }
    }
    
    [self doapprove];
    
}

-(void)doapprove{
    
    if ([wi2 count]>0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Are you sure you want to save?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        alert.tag = 0;
        [alert show];
        
        
    }else{
        UIAlertView *alert=[self getErrorAlert:@"There is nothing to update."];
        [alert show];
    }
    
    
    
}

-(void)doapprove2{
    curent=0;
    self.view.userInteractionEnabled=NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Updating Schedule...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [self doUpdateSchedule];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0){
	    switch (buttonIndex) {
			case 0:
				break;
			default:
                [self doapprove2];
				
				break;
		}
    }else if (alertView.tag == 1){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self todoupdate:NO];
				break;
		}
    }
}

-(void)doUpdateSchedule{
    if (curent < [wi2 count]) {
        wcfService* service = [wcfService service];
        wcfProjectSchedule *ws = [wi2 objectAtIndex:curent];
        //        NSLog(@"%@, %@, %@", xidproject, ws.Item, [ ws.Dcomplete substringFromIndex:16]);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xCompleteSchedule:self action:@selector(doxCompleteScheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xprojectid:xidproject refid:ws.Item completeDate:ws.DcompleteNew EquipmentType:@"5"];
    }else{
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        self.view.userInteractionEnabled=YES;
        [self goBack1];
    }
}
- (void) doxCompleteScheduleHandler: (id) value45 {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value45 isKindOfClass:[NSError class]]) {
        NSError *error = value45;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value45 isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value45;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value45];
        [alert show];
        return;
    }
    wcfProjectScheduleComplete  *pc =(wcfProjectScheduleComplete *)value45;
    //    NSLog(@"%@", pc);
    if ([pc.Flag isEqualToString:@"0"]) {
        
        curent+=1;
        [self doUpdateSchedule];
    }else if ([pc.Flag isEqualToString:@"2"]) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        self.view.userInteractionEnabled=YES;
        NSString *nst = @"The following step has to be completed before";
        
        nst=[NSString stringWithFormat:@"%@ %@\n",nst, ((wcfProjectSchedule *)[pc.ScheduleList objectAtIndex:0]).Name ];
        [pc.ScheduleList removeObjectAtIndex:0];
        for (wcfProjectSchedule *psd in pc.ScheduleList) {
            nst=[NSString stringWithFormat:@"%@\n%@",nst, psd.Name ];
        }
        UIAlertView *alert = [self getErrorAlert1: nst];
        [alert show];
        [self getMilestoneItem];
        return;
        
        
    }else if([pc.Flag isEqualToString:@"3"]){
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        self.view.userInteractionEnabled=YES;
        NSString *nst =@"Finish date can not be less than main step start date. Please re-schedule the main step in order to assign this date.";
        for (wcfProjectSchedule *psd in pc.ScheduleList) {
            nst=[NSString stringWithFormat:@"%@\n%@",nst, psd.Name ];
        }
        UIAlertView *alert = [self getErrorAlert1: nst];
        [alert show];
        [self getMilestoneItem];
        return;
    }else{
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        self.view.userInteractionEnabled=YES;
        [self getMilestoneItem];
        UIAlertView *alert = [self getErrorAlert: @"Something wrong happened."];
        [alert show];
    }
}

-(UIAlertView *)getErrorAlert1:(NSString *)str{
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
