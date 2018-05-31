//
//  mainmenuaaa.m
//  BuildersAccess
//
//  Created by amy zhao on 13-6-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "ciaList.h"
#import "wcfKeyValueItem.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "favorite.h"
#import "myprofile.h"
#import "cl_cia.h"
#import "userInfo.h"
#import "cl_phone.h"
#import "cl_project.h"
#import "Reachability.h"
#import "phonelist.h"
#import "projectls.h"
#import "MBProgressHUD.h"
#import "wcfService.h"
#import "cl_sync.h"
#import "forapprove.h"
#import "mastercialist.h"
#import "kirbytitle.h"
#import "mainmenu.h"
#import "cl_config.h"
#import "baControl.h"
#import "qacalendarViewController.h"
#import "multiSearch.h"
#import "selectioncalendar.h"
#import "BANavigationBar.h"

#define NAVBAR_HEIGHT   64

@interface mainmenuaaa ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@end

int currentpage, pageno;
NSString *atitle;

@implementation mainmenuaaa{
    int tbindex2;
}
@synthesize  navigationBar, tbindex, xget, menulist, detailstrarr, uw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    if (!menulist) {
        self.menulist =[[NSMutableArray alloc]init];
        self.detailstrarr=[[NSMutableArray alloc]init];
        wcfKeyValueItem *kv;
        NSString *details;
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Favorites";
        details = @"List of your favorites projects";
        [detailstrarr addObject:details];
        kv.Value=@"menu_favorite.png";
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"For Approve";
        details = @"List of your for approve";
        [detailstrarr addObject:details];
        kv.Value=@"menu_forapprove1.png";
        [menulist addObject:kv];
        
        NSArray *firstSplit = [xget componentsSeparatedByString:@";"];
        
        if ([[firstSplit objectAtIndex:0] hasSuffix:@"1"]) {
            kv =[[wcfKeyValueItem alloc]init];
            kv.Key=@"Kirby Title";
            details = @"List of Kirby Title";
            [detailstrarr addObject:details];
            kv.Value=@"kirbytitle.png";
            [menulist addObject:kv];
        }
        
        if ([[firstSplit objectAtIndex:1] hasSuffix:@"1"]) {
            kv =[[wcfKeyValueItem alloc]init];
            kv.Key=@"Selection Calendar";
            details = @"List of Selection Calendar";
            [detailstrarr addObject:details];
            kv.Value=@"kirbytitle.png";
            [menulist addObject:kv];
        }
        
        if ([[firstSplit objectAtIndex:2] hasSuffix:@"1"]) {
            kv =[[wcfKeyValueItem alloc]init];
            kv.Key=@"QA Calendar";
            details = @"List of Calendar QA";
            [detailstrarr addObject:details];
            kv.Value=@"calendarqa.png";
            [menulist addObject:kv];
        }
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Development";
        kv.Value=@"menu_development.png";
        details = @"Look up subdivision and site plans";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Active Units";
        kv.Value=@"menu_active.png";
        details = @"Projects under construction";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Not Started";
        kv.Value=@"menu_notstarted.png";
        details = @"Projects without scheduling";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Archive Units";
        kv.Value=@"menu_archive.png";
        details = @"Search closed projects information";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Phone List";
        kv.Value=@"menu_phonelist.png";
        details = @"Find coworkers contact information";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"My Profile";
        kv.Value=@"mp.png";
        details = @"Update your profile information";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        kv =[[wcfKeyValueItem alloc]init];
        if ([[self unlockPasscode] isEqualToString:@"0"] || [[self unlockPasscode] isEqualToString:@"1"]){
            kv.Key=@"Set PIN";
            kv.Value=@"sp.png";
            details = @"Add security level to your account";
        }else{
            kv.Key=@"Reset PIN";
            kv.Value=@"lock_open.png";
            details = @"Reset security level to your account";
        }
        
        
        
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Project Multi Search";
        kv.Value=@"zoom.png";
        details = @"Search projects by name for all the companies that you work with.";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
        if ([[firstSplit objectAtIndex:3] hasSuffix:@"1"]) {
            kv =[[wcfKeyValueItem alloc]init];
            kv.Key=@"Vendor Multi Search";
            kv.Value=@"zoom.png";
            details = @"Search vendors by name for all the companies that you work with.";
            [detailstrarr addObject:details];
            [menulist addObject:kv];
        }
        
        
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Logout";
        kv.Value=@"logout.png";
        details = @"Logout your account";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
        
    }
    
    
    
    
    int xw;
    int xh;
    if ([UIScreen mainScreen].bounds.size.width==748.0f) {
        xw= [UIScreen mainScreen].bounds.size.height;
        xh=[UIScreen mainScreen].bounds.size.width+1;
        
    }else{
        xw= [UIScreen mainScreen].bounds.size.width;
        xh= [UIScreen mainScreen].bounds.size.height+1;
    }
