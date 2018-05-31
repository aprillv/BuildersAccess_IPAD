//
//  kirbytitledetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-6-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#define NAVBAR_HEIGHT 44

#import "kirbytitledetail.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "codisapprove.h"
#import "Reachability.h"
#import "MTPopupWindowCloseButton.h"
#import "BANavigationBar.h"

@interface kirbytitledetail ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation kirbytitledetail
@synthesize idnumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


-(IBAction)dorefresh:(id)sender{
    [self getInfo];
    
}

-(void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    CGFloat y = (view.frame.size.height - 450 - NAVBAR_HEIGHT)/2 ;
    
    UINavigationBar *navigationBar = [[BANavigationBar alloc] initWithFrame:CGRectMake(view.bounds.size.width*.125, y, view.bounds.size.width*.75, NAVBAR_HEIGHT)];
    navigationBar.translucent = NO;
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.items = @[self.navigationItem];
    [[navigationBar.items objectAtIndex:0] setTitle:@"Calendar Event"];
    [view addSubview:navigationBar];
    //    view.backgroundColor = [UIColor clearColor];
    
    MTPopupWindowCloseButton *btn = [[MTPopupWindowCloseButton alloc]initWithFrame:CGRectMake(view.bounds.size.width*.825 , 4+y, 36, 36)];
    
    [btn addTarget:self action:@selector(doclose:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    uv = [[UIView alloc] initWithFrame:CGRectMake(view.bounds.size.width*.125, NAVBAR_HEIGHT + y, view.bounds.size.width*.75, 450)];
    uv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    uv.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [view addSubview:uv];
    
    
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Calendar Event"];
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh:)];
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
    //      [self.navigationController.navigationBar addSubview:btnNext];
 
    
    [self getInfo];
	// Do any additional setup after loading the view.
}


//-(IBAction)gosmall:(id)sender{
//    [super gosmall:sender];
//   btnNext.frame = CGRectMake(10, 26, 40, 32);
//}
//-(IBAction)gobig:(id)sender{
//    [super gobig:sender];
//    btnNext.frame = CGRectMake(60, 26, 40, 32);
//}

-(void)getInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetCalendarEntry:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber: idnumber EquipmentType: @"3"];
        
    }

}
-(void)drawScreen{
    
    int x=5;
   
    
    int y = 5;
    int dwidth =uv.frame.size.width-20;
//    if (uv) {
//        [uv removeFromSuperview];
//    }
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth+20, self.uw.frame.size.height)];
//    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.uw addSubview:uv];
    
    
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Subject";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-20, rowheight)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(28, y+4, dwidth-36, rowheight-6)];
    lbl.text=result.Subject;
    lbl.backgroundColor=[UIColor clearColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
        
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Location";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(500, y, 210, 21)];
    lbl.text=@"Date";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth*.7, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(28, y+4, dwidth*.7-10, rowheight-6)];
    lbl.text=result.Location;
    lbl.backgroundColor=[UIColor clearColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +40,  y, dwidth*.3 -40, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +45,  y, dwidth*.3 -45, rowheight)];
    lbl.text=result.TDate;
    lbl.backgroundColor=[UIColor clearColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
        
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Contact Name";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +40, y, 210, 21)];
    lbl.text=@"Start Time";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth*.7, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(28, y+4, dwidth*.7-16, rowheight-6)];
    lbl.text=result.ContactName;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
   

    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +40,  y, dwidth*.3 -40, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +45, y+4, 118, rowheight-6)];
    lbl.text=result.StartTime;
    lbl.backgroundColor=[UIColor clearColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 200, 21)];
    lbl.text=@"Phone";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake((dwidth*.7-20)/2+40, y, 200, 21)];
    lbl.text=@"Mobile";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +40, y, 210, 21)];
    lbl.text=@"End Time";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    if (result.Phone) {
        phone=[[UITableView alloc] initWithFrame:CGRectMake(20, y, (dwidth*.7-20)/2, rowheight)];
        phone.layer.cornerRadius = 10;
        phone.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        phone.tag=5;
        phone.layer.borderWidth = 1.2;
        phone.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [phone setRowHeight:rowheight];
        phone.delegate = self;
        phone.dataSource = self;
        [uv addSubview:phone];
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, (dwidth*.7-20)/2, rowheight)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
    }

    
    if (result.Mobile) {
        Mobile=[[UITableView alloc] initWithFrame:CGRectMake(40+(dwidth*.7-20)/2, y, (dwidth*.7-20)/2, rowheight)];
        Mobile.layer.cornerRadius = 10;
        Mobile.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        Mobile.tag=6;
        Mobile.layer.borderWidth = 1.2;
        Mobile.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        
        
        [Mobile setRowHeight:rowheight];
        Mobile.delegate = self;
        Mobile.dataSource = self;
        [uv addSubview:Mobile];
        
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(40+(dwidth*.7-20)/2, y, (dwidth*.7-20)/2, rowheight)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        
    }
    
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +40,  y, dwidth*.3 -40, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(dwidth*.7 +45,  y, dwidth*.3 -45, rowheight-6)];
    lbl.text=result.EndTime;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
   
    
        
    
      
           
   
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Email";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
   
    if(result.Email){
        Email=[[UITableView alloc] initWithFrame:CGRectMake(20, y, dwidth-20, rowheight)];
        Email.layer.cornerRadius = 10;
        Email.tag=7;
        Email.layer.borderWidth = 1.2;
        Email.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [Email setRowHeight:rowheight];
         Email.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        Email.delegate = self;
        Email.dataSource = self;
        [uv addSubview:Email];
        
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-20, rowheight)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
         lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        
    }
    
    y=y+rowheight+x;
       
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-20, 21)];
    lbl.text=@"Notes";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, dwidth-20, rowheight*3)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];

    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(28, y+4, dwidth-36, rowheight*2+20)];
    lbl.text=result.Notes;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.numberOfLines=0;
    [lbl sizeToFit];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    y=y+70;
    

