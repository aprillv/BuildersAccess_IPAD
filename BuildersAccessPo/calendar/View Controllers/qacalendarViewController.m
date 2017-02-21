//
//  qacalendarViewController.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "qacalendarViewController.h"
#import "CKCalendarView.h"

#import "NSCalendarCategories.h"
#import "Mysql.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "qainspectionb.h"
#import "qainspection.h"
#import "qaInspector.h"
#import "wcfArrayOfKirbytileItem2.h"

@interface  qacalendarViewController()<CKCalendarViewDataSource, CKCalendarViewDelegate>{
    int donext;
    NSDate *tmpdate;
    int i;
    NSDateFormatter *dateFormatter;
      UIScrollView *uv;
}

@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;


@end

NSString *tdate;
@implementation qacalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        i=0;
        tmpdate=[NSDate date];
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

//- (void)orientationChanged{
////    [super orientationChanged];
//    [[self calendarView] layoutSubviews];
////    searchtxt.frame= CGRectMake(0, 0, self.uw.frame.size.width, 44);
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    donext=1;
    [self setTitle:@"QA"];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Inspector" style:UIBarButtonItemStyleBordered target:self action:@selector(openInspection:) ];
    //    anotherButton.title=@"Inspector";
   UINavigationItem*ui= [self.navigationBar.items objectAtIndex:0];
    ui.rightBarButtonItem=anotherButton;
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
        [self goBack: nil];
    }else if(item.tag == 2) {
        [self dorefresh:nil];
    }
}

-(IBAction)openInspection:(id)sender{
    donext=2;
    [self doupdatecheck];
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
        [service xGetQACalendarListPad:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:@"1" tdate:[self stringFromDate2:tmpdate] EquipmentType:@"5"];
    }
}

- (void) xGetEmailListHandler: (id) value {
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
-(void)doClicked:(int)idnumber{
    tdate=[NSString stringWithFormat:@"%d", idnumber];
    donext=1;
    [self doupdatecheck];
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
    CGRect rt = uv.frame;
    rt.origin.x=0;
    rt.origin.y=0;
    rt.size.width=self.uw.frame.size.width;
    uv.frame=rt;
     uv.contentSize=CGSizeMake( [self calendarView].frame.size.width, self.uw.frame.size.height);
//    rt= [self calendarView].frame;
//    CGSize cg = rt.size;
//    uv.contentSize=cg;
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
-(void)reloadMyEvent:(NSDate *)date{
    
    tmpdate=date;
    [self dorefresh:nil];
}
- (NSMutableArray *)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
    
    NSString* str=[NSString stringWithFormat:@"MDate='%@'", [self stringFromDate2:date]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    
    NSMutableArray *tt1 = (NSMutableArray *)[[self events] filteredArrayUsingPredicate:predicate];
    return tt1;
}




-(NSString *)stringFromDate2:(NSDate *)date{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

#pragma mark - CKCalendarViewDelegate

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
    
//    NSString* str=[NSString stringWithFormat:@"SELF = '%@'", [self stringFromDate2:date]];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//    NSMutableArray *na =[[[self events] filteredArrayUsingPredicate:predicate] mutableCopy];
//    if ([na count]>0) {
//        tdate=na[0];
//        //        kirbytitlelist * kl =[[kirbytitlelist alloc]init];
//        //        kl.managedObjectContext=self.managedObjectContext;
//        //        kl.tdate=na[0];
//        //        [self.navigationController pushViewController:kl animated:YES];
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.labelText=@"   Loading Event...   ";
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        [HUD show:YES];
//        
//        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
//        NetworkStatus netStatus = [curReach currentReachabilityStatus];
//        if (netStatus ==NotReachable) {
//            [HUD hide:YES];
//            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
//            [alert show];
//            [ntabbar setSelectedItem:nil];
//        }else{
//            wcfService* service = [wcfService service];
//            NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//            
//            
//            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler1:) version:version];
//        }
//    }else{
//        [[self calendarView]setEvents1:nil];
//    }
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    //    NSLog(@"%f", [self calendarView].frame.size.height);
    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSInteger weeksCount=weekRange.length;
    int dw = calendarView.frame.size.width;
    
    if (weeksCount==6) {
        uv.contentSize=CGSizeMake(dw, 1066);
    }else{
       uv.contentSize=CGSizeMake(dw, 654);
    }
    
//    if( [calender monthsInDate:tmpdate]!= [calender monthsInDate:date]){
//        tmpdate=date;
//        [self dorefresh:nil];
//    }
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(wcfKirbytileItem *)event{
    tdate=event.Idnumber;
    donext=1;
    [self doupdatecheck];
   }

-(void)doupdatecheck{
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
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (donext==1) {
            [service xGetQACalendarStatus:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:tdate EquipmentType:@"5"];
        }else{
        
            // donext =2
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            qaInspector *qr = [qaInspector alloc];
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
            }
            qr.tbindex=self.tbindex;
            qr.detailstrarr=self.detailstrarr;
            qr.menulist=self.menulist;
            [dateFormatter setDateFormat:@"yyyy"];
            qr.managedObjectContext=self.managedObjectContext;
            qr.xyear= [dateFormatter stringFromDate:[[self calendarView] date]];
            
            [self.navigationController pushViewController:qr animated:NO];
        }
        
        
        
        
    }
}


- (void) xisupdate_iphoneHandler3: (id) value {
    
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
    if ([result2 isEqualToString:@"0"]) {
          UIAlertView *alert = [self getErrorAlert: @"There is no QA Inspection in this event."];
        [alert show];
        return;
        
    }else{
        
        if ([result2 isEqualToString:@"Not Started"] || [result2 isEqualToString:@"Not Ready"]) {
            qainspection *qt =[qainspection alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=tdate;
            qt.fromtype=1;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            [self.navigationController pushViewController:qt animated:NO];
        }else{
            qainspectionb *qt =[qainspectionb alloc];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=tdate;
            qt.fromtype=1;
            qt.tbindex=self.tbindex;
            qt.menulist=self.menulist;
            qt.detailstrarr=self.detailstrarr;
            [self.navigationController pushViewController:qt animated:NO];
        }
        
        
        
    }
}


#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

@end