//    NSLog(@"%@", [UIScreen mainScreen]);
    
    UINavigationBar* navigationBar1 =  [[BANavigationBar alloc] initWithFrame:CGRectMake(0, 0, 300, NAVBAR_HEIGHT)];
//    navigationBar1.tintColor=[UIColor colorWithRed:0.1960784314 green:0.30980392159999998 blue:0.52156862749999999 alpha:1.f];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"BuildersAccess"];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"[="
//                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(gobig:)];
//    
//    item.leftBarButtonItem=leftButton;
    item.hidesBackButton = YES;
//    [[UINavigationBar appearance] setPrefersLargeTitles:YES];
    
    
//    [[UINavigationBar appearance] setLargeTitleTextAttributes:[NSForegroundColorAttributeName: [UIColor blueColor]]];
    navigationBar1.tag=101;
    [navigationBar1 pushNavigationItem:item animated:NO];
    
//    
//    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [menuButton setTitle:@"[=" forState:UIControlStateNormal];
//    [menuButton addTarget:self action:@selector(gobig:) forControlEvents:UIControlEventTouchUpInside];
//    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
//    UIView *menuButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [menuButtonContainer addSubview:menuButton];
//    UINavigationItem*ui= [navigationBar1.items objectAtIndex:0];
//    ui.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonContainer];
//    

    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"[=" style:UIBarButtonItemStylePlain target:self action:@selector(gobig:) ];
    //    anotherButton.title=@"Inspector";
    UINavigationItem*ui= [navigationBar1.items objectAtIndex:0];
    ui.leftBarButtonItem=anotherButton;
   
    [navigationBar1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationBar1];
    
    
    ciatbview1=[[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 300, xh-NAVBAR_HEIGHT-1)];
    ciatbview1.rowHeight = 70;
//    ciatbview1.separatorInset = UIEdgeInsetsZero;
//    ciatbview1.layoutMargins = UIEdgeInsetsZero;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:ciatbview1];
//    [ciatbview1 setBackgroundColor:[UIColor redColor]];
    ciatbview1.delegate = self;
    ciatbview1.dataSource = self;
    ciatbview1.tag=1;
    [ciatbview1 setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    [ciatbview1 selectRowAtIndexPath: [NSIndexPath indexPathForRow:tbindex inSection:0] animated:NO scrollPosition:0];
    if ((![self getIsTwoPart])) {
        navigationBar =  [[BANavigationBar alloc] initWithFrame:CGRectMake(0, 0, xw, NAVBAR_HEIGHT)];
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"=]" style:UIBarButtonItemStylePlain target:self action:@selector(gosmall:) ];
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"=]"
//                                                                          style: UIBarButtonItemStyleBordered
//                                                                         target:self
//                                                                         action:@selector(gosmall:) ];
      
        
        
        item = [[UINavigationItem alloc] initWithTitle:@"BuildersAccess"];
       
        item.leftBarButtonItem=anotherButton;
        
        uw=[[UIView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, xw, xh-NAVBAR_HEIGHT-50)];
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, xh-51, xw, 50)];
        
    }else{
        
        navigationBar =  [[BANavigationBar alloc] initWithFrame:CGRectMake(301, 0, xw-301, NAVBAR_HEIGHT)];
        item = [[UINavigationItem alloc] initWithTitle:@"BuildersAccess"];
        
        uw=[[UIView alloc]initWithFrame:CGRectMake(301, NAVBAR_HEIGHT, xw-301, xh-NAVBAR_HEIGHT-50)];
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(301, xh-51, xw-301, 50)];
    }
    
    navigationBar.items = [NSArray arrayWithObject:item];
    [navigationBar setBackgroundColor:[UIColor whiteColor]];