//    if (y<self.uw.frame.size.height+1) {
//    uv.contentSize=CGSizeMake(dwidth+20,self.uw.frame.size.height+1);
//    }else{
//    uv.contentSize=CGSizeMake(dwidth+20,y);
//    }
    
    
        
}

//-(void)orientationChanged{
//    [super orientationChanged];
//    float y = uv.contentSize.height;
//    if (y<self.uw.frame.size.height+1) {
//        uv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
//    }else{
//        uv.contentSize=CGSizeMake(self.uw.frame.size.width,y);
//    }
//
//}

-(IBAction)doclose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) xGetCalendarEntryHandler: (id) value {
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
    
    result = (wcfCalendarEntryItem*)value;
    [self drawScreen];
//    [ntabbar setSelectedItem:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag==1) {
//        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    }else{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if(tableView.tag==5){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Phone;
        [cell .imageView setImage:nil];
        
    }else if(tableView.tag==6){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Mobile;
        [cell .imageView setImage:nil];
    }else if(tableView.tag==7){

        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Email;
        [cell .imageView setImage:nil];
        
    }
    
    
    
    return cell;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.tag==1) {
//        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    }else{
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (tableView.tag==5) {
            [self calloffice];
        }else if(tableView.tag==6){
            [self calmobile];
        }else{
            [self sendEmail];
        }
//    }
}

-(void)calloffice{
    if (phone !=nil) {
        NSMutableString *phone1 = [result.Phone mutableCopy];
        [phone1 replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@"("
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@")"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *a=[self getErrorAlert:@"There is no Phone Number to call"];
        [a show];
    }

}

-(void)calmobile{
    if (Mobile !=nil) {
        NSMutableString *phone1 = [result.Mobile mutableCopy];
        [phone1 replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@"("
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@")"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
//        UIAlertView *a=[self getErrorAlert:@"There is no Office Phone Number to call"];
        UIAlertView *a=[self getErrorAlert:@"There is no Mobile Number to call"];

        [a show];
    }

}

-(void)sendEmail{
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", result.Email ];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (tableView.tag==1) {
//        return [super tableView:tableView numberOfRowsInSection:section];
//    }else{
        return 1;
//    }
}


@end
