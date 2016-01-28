//
//  selectioncalendar.m
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "selectioncalendar.h"
#import "CKCalendarView.h"

#import "NSCalendarCategories.h"
#import "Mysql.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "selectiondetail.h"
#import "selectionDetailq.h"
@interface selectioncalendar ()<CKCalendarViewDataSource, CKCalendarViewDelegate>{

}

@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, retain) NSMutableArray *events;


@end


@implementation selectioncalendar{
    NSString *tdate;
    UIScrollView *uv;
    NSDateFormatter *dateFormatter;
    NSDate *tmpdate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}
-(IBAction)dorefresh:(id)sender{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
    }
    HUD.labelText=@"   Loading Data...   ";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [self loadDot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Selection Calendar"];
    tmpdate=[NSDate date];
//    curdate=[self stringFromDate2:[NSDate date]];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
    //    UITabBarItem *t = [ntabbar.items objectAtIndex:13];
    //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
    //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setEnabled :YES];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh:) ];
   
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self dorefresh: nil];
    }
}


-(void)loadDot{
    if ([self calendarView]) {
        [[self calendarView] removeFromSuperview];
       self.calendarView=nil;
    }
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetSelectionCalendarListPad:self action:@selector(xGetSelectionCalendarCntHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:@"1" tdate:[self stringFromDate2:tmpdate] EquipmentType:@"5"];
    }
}

- (void) xGetSelectionCalendarCntHandler: (id) value {
    [HUD hide:YES];
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
    
    NSMutableArray *a=[((wcfArrayOfKirbytileItem2 *)value) toMutableArray];
    
   
   [self setEvents:a];

    
        CKCalendarView *cv = [CKCalendarView new];
        cv.xtype=1;
        [self setCalendarView:cv];
        [[self calendarView] setDataSource:self];
        [[self calendarView] setDelegate:self];
    if (!uv) {
         uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width,self.uw.frame.size.height)];
         [self.uw addSubview:uv];
    }
    
        //    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [uv addSubview:[self calendarView]];
        //    uv.contentSize=CGSizeMake([self calendarView].frame.size.width, [self calendarView].frame.size.height+1);
       
        [ntabbar setSelectedItem:nil];
        
        [[self calendarView] setDate:tmpdate animated:NO];

    
    
}