//    navigationBar.tintColor=[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1.f];
    
    UINavigationBar *navigationBar3 =  [[BANavigationBar alloc] initWithFrame:CGRectMake(0, 0, xw, 50)];
    
//    navigationBar3.tintColor=[UIColor colorWithRed:0.000078 green:0.093804 blue:0.300569 alpha:1.f];
    navigationBar3.tag=100;
    navigationBar3.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [ntabbar addSubview:navigationBar3];
    
    [self.view addSubview:navigationBar];
    
    NSArray *itemsArray =[NSArray arrayWithObjects: [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init],[[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], [[UITabBarItem alloc]init], nil];
    [ntabbar setItems:itemsArray animated:NO];
//    UITabBarItem *uim =[UITabBarItem alloc];

    for (int i=0; i<14; i++) {
        [[ntabbar.items objectAtIndex:i]setEnabled:NO ];
    }
    [self.view addSubview:ntabbar];
    [[ntabbar.items objectAtIndex:0] setTag: 1];
    [[ntabbar.items objectAtIndex:13] setTag: 2];
    ntabbar.delegate = self;
    [uw setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:uw];
    
    
}

-(IBAction)gosmall:(id)sender{
    int xw;
    int xh;
    if ([UIScreen mainScreen].bounds.size.width==748.0f) {
        xw= [UIScreen mainScreen].bounds.size.height;
        xh= [UIScreen mainScreen].bounds.size.width+1;
        
    }else{
        xw= [UIScreen mainScreen].bounds.size.width;
        xh= [UIScreen mainScreen].bounds.size.height+1;
    }
    navigationBar.frame=CGRectMake(301, 0, xw-301, NAVBAR_HEIGHT);
    
    CGRect ct = uw.frame;
    ct.origin.x = 301;
    ct.size.width = xw-301;
    uw.frame = ct;
    
//    for (UITableView *tb in uw.subviews) {
//        if ([tb isKindOfClass:[UITableView class]]) {
//            CGRect ct = tb.frame;
//            ct.origin.x = 301;
//            ct.size.width = xw-301;
//            tb.frame = ct;
//        }
//    }
    
//    uw.frame=CGRectMake(301, NAVBAR_HEIGHT, xw-301, xh-NAVBAR_HEIGHT-51);
     ct = ntabbar.frame;
    ct.origin.x = 301;
    ct.size.width = xw-301;
    ntabbar.frame = ct;
//    ntabbar.frame=CGRectMake(301, uw.frame.size.height + uw.frame.origin.y, xw-301, 50);
//    NSLog(@"frame\n%@\n%@", ntabbar, uw);
    UINavigationItem *item= [navigationBar.items objectAtIndex:0];
    item.leftBarButtonItem=nil;
    [self setIsTwoPart:YES];
}

-(IBAction)gobig:(id)sender{
    int xw;
    int xh;
    if (self.view.bounds.size.width==748.0f) {
        xw= self.view.bounds.size.height;
        xh=self.view.bounds.size.width+1;
        
    }else{
        xw= self.view.bounds.size.width;
        xh=self.view.bounds.size.height+1;
    }
    navigationBar.frame=CGRectMake(0, 0, xw, NAVBAR_HEIGHT);
    
    CGRect ct = uw.frame;
    ct.origin.x = 0;
    ct.size.width = xw;
    uw.frame = ct;
    
//    for (UITableView *tb in uw.subviews) {
//        if ([tb isKindOfClass:[UITableView class]]) {
//            CGRect ct = tb.frame;
//            ct.origin.x = 301;
//            ct.size.width = xw-301;
//            tb.frame = ct;
//        }
//    }
    
//    uw.frame=CGRectMake(0, NAVBAR_HEIGHT, xw, xh-NAVBAR_HEIGHT);
//    ntabbar.frame=CGRectMake(0, uw.frame.size.height + uw.frame.origin.y, xw, 50);
    ct = ntabbar.frame;
    ct.origin.x = 0;
    ct.size.width = xw;
    ntabbar.frame = ct;
    
//    NSLog(@"fasdfs\n%@\n%@", ntabbar, uw);
    UINavigationItem *item= [navigationBar.items objectAtIndex:0];
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"=]" style:UIBarButtonItemStyleBordered target:self action:@selector(gosmall:)];
    [self setIsTwoPart:NO];
}

