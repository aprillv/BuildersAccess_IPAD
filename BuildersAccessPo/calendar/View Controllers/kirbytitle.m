
//
//  kirbytitle.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-31.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//


#import "kirbytitle.h"
#import "CKCalendarView.h"

#import "NSCalendarCategories.h"
#import "Mysql.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "kirbytitledetail.h"
#import "wcfArrayOfKirbytileItem2.h"

@interface kirbytitle ()<CKCalendarViewDataSource, CKCalendarViewDelegate>{
  UIScrollView *uv;
}

@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;


@end


@implementation kirbytitle{
    NSDateFormatter *dateFormatter;
    NSDate * tmpdate;
    NSString *tdate;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tmpdate=[NSDate date];
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




-(void)reloadMyEvent:(NSDate *)date{
    
    tmpdate=date;
    //    i=1;
    [self dorefresh:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Kirby Title"];
    
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
    
        [service xGetKirbyTitleListPad:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:@"1" tdate:[self stringFromDate2:tmpdate]  EquipmentType:@"5"];
    }
}
-(void)doClicked:(int)idnumber{
    tdate=[NSString stringWithFormat:@"%d", idnumber];
//    NSLog(@"%@", tdate);
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
    
//    rt= [self calendarView].frame;
//    CGSize cg = rt.size;
//    uv.contentSize=cg;
    
     uv.contentSize=CGSizeMake( [self calendarView].frame.size.width, self.uw.frame.size.height);
    
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
    

    
    NSCalendar *calender = [NSCalendar currentCalendar];
    //    NSLog(@"%f", [self calendarView].frame.size.height);
    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSInteger weeksCount=weekRange.length;
    int dw = calendarView.frame.size.width;
    
//    if (weeksCount==6) {
//        uv.contentSize=CGSizeMake(dw, 1066);
//    }else{
//        uv.contentSize=CGSizeMake(dw, 944);
//    }
    
    if (weeksCount==6) {
        uv.contentSize=CGSizeMake(dw, 776);
    }else{
        uv.contentSize=CGSizeMake(dw, 654);
    }
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
        kirbytitledetail *pd =[[kirbytitledetail alloc]init];
        pd.managedObjectContext=self.managedObjectContext;
        pd.idnumber=tdate;
//        pd.menulist=self.menulist;
//        pd.detailstrarr=self.detailstrarr;
//        pd.tbindex=self.tbindex;
//        [self.navigationController pushViewController:pd animated:NO];
        
       
        pd.modalPresentationStyle = UIModalPresentationFormSheet;
        //        testVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:pd animated:YES completion:nil];
        pd.view.superview.frame = CGRectMake(0, 0, 650, 500);//it's important to do this after presentModalViewController
        pd.view.superview.center = self.view.center;
        
    }
}


#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

@end
