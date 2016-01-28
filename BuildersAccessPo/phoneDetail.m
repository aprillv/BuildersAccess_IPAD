//
//  phoneDetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "phoneDetail.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import "cl_phone.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface phoneDetail ()

@end

NSEntityDescription *kv;

@implementation phoneDetail
@synthesize  email,  infoview, phone, fax, mobile,uemail, ename, idmaster;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 2){
        [self refreshPhone: nil];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Profile"];
    
//    [[ntabbar.items objectAtIndex:13] setAction:@selector(refreshPhone:)];
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
    [self getDetail];
}



-(IBAction)refreshPhone:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
            [alert show];
            [ntabbar setSelectedItem:nil];
        }else{
            
            
            wcfService *service=[wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            
            [service xGetPhoneListEntry:self action:@selector(xGetPhoneListEntryHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xemail1:email EquipmentType:@"5"];
        }

    }
    
    
}


- (void) xGetPhoneListEntryHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
    
    
	// Do something with the wcfPhoneListItem* result
    wcfPhoneListItem* result = (wcfPhoneListItem*)value;
    cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp updPhone:result];

    cl_phone *mf =[[cl_phone alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    NSMutableArray * rtnls = [mf getPhoneList:[NSString stringWithFormat:@"ciaid='%@' and email='%@'", idmaster, email]];
    if ([rtnls count]==1) {
        kv =[rtnls objectAtIndex:0];
        [infoview reloadData];
        [phone reloadData];
        [fax reloadData];
        [mobile reloadData];
    }
    [ntabbar setSelectedItem: nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
[ntabbar setSelectedItem:nil];
}
-(void)sendEmail{
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", email ];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)calloffice{
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://XXXXX"]];
    if (phone !=nil) {
        NSMutableString *phone1 = [[kv valueForKey:@"telhome"] mutableCopy];
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
        UIAlertView *a=[self getErrorAlert:@"There is no Office Phone Number to call"];
        [a show];
    }
}

-(void)calmobile{
    if (mobile !=nil) {
        NSMutableString *phone1 = [[kv valueForKey:@"mobile"] mutableCopy];
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
        UIAlertView *a=[self getErrorAlert:@"There is no Office Phone Number to call"];
        [a show];
    }

}


-(void )getDetail{
    cl_phone *mf =[[cl_phone alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    NSMutableArray * rtnls = [mf getPhoneList:[NSString stringWithFormat:@"ciaid='%@' and email='%@'", idmaster, email]];
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    [self.uw addSubview:sv];
    sv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+20;
        x=10;
    }else{
        x=5;
    }
    
    int dwidth =self.uw.frame.size.width-20;
    
    if ([rtnls count]==1) {
        kv =[rtnls objectAtIndex:0];
        
        infoview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 60.0)];
        infoview.layer.cornerRadius = 10;
        infoview.separatorColor=[UIColor clearColor];
        infoview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        infoview.tag=4;
        infoview.layer.borderWidth = 1.2;
        infoview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [infoview setRowHeight:60.0f];
        infoview.delegate = self;
        infoview.dataSource = self;
        [sv addSubview:infoview];
        y=y+70+x;
        
        UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Office";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+21+x;
        
        phone=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44.0)];
        phone.layer.cornerRadius = 10;
        phone.tag=5;
        phone.layer.borderWidth = 1.2;
        phone.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        phone.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [phone setRowHeight:44.0f];
         phone.delegate = self;
        phone.dataSource = self;
        [sv addSubview:phone];
        
        
        y=y+44+x+5;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Fax";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+21+x;
 
        fax=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44.0)];
        fax.layer.cornerRadius = 10;
        fax.tag=6;
        fax.layer.borderWidth = 1.2;
        fax.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        fax.separatorColor=[UIColor clearColor];
         fax.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [fax setRowHeight:44.0f];
        fax.delegate = self;
        fax.dataSource = self;
        [sv addSubview:fax];
        y=y+44+x+5;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Mobile";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+21+x;
        
       mobile= [[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44.0)];
        mobile.layer.cornerRadius = 10;
        mobile.tag=7;
        mobile.layer.borderWidth = 1.2;
        mobile.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        mobile.separatorColor=[UIColor clearColor];
         mobile.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [mobile setRowHeight:44.0f];
        mobile.delegate = self;
        mobile.dataSource = self;
        [sv addSubview:mobile];
        y=y+44+x+5;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Email";
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+21+x;
        
        uemail= [[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44.0)];
        uemail.layer.borderWidth = 1.2;
        uemail.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        uemail.layer.cornerRadius = 10;
        uemail.tag=8;
        uemail.separatorColor=[UIColor clearColor];
         uemail.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uemail setRowHeight:44.0f];
        uemail.delegate = self;
        uemail.dataSource = self;
        [sv addSubview:uemail];
        y=y+44+x+5;

        sv.contentSize=CGSizeMake(dwidth+20,self.uw.frame.size.height+1);
        
    }else{
         UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
        lbl.numberOfLines=2;
        lbl.text=[NSString stringWithFormat:@"In the company %@, %@ not found.", [userInfo getCiaName], ename];
//        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [lbl sizeToFit];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [sv addSubview:lbl];
    }
    
}

-(void)orientationChanged{
    [super orientationChanged];
    sv.contentSize=CGSizeMake(self.uw.frame.size.width,self.uw.frame.size.height+1);
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

- (UIImage *)scaleImage1:(UIImage *)image{
    float h = image.size.height;
    float w = image.size.width;
    float x, y;
    
    float scaleSize;
    scaleSize=60/h;
    h=60;
    y=0;
    w=w*scaleSize;
    x=(80-w)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;    }
    
    if (tableView.tag==4) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/userphoto.aspx?email1=%@&email2=%@&password=%@", [userInfo getUserName], email, [userInfo getUserPwd]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *img=[UIImage imageWithData:data];
        if (img==nil) {
            img=[UIImage imageNamed:@"nophoto.png"];
        }
        
        
        [cell.imageView setImage:[self scaleImage1:img]];
        cell.textLabel.text =[kv valueForKey:@"name"];
        
        cell.detailTextLabel.text=[kv valueForKey:@"title"];
        cell.userInteractionEnabled=NO;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setAlpha:0.0];
        [cell setAccessoryView:spinner];
    }else if(tableView.tag==5){
        if ([kv valueForKey:@"telhome"]!=nil) {
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text =[kv valueForKey:@"telhome"];
            [cell .imageView setImage:nil];
        }else{
            cell.textLabel.text =@"";
            [cell .imageView setImage:nil];
            cell.userInteractionEnabled=NO;
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner setAlpha:0.0];
            [cell setAccessoryView:spinner];
        }
        
        
    }else if(tableView.tag==6){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =[kv valueForKey:@"tel"];
        [cell .imageView setImage:nil];
        cell.userInteractionEnabled=NO;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setAlpha:0.0];
        [cell setAccessoryView:spinner];
    }else if(tableView.tag==7){
        if ([kv valueForKey:@"mobile"]) {
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text =[kv valueForKey:@"mobile"];
            [cell .imageView setImage:nil];
        }else{
            cell.textLabel.text =@"";
            [cell .imageView setImage:nil];
            cell.userInteractionEnabled=NO;
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner setAlpha:0.0];
            [cell setAccessoryView:spinner];
        }
        
        
    }else if(tableView.tag==8){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =email;
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
        }else if(tableView.tag==7){
            [self calmobile];
        }else{
            [self sendEmail];
        }
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return 1;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