-(void)changePin{
    wcfKeyValueItem *kv= [menulist objectAtIndex:([menulist count]-4)];
    
    NSString *str =[detailstrarr objectAtIndex:([menulist count]-4)];
    if ([[self unlockPasscode] isEqualToString:@"0"] || [[self unlockPasscode] isEqualToString:@"1"]){
        kv.Key=@"Set PIN";
        kv.Value=@"sp.png";
        str =@"Add security level to your account";
    }else{
        kv.Key=@"Reset PIN";
        kv.Value=@"lock_open.png";
        str =@"Reset security level to your account";
    }
    [detailstrarr removeObjectAtIndex:([menulist count]-4)];
    [detailstrarr insertObject:str atIndex:([menulist count]-4)];
    [ciatbview1 reloadData];
}



-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
    if ( [self getIsTwoPart] && uw.frame.size.width==self.view.bounds.size.width) {
        [self gosmall:nil];
    }else if ( (![self getIsTwoPart]) && uw.frame.size.width!=self.view.bounds.size.width){
        [self gobig:nil];
    }
}


-(void)gootoonextPage:(mainmenuaaa *)ma{
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[mainmenu class]]) {
        [self.navigationController pushViewController:ma animated:NO];
    }else{
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        while ([controllers count]>2) {
            [controllers removeLastObject];
        }
        [controllers addObject:ma];
        [self.navigationController setViewControllers:controllers animated:NO];
    }
}
-(void)setTitle:(NSString *)title1{
    UINavigationItem *item = [navigationBar.items objectAtIndex:0];
    [item setTitle:title1];
}

