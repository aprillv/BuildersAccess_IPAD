//
//  kirbytitledetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-6-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "qaentry.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "codisapprove.h"
#import "Reachability.h"
#import "qainspection.h"
#import "qainspectionb.h"
#import "project.h"
@interface qaentry ()

@end

@implementation qaentry
@synthesize idnumber, fromtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)dorefresh:(id)sender{
    [self getInfo];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack: nil];
    }else if(item.tag == 2) {
        [self dorefresh:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Calendar Event"];
//    if ([[userInfo getUserName]isEqualToString:@"roberto@buildersaccess.com"]){
//       
//    }
    
//    [[ntabbar.items objectAtIndex:0] setAction:@selector(goBack:)];
    if (fromtype==1) {
        [[ntabbar.items objectAtIndex:0]setTitle:@"Calendar" ];
    }else{
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
    
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(dorefresh:)];
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
    //      [self.navigationController.navigationBar addSubview:btnNext];
    
    
    [self getInfo];
	// Do any additional setup after loading the view.
}

-(void)doInspection{
    
    
    if ([result.Status isEqualToString:@"Not Started"] || [result.Status isEqualToString:@"Not Ready"]) {
        qainspection *qt =[qainspection alloc];
        qt.menulist=self.menulist;
        qt.tbindex=self.tbindex;
        qt.detailstrarr=self.detailstrarr;
        qt.managedObjectContext=self.managedObjectContext;
        qt.idnumber=self.idnumber;
        qt.fromtype=fromtype;
        [self.navigationController pushViewController:qt animated:NO];
    }else{
        qainspectionb *qt =[qainspectionb alloc];
        qt.menulist=self.menulist;
        qt.tbindex=self.tbindex;
        qt.detailstrarr=self.detailstrarr;
        qt.managedObjectContext=self.managedObjectContext;
        qt.idnumber=self.idnumber;
        qt.fromtype=fromtype;
        [self.navigationController pushViewController:qt animated:NO];
        
    }
    
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
    [super viewWillAppear:animated];
    [self orientationChanged];
}
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
        [service xGetQACalendarEntry:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber EquipmentType:@"5"];
        
    }
    
}
-(void)drawScreen{
    
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
    }else{
        x=8;
    }
    
    int dwidth =self.uw.frame.size.width-20;
    if (uv) {
        [uv removeFromSuperview];
    }
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth+20, self.uw.frame.size.height)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    
    
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=@"Project";
    
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.Nproject;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Assign To";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.AssignTo;
    lbl.backgroundColor=[UIColor clearColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Date";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.DateT;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Start Time";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.StartTime;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"End Time";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.EndTime;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Email";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    if(result.Email){
        Email=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
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
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
         lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        
    }
    
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Contact Name";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.text=result.ContactNm;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Phone";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    //    txtPhone=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    //    [txtPhone setBorderStyle:UITextBorderStyleRoundedRect];
    //    txtPhone.delegate=self;
    //    txtPhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    [uv addSubview: txtPhone];
    //
    
    
    
    if (result.Phone) {
        phone=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        phone.layer.cornerRadius = 10;
        phone.tag=5;
        [phone setRowHeight:rowheight];
        phone.delegate = self;
        phone.dataSource = self;
        phone.layer.borderWidth = 1.2;
        phone.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
         phone.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:phone];
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        lbl.layer.cornerRadius=10.0;
         lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:lbl];
    }
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Mobile";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    if (result.Mobile) {
        Mobile=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        Mobile.layer.cornerRadius = 10;
        Mobile.tag=6;
        Mobile.layer.borderWidth = 1.2;
        Mobile.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [Mobile setRowHeight:rowheight];
         lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        Mobile.delegate = self;
        Mobile.dataSource = self;
        [uv addSubview:Mobile];
        
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
         lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        
    }
    
    y=y+rowheight+x;
    
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Notes";
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*3)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight*2+20)];
    lbl.text=result.Notes;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.numberOfLines=0;
    [lbl sizeToFit];
    [uv addSubview:lbl];
    y=y+rowheight*2+40;
    
    
//    if ([[userInfo getUserName]isEqualToString:@"roberto@buildersaccess.com"]){
    
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
        [loginButton setTitle:@"Open Inspection" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doInspection) forControlEvents:UIControlEventTouchUpInside];
        loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:loginButton];
        
        y=y+75;
//    }

    if (y<self.uw.frame.size.height+1) {
        uv.contentSize=CGSizeMake(dwidth+20,self.uw.frame.size.height+1);
    }else{
        uv.contentSize=CGSizeMake(dwidth+20,y);
    }
}

-(void)orientationChanged{
    [super orientationChanged];
    float y = uv.contentSize.height;
    if (y<self.uw.frame.size.height+1) {
        uv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
    }else{
        uv.contentSize=CGSizeMake(self.uw.frame.size.width,y);
    }
    
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
    
    result = (wcfCalendarQA*)value;
    [self drawScreen];
    [ntabbar setSelectedItem:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (tableView.tag==5) {
            [self calloffice];
        }else if(tableView.tag==6){
            [self calmobile];
        }else{
            [self sendEmail];
        }
    }
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
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return 1;
    }
}


@end
