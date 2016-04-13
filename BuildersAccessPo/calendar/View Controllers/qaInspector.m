//
//  qaInspector.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "qaInspector.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "qaInspector2.h"

@interface qaInspector ()<UITableViewDataSource, UITableViewDelegate>{
    UIScrollView *uv;
    NSMutableArray *rtnlist;
    wcfArrayOfQAInspect * wi;
    wcfQAInspect *tbtable;
    UIButton *btnNext;
}


@end

@implementation qaInspector;
@synthesize xyear;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dorefresh{
[self getInspector];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    self.title=@"Inspector";
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack:)];
   
        [[ntabbar.items objectAtIndex:0]setTitle:@"Calendar" ];
  
    
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh)];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
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
    
	// Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated{
    [self getInspector];
    [self orientationChanged];
}
-(void)getInspector{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xGetInspectorByYear:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xyear:xyear EquipmentType:@"5"];
        // Do any additional setup after loading the view.
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
    
    wi=(wcfArrayOfQAInspect *)value;
    if (uv) {
        [uv removeFromSuperview];
    }
    
    int dwidth = self.uw.frame.size.width;
    int dheight =self.uw.frame.size.height;
    
  
      uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.uw addSubview:uv];
    
    UITableView *tbview;
    
    NSString *month=@"";
    
    
    UILabel *lbl;
    int x =5;
    int y =10;
   
    NSMutableArray * tt;
    int j =10;
    if ([wi count]>0) {
        NSMutableArray *_montharry= [[NSMutableArray alloc]init];
        [_montharry addObject:@"January"];
        [_montharry addObject:@"February"];
        [_montharry addObject:@"March"];
        [_montharry addObject:@"April"];
        [_montharry addObject:@"May"];
        [_montharry addObject:@"June"];
        [_montharry addObject:@"July"];
        [_montharry addObject:@"August"];
        [_montharry addObject:@"September"];
        [_montharry addObject:@"October"];
        [_montharry addObject:@"November"];
        [_montharry addObject:@"December"];
        
        rtnlist=[[NSMutableArray alloc]init];
        for (int i=0; i< [wi count]; i++) {
            wcfQAInspect *fp=[wi objectAtIndex:i];
            if (![fp.Month isEqualToString: month]) {
                month=fp.Month;
                
                
                if (tt!=nil) {
                    [rtnlist addObject:tt];
                    tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, [tt count]*44)];
                    tbview.layer.cornerRadius = 10;
                    tbview.delegate = self;
                    tbview.tag=j++;
                    tbview.dataSource = self;
                    tbview.layer.borderWidth = 1.2;
                      tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
                    [uv addSubview:tbview];
                    y= y+[tt count]*44+15;
                    
                }
                lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth-20, 21)];
                lbl.text=[NSString stringWithFormat:@"%@ %@", [_montharry objectAtIndex:[month intValue]-1], xyear];
                lbl.font=[UIFont boldSystemFontOfSize:17.0];
                lbl.backgroundColor=[UIColor clearColor];
                [uv addSubview:lbl];
                y=y+21+x;
                tt= [[NSMutableArray alloc]init];
                [tt addObject:fp];
            }else{
                [tt addObject:fp];
            }

                      
        }
        [rtnlist addObject:tt];
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth-20, [tt count]*44)];
        tbview.layer.cornerRadius = 10;
        tbview.delegate = self;
        tbview.tag=j++;
          tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        tbview.dataSource = self;
        tbview.layer.borderWidth = 1.2;
        tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:tbview];
        y= y+[tt count]*44+20;
        
    }
    
    if (y<uv.frame.size.height+1) {
        y=uv.frame.size.height+1;
    }
      uv.contentSize=CGSizeMake(dwidth, y);
    
    [ntabbar setSelectedItem:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
      return [[rtnlist objectAtIndex:tableView.tag-10] count];
    }
  
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfQAInspect *event =[[rtnlist objectAtIndex:tableView.tag-10] objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", event.Name, event.Cnt];
//    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
      [[cell textLabel]setBackgroundColor:[UIColor clearColor]];
    UIView *myView = [[UIView alloc] init];
    
    
    
        if ([event.Color isEqualToString:@"Yellow"]) {
            myView.backgroundColor = [UIColor colorWithRed:218.0/256 green:165.0/256 blue:32.0/256 alpha:1.0];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Orange"]){
            //            myView.backgroundColor = [UIColor colorWithRed:255.0/256 green:204.0/256 blue:0.0 alpha:1.0];
            myView.backgroundColor=[UIColor orangeColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
            //        }else if([event.Color isEqualToString:@"Red"]){
            //            myView.backgroundColor = [UIColor redColor];
            //            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Green"]){
            myView.backgroundColor = [UIColor colorWithRed:50.0/256 green:205.0/256 blue:50.0/256 alpha:1.0];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
            //        }else if([event.Color isEqualToString:@"Blue"]){
            //            myView.backgroundColor = [UIColor blueColor];
            //            [[cell textLabel]setTextColor:[UIColor blackColor]];
            //        }else if([event.Color isEqualToString:@"Purple"]){
            //            myView.backgroundColor = [UIColor purpleColor];
            //            [[cell textLabel]setTextColor:[UIColor blackColor]];
            //        }else if([event.Color isEqualToString:@"Pink"]){
            //            myView.backgroundColor = [UIColor colorWithRed:253.0/256 green:215.0/256 blue:228.0/256 alpha:1.0];
            //            [[cell textLabel]setTextColor:[UIColor blackColor]];
        }else if([event.Color isEqualToString:@"Brown"]){
            //255 192 203
            myView.backgroundColor = [UIColor brownColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else if([event.Color isEqualToString:@"Gray"]){
            //255 192 203
            myView.backgroundColor = [UIColor grayColor];
            [[cell textLabel]setTextColor:[UIColor whiteColor]];
        }else{
            myView.backgroundColor = [UIColor whiteColor];
            [[cell textLabel]setTextColor:[UIColor blackColor]];
        }
    
    cell.backgroundView = myView;
    
    [cell .imageView setImage:nil];
    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
         [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        tbtable=[[rtnlist objectAtIndex:tableView.tag-10]objectAtIndex:indexPath.row];
        [self autoUpd];
    
    }
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
         qaInspector2 *q2 =[qaInspector2 alloc];
        q2.xyear=self.xyear;
        q2.detailstrarr=self.detailstrarr;
        q2.menulist=self.menulist;
        q2.tbindex=self.tbindex;
        q2.xmonth=tbtable.Month;
        NSMutableArray *_montharry= [[NSMutableArray alloc]init];
        [_montharry addObject:@"January"];
        [_montharry addObject:@"February"];
        [_montharry addObject:@"March"];
        [_montharry addObject:@"April"];
        [_montharry addObject:@"May"];
        [_montharry addObject:@"June"];
        [_montharry addObject:@"July"];
        [_montharry addObject:@"August"];
        [_montharry addObject:@"September"];
        [_montharry addObject:@"October"];
        [_montharry addObject:@"November"];
        [_montharry addObject:@"December"];
        q2.atitle=[NSString stringWithFormat:@"%@ %@", [_montharry objectAtIndex:[tbtable.Month intValue]-1], xyear];
        q2.xqaemail=tbtable.Email;
        q2.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:q2 animated:NO];
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