-(NSString *)getTitle{
    UINavigationItem *item = [navigationBar.items objectAtIndex:0];
    return item.title;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([ciatbview1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [ciatbview1 setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([ciatbview1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [ciatbview1 setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menulist count]; // or self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView.frame.size.height==754) {
//        tableView.frame=CGRectMake(0, NAVBAR_HEIGHT, 300, 704);
//    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    wcfKeyValueItem *kv = [menulist objectAtIndex:indexPath.row];
    
    cell.textLabel.text = kv.Key;
    cell.detailTextLabel.numberOfLines=2;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.text = [detailstrarr objectAtIndex:indexPath.row];
    [cell.detailTextLabel sizeToFit];
    [cell .imageView setImage:[UIImage imageNamed:kv.Value]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"dsfasdfsdf");
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        tbindex2=indexPath.row;
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler9999:) version:version];
    }
}
- (void) xisupdate_iphoneHandler9999: (id) value {
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
        [self gotonextpage999];
    }
    
    
}

-(BOOL)getIsTwoPart{
    cl_config *fa = [[cl_config alloc]init];
    fa.managedObjectContext=self.managedObjectContext;
    return [fa getIsTwoPart];
    
};
-(void)setIsTwoPart:(BOOL)bl{
    cl_config *fa = [[cl_config alloc]init];
    fa.managedObjectContext=self.managedObjectContext;
    return [fa setIsTwoPart:bl];
};

-(void)gotonextpage999{
    NSIndexPath *indexPath = [ciatbview1 indexPathForSelectedRow];
    [ciatbview1 deselectRowAtIndexPath:indexPath animated:YES];
    wcfKeyValueItem *kv  =[menulist objectAtIndex:indexPath.row];
    atitle=kv.Key;
    if ([atitle isEqualToString:@"Phone List"]) {
        wcfService *service =[wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler1111:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"5"];
    }else{
        
        if ([kv.Key isEqualToString:@"Favorites"]) {
            
            favorite *ft =[[favorite alloc]init];
            ft.managedObjectContext=self.managedObjectContext;
            ft.title=kv.Key;
            [ft setIsTwoPart:NO];
            ft.menulist=self.menulist;
            ft.detailstrarr=self.detailstrarr;
            ft.tbindex=indexPath.row;
            [self gootoonextPage:ft];
        }else if([kv.Key isEqualToString:@"My Profile"]){
            myprofile *ft =[[myprofile alloc]init];
            ft.managedObjectContext=self.managedObjectContext;
            ft.menulist=self.menulist;
            ft.detailstrarr=self.detailstrarr;
            ft.tbindex=tbindex2;
            [ft setIsTwoPart:NO];
            [self gootoonextPage:ft];
        }else if([kv.Key isEqualToString:@"Logout"]){
            [self logout:nil];
        }else if([kv.Key hasPrefix:@"Project"] || [kv.Key hasPrefix:@"Vendor"]){
//            [self logout:nil];
            atitle=kv.Key;
            wcfService *service =[wcfService service];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler1111:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"5"];
        }else if([kv.Key isEqualToString:@"Set PIN"]){
            [self setPasscode:nil];
        }else if([kv.Key isEqualToString:@"Reset PIN"]){
            [self changePasscode:nil];
        }else if([kv.Key isEqualToString:@"For Approve"]){
            wcfService *service =[wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler1111:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"5"];
            
        }else if([kv.Key isEqualToString:@"Kirby Title"]){
            
            [userInfo initCiaInfo:1 andNm:@""];
            kirbytitle *k =[[kirbytitle alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.title=kv.Key;
            k.menulist=self.menulist;
            k.detailstrarr=self.detailstrarr;
            [k setIsTwoPart:NO];
            k.tbindex=indexPath.row;
            [self gootoonextPage:k];
       
        }else if([kv.Key isEqualToString:@"Selection Calendar"]){
            
            [userInfo initCiaInfo:1 andNm:@""];
            selectioncalendar *k =[[selectioncalendar alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.title=kv.Key;
            k.menulist=self.menulist;
            k.detailstrarr=self.detailstrarr;
            k.tbindex=indexPath.row;
            [k setIsTwoPart:NO];
            [self gootoonextPage:k];
        }else if([kv.Key isEqualToString:@"QA Calendar"]){
            
            [userInfo initCiaInfo:1 andNm:@""];
            qacalendarViewController *k =[[qacalendarViewController alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.title=kv.Key;
            k.menulist=self.menulist;
            k.detailstrarr=self.detailstrarr;
            k.tbindex=indexPath.row;
            [k setIsTwoPart:NO];
            [self gootoonextPage:k];
            
        }else{
            cl_cia *mc=[[cl_cia alloc]init];
            mc.managedObjectContext=self.managedObjectContext;
            NSMutableArray *na = [mc getCiaList];
            if ([na count]>1) {
                ciaList *LoginS=[[ciaList alloc]init];
                LoginS.menulist=self.menulist;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.tbindex=indexPath.row;
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.title=kv.Key;
                [LoginS setIsTwoPart:NO];
                [self gootoonextPage:LoginS];
            }else{
                
                if([na count]==1){
                    NSEntityDescription *cia =[na objectAtIndex:0];
                    [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"]integerValue] andNm:[cia valueForKey:@"cianame"]];
                    
                    if ([atitle isEqualToString:@"Phone List"]) {
                        cl_phone *mp =[[cl_phone alloc]init];
                        mp.managedObjectContext=self.managedObjectContext;
                        if ([mp IsFirstTimeToSyncPhone]) {
                            UIAlertView *alert = nil;
                            alert = [[UIAlertView alloc]
                                     initWithTitle:@"BuildersAccess"
                                     message:@"This is the first time, we will sync Phone Lis with your ipad, this will take some time, Are you sure you want to continue?"
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"Continue", nil];
                            alert.tag = 2;
                            [alert show];
                        }else{
                            [self gotoNextPage];
                            
                        }
                    }else{
                        cl_sync *mp =[[cl_sync alloc]init];
                        mp.managedObjectContext=self.managedObjectContext;
                        if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId] ]stringValue] :@"1"]) {
                            UIAlertView *alert = nil;
                            alert = [[UIAlertView alloc]
                                     initWithTitle:@"BuildersAccess"
                                     message:@"This is the first time, we will sync all projects with your ipad, this will take some time, Are you sure you want to continue?"
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"Continue", nil];
                            alert.tag = 0;
                            [alert show];
                        }else{
                            [self gotoNextPage];
                        }
                    }
                }
            }
        }
    }
    
    
}

- (void) xGetMasterCiaHandler1111: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
	if ([atitle isEqualToString:@"Phone List"]) {
        if ([result count]>1) {
            mastercialist *fr =[[mastercialist alloc]init];
            
            fr.menulist=self.menulist;
            fr.detailstrarr=self.detailstrarr;
            fr.tbindex=tbindex2;
            fr.managedObjectContext=self.managedObjectContext;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=@"Phone List";
            [fr setIsTwoPart:NO];
            [self gootoonextPage:fr];
            
        }else{
            wcfKeyValueItem *kv =[result objectAtIndex:0];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            cl_phone *mp =[[cl_phone alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            if ([mp IsFirstTimeToSyncPhone]) {
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"This is the first time, we will sync Phone Lis with your ipad, this will take some time, Are you sure you want to continue?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Continue", nil];
                alert.tag = 2;
                [alert show];
            }else{
                phonelist *pl =[phonelist alloc];
                pl.managedObjectContext=self.managedObjectContext;
                pl.detailstrarr=self.detailstrarr;
                pl.menulist=self.menulist;
                pl.tbindex=tbindex2;
                [pl setIsTwoPart:NO];
                pl.isfrommainmenu=YES;
                [self gootoonextPage:pl];
                
            }
            
        }
    }else if ([atitle isEqualToString:@"For Approve"]) {
        if ([result count]>1) {
            mastercialist *fr =[[mastercialist alloc]init];
            fr.managedObjectContext=self.managedObjectContext;
            fr.tbindex=tbindex2;
            fr.menulist=self.menulist;
            fr.detailstrarr=self.detailstrarr;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=@"For Approve";
            [fr setIsTwoPart:NO];
            [self gootoonextPage:fr];
        }else{
            wcfKeyValueItem *kv =[result objectAtIndex:0];
            forapprove *fr =[[forapprove alloc]init];
            fr.managedObjectContext=self.managedObjectContext;
            fr.mastercia=kv.Key;
            fr.tbindex=tbindex2;
            fr.menulist=self.menulist;
            fr.detailstrarr=self.detailstrarr;
            [fr setIsTwoPart:NO];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            [fr setTitle:@"For Approve"];
            [self gootoonextPage:fr];
        }
    }else{
        if ([result count]>1) {
            mastercialist *fr =[[mastercialist alloc]init];
            fr.managedObjectContext=self.managedObjectContext;
            fr.tbindex=tbindex2;
            fr.atitle=atitle;
            fr.menulist=self.menulist;
            fr.detailstrarr=self.detailstrarr;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=atitle;
             [fr setIsTwoPart:NO];
            [self gootoonextPage:fr];
        }else{
             wcfKeyValueItem *kv =[result objectAtIndex:0];
            multiSearch *k =[[multiSearch alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.menulist=self.menulist;
            k.detailstrarr=self.detailstrarr;
            k.tbindex=tbindex2;
            k.atitle=atitle;
            k.isfrommainmenu=YES;
             [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
             [k setIsTwoPart:NO];
            [self gootoonextPage:k];

        }

    }
}

- (void)orientationChanged{
    int xw;
    int xh;
    if (self.view.bounds.size.width==748.0f) {
        xw= self.view.bounds.size.height;
        xh=self.view.bounds.size.width+1;
        
    }else{
        xw= self.view.bounds.size.width;
        xh=self.view.bounds.size.height+1;
    }
    
    bool isBig;
    if (ntabbar.frame.origin.x==0) {
        isBig=YES;
    }else{
        isBig=NO;
    }
    if (self.view.bounds.size.width==1024.0f && ciatbview1.frame.size.height!=748) {
        for (UIView *uh in self.view.subviews) {
            if (isBig) {
                if (uh.tag==1) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, uh.frame.size.width,xh-1-NAVBAR_HEIGHT);
                }else if (uh.tag==101) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, 300, NAVBAR_HEIGHT);
                }else if (uh==ntabbar) {
                    uh.frame=CGRectMake(0, xh-51, xw, 50);
                    //                    NSLog(@"%@", [ntabbar viewWithTag:100]);
                    //                    [ntabbar viewWithTag:100].frame=CGRectMake(0, xh-51, xw, 50);
                }else if (uh==navigationBar) {
                    uh.frame=CGRectMake(0, 0, xw, NAVBAR_HEIGHT);
                }else{
                    uh.frame=CGRectMake(0, uh.frame.origin.y, xw, xh-1-NAVBAR_HEIGHT-50);
                }
            }else{
                if (uh.tag==1) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, uh.frame.size.width,xh-1-NAVBAR_HEIGHT);
                }else if (uh.tag==101) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, 300, NAVBAR_HEIGHT);
                }else if (uh==ntabbar) {
                    uh.frame=CGRectMake(301, xh-51, xw-301, 50);
                    //                    NSLog(@"%@", [ntabbar viewWithTag:100]);
                    //                    [ntabbar viewWithTag:100].frame=CGRectMake(301, xh-51, xw-301, 50);
                }else if (uh==navigationBar) {
                    uh.frame=CGRectMake(301, 0, xw-301, NAVBAR_HEIGHT);
                }else{
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, xw-301, xh-1-NAVBAR_HEIGHT-50);
                }
                
            }
            
        }
    }else if (self.view.bounds.size.width==768.0f && ciatbview1.frame.size.height!=1004 ){
        for (UIView *uh in self.view.subviews) {
            if (isBig) {
                if (uh.tag==1) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, uh.frame.size.width,xh-1-NAVBAR_HEIGHT);
                }else if (uh.tag==101) {
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, 300, NAVBAR_HEIGHT);
                }else if (uh==ntabbar) {
                    uh.frame=CGRectMake(0, xh-51, xw, 50);
                }else if (uh==navigationBar) {
                    uh.frame=CGRectMake(0, 0, xw, NAVBAR_HEIGHT);
                }else{
                    uh.frame=CGRectMake(0, uh.frame.origin.y, xw, xh-1-NAVBAR_HEIGHT-50);
                }
            }else{
                if (uh.tag==1) {
                    uh.frame=CGRectMake(0, NAVBAR_HEIGHT, 300, xh-1-NAVBAR_HEIGHT);
                }else if (uh.tag==101) {
                    uh.frame=CGRectMake(0, 0, 300, NAVBAR_HEIGHT);
                }else if (uh==ntabbar) {
                    uh.frame=CGRectMake(301, xh-51, xw-301, 50);
                }else if (uh==navigationBar) {
                    uh.frame=CGRectMake(301, 0, xw-301, NAVBAR_HEIGHT);
                }else{
                    uh.frame=CGRectMake(uh.frame.origin.x, uh.frame.origin.y, xw-301, xh-1-NAVBAR_HEIGHT-50);
                }
            }
        }
    }
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self getProjectList:1];
            }
                break;
                
		}
		return;
	}else if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
        }
    }
}