-(void)orientationChanged{
    [super orientationChanged];
    CGRect rt = uv.frame;
    rt.origin.x=0;
    rt.origin.y=0;
    rt.size.width=self.uw.frame.size.width;
    rt.size.height=self.uw.frame.size.height;
    uv.frame=rt;
    
    rt= [self calendarView].frame;
    CGSize cg = rt.size;
    uv.contentSize=cg;
    [[self calendarView]layoutSubviews];
}
-(void)dismissModalViewControllerAnimated:(BOOL)animated{
    NSLog(@"ddddddd");
}
-(void)gobig:(id)sender{
    [super gobig:sender];
    CGRect rt = uv.frame;
    rt.origin.x=0;
    rt.origin.y=0;
    rt.size.width=self.uw.frame.size.width;
    uv.frame=rt;
    
    rt= [self calendarView].frame;
    CGSize cg = rt.size;
    uv.contentSize=cg;
    [[self calendarView]layoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    if (uv) {
        [self.calendarView removeFromSuperview];
        self.calendarView=nil;
         [uv removeFromSuperview];
        uv=nil;
    }
   
    [self orientationChanged];
    [self dorefresh:nil];
}
-(void)gosmall:(id)sender{
    [super gosmall:sender];
//    uv.frame=self.uw.frame;
//    NSLog(@"%f %f", self.uw.frame.size.width);
    CGRect rt = uv.frame;
    rt.origin.x=0;
    rt.origin.y=0;
    rt.size.width=self.uw.frame.size.width;
    uv.frame=rt;
    uv.contentSize=CGSizeMake( [self calendarView].frame.size.width, self.uw.frame.size.height);
    
//    rt= [self calendarView].frame;
//    CGSize cg = rt.size;
//    uv.contentSize=cg;
    
//    rt.origin.x=0;
//    rt.origin.y=0;
//    [self calendarView].frame=rt;
//    [uv reloadInputViews];
    
//    NSLog(@"%f %f %f %f %f %f %f %f", [self calendarView].frame.size.height, [self calendarView].frame.size.width, uv.frame.origin.x, uv.frame.origin.y, uv.contentSize.width, uv.contentSize.height, uv.frame.size.width, uv.frame.size.height);
    
    
//    [[self calendarView] removeFromSuperview];
//    [uv addSubview:[self calendarView]];
    [[self calendarView]layoutSubviews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Toolbar Items

- (void)modeChangedUsingControl:(id)sender
{
    [[self calendarView] setDisplayMode:[[self modePicker] selectedSegmentIndex]];
}

- (void)todayButtonTapped:(id)sender
{
    [[self calendarView] setDate:[NSDate date] animated:NO];
}

#pragma mark - CKCalendarViewDataSource

- (NSMutableArray *)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
//    NSString *tt;
////    tt = [self stringFromDate2:[CalendarView date]];
////    NSLog(@"t %@", tt);
//    
//    tt = [self stringFromDate3:date];
    
    NSString *ct=[self stringFromDate2:date];
    NSString* str=[NSString stringWithFormat:@"MDate='%@'",ct];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    
    NSMutableArray *tt1 = (NSMutableArray *)[[self events] filteredArrayUsingPredicate:predicate];
    return tt1;
//    NSLog(@"c %@", ct);
//    if (!lastDate) {
//        lastDate=tt;
//        NSString* str=[NSString stringWithFormat:@"MDate='%@'", ct];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//        
//        NSMutableArray *tt1 = (NSMutableArray *)[[self events] filteredArrayUsingPredicate:predicate];
//        return tt1;
//    }else{
//        
//        if ([tt hasPrefix:@"0"]) {
//            tt=[tt substringFromIndex:1];
//        }
//        if (1==2) {
//            lastDate=tt;
//            [self loadDot:ct];
//            return nil;
//        }else{
//            lastDate=tt;
//            curdate= [self stringFromDate2:date];
//            NSString* str=[NSString stringWithFormat:@"MDate='%@'",ct];
//            NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//            
//            NSMutableArray *tt1 = (NSMutableArray *)[[self events] filteredArrayUsingPredicate:predicate];
//            return tt1;
//        }
//        
//    }
   
    
}




-(NSString *)stringFromDate2:(NSDate *)date{
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

-(NSString *)stringFromDate3:(NSDate *)date{
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"MM/yyyy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}


#pragma mark - CKCalendarViewDelegate
-(void)reloadMyEvent:(NSDate *)date{
    
    tmpdate=date;
//    i=1;
    [self dorefresh:nil];
}
// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    //    if ([self isEqual:[self delegate]]) {
    //        return;
    //    }
    //
    //    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
    //        [[self delegate] calendarView:calendarView willSelectDate:date];
    //    }
}

- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
      
            
            
            
            //    uv.contentSize=CGSizeMake(calendarView.frame.size.width, calendarView.frame.size.height);
//            NSString* str=[NSString stringWithFormat:@"SELF = '%@'",curdate ];
//            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//            NSMutableArray *na =[[[self events] filteredArrayUsingPredicate:predicate] mutableCopy];
//            if ([na count]>0) {
//                tdate=na[0];
//                //        kirbytitlelist * kl =[[kirbytitlelist alloc]init];
//                //        kl.managedObjectContext=self.managedObjectContext;
//                //        kl.tdate=na[0];
//                //        [self.navigationController pushViewController:kl animated:YES];
//                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                [self.navigationController.view addSubview:HUD];
//                HUD.labelText=@"   Loading Event...   ";
//                HUD.dimBackground = YES;
//                HUD.delegate = self;
//                [HUD show:YES];
//                
//                Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
//                NetworkStatus netStatus = [curReach currentReachabilityStatus];
//                if (netStatus ==NotReachable) {
//                    [HUD hide:YES];
//                    UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
//                    [alert show];
//                    [ntabbar setSelectedItem:nil];
//                }else{
//                    wcfService* service = [wcfService service];
//                    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//                    
//                    
//                    [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler1:) version:version];
//                }
//            }else{
//                [[self calendarView]setEvents1:nil];
//                
//            }
//   NSString* curdate= [self stringFromDate2:date];
    //    NSDate *date = [NSDate date];//as your are forming date, put it here
    NSCalendar *calender = [NSCalendar currentCalendar];
    //    NSLog(@"%f", [self calendarView].frame.size.height);
    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSInteger weeksCount=weekRange.length;
    int dw = calendarView.frame.size.width;
    
    if (weeksCount==6) {
        uv.contentSize=CGSizeMake(dw, 776);
    }else{
        uv.contentSize=CGSizeMake(dw, 654);
    }
    
//if( [calender monthsInDate:tmpdate]!= [calender monthsInDate:date]){
//    tmpdate=date;
//    [self dorefresh:nil];
//}

    
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(wcfKirbytileItem *)event{
    tdate=event.Idnumber;
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
        
        
        selectionDetailq *testVC = [[selectionDetailq alloc]init];
        testVC.managedObjectContext=self.managedObjectContext;
        testVC.idnumber=tdate;
        testVC.modalPresentationStyle = UIModalPresentationFormSheet;
//        testVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:testVC animated:YES completion:^() {
//            NSLog(@"ffff");
        }];
        testVC.view.superview.frame = CGRectMake(0, 0, 650, 500);//it's important to do this after presentModalViewController
        testVC.view.superview.center = self.view.center;
        
//        selectionDetailq *passcodeViewController = [[selectionDetailq alloc] init];
//       
//        [self presentViewController:passcodeViewController animated:YES completion:nil];
        
//        UIView *tt =[[UIView alloc]initWithFrame:CGRectMake(10, 10, 360, 500)];
//        tt.backgroundColor=[UIColor whiteColor];
//    
//        
//        [self.view addSubview:tt];
//        [self.view layoutSubviews];
        
//        selectiondetail *pd =[[selectiondetail alloc]init];
//        pd.managedObjectContext=self.managedObjectContext;
//        pd.idnumber=tdate;
//         pd.modalPresentationStyle = UIModalPresentationFormSheet;
////        pd.menulist=self.menulist;
////        pd.detailstrarr=self.detailstrarr;
////        pd.tbindex=self.tbindex;
//    
////        [self.navigationController pushViewController:pd animated:NO];
//        [self.view addSubview:pd.view];
    }
}



-(void)doClicked:(int)idnumber{
    tdate=[NSString stringWithFormat:@"%d", idnumber];
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

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

@end