-(void)getProjectList:(int)xpageNo {
    
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        if (xpageNo==1) {
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Project..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Synchronizing Project...  ";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
        }else{
            HUD.progress= (currentpage*1.0/pageno);
            
        }
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xSearchProject:self action:@selector(xSearchProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  xtype: 0 currentPage: xpageNo EquipmentType: @"3"];
    }
    
    
}

- (void) xSearchProjectHandler: (id) value {
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        if ([result count]>0) {
            wcfProjectListItem *kv;
            
            
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageno=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            NSString *syn = kv.IDNumber;
            [result removeObjectAtIndex:0];
            
            
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToProject:result andscheleyn:syn];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self getProjectList:currentpage];
            }else{
                HUD.progress = 1;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [HUD hide];
                
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                
                
                [self gotoNextPage];
            }
        }else{
            //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //
            //            [HUD hide];
            //
            //            UIAlertView *av =[self getErrorAlert:@"You have no authority to access projects."];
            //
            //            [av show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
            
            
            [self gotoNextPage];
            
        }
        
    }
}

-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Phone List..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Phone List...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"5"];
    }
    
}

- (void) xGetPhoneListHandler: (id) value {
    
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [self gotoNextPage];
    
}



-(void)gotoNextPage{
    if([atitle isEqualToString:@"Phone List" ]){
        phonelist *pl =[phonelist alloc];
        pl.menulist=self.menulist;
        pl.detailstrarr=self.detailstrarr;
        pl.tbindex=tbindex2;
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=atitle;
        pl.isfrommainmenu=YES;
        [pl setIsTwoPart:NO];
        [self gootoonextPage:pl];
    }else {
        projectls *LoginS=[projectls alloc];
        LoginS.menulist=self.menulist;
        LoginS.detailstrarr=self.detailstrarr;
        LoginS.tbindex=tbindex2;
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.isfrommainmenu=YES;
        LoginS.title=atitle;
        [LoginS setIsTwoPart:NO];
        [self gootoonextPage:LoginS];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
