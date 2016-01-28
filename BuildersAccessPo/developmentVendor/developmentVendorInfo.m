//
//  developmentVendorInfo.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/27/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "developmentVendorInfo.h"
#import "development.h"
#import "wcfService.h"
#import "Mysql.h"
#import "Reachability.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "project.h"
#import "vendorpocials.h"
#import "projectpo.h"

@interface developmentVendorInfo ()

@end

@implementation developmentVendorInfo{
//    UITabBar *ntabbar;
    UIScrollView *uv;
    wcfVendorInfo *result;
    UITableView *tbview;
    NSMutableArray *naContactList;
    UIButton *btnNext;
    BOOL aaa;
}

@synthesize idproject=_idproject, idvendor=_idvendor, atitle=_atitle, idmaster;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack1{
    for (UIViewController *uc in self.navigationController.viewControllers) {
        if ([uc isKindOfClass:[development class]] || [uc isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:uc animated:NO];
        }
    }
}
-(void) dorefresh{
 [self getVendorInfo];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title=@"Vendor Profile";
    
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
    
    if ([_idproject isEqualToString:@"-1"]) {
        
//        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
//        [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
//        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    }else{
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        aaa =NO;
        for (UIViewController *uc in self.navigationController.viewControllers) {
            if ([uc isKindOfClass:[development class]]) {
                aaa=YES;
                break;
            }
        }
        if (aaa) {
             [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
        }else{
             [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        }
       
        [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    }
    
    
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];

    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, self.uw.frame.size.height)];
    uv.contentSize=CGSizeMake(320, 455);
    [self.uw addSubview:uv];
    [self getVendorInfo];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2) {
        [self dorefresh];
    }
}


-(void)getVendorInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if ([_idproject isEqualToString:@"-1"]) {
            [service xGetVendorInfo2:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xciaid:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xvendorid:_idvendor EquipmentType:@"5"];
            
        }else{
            
            [service xGetVendorInfo:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xciaid:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xiddevelopment:_idproject xvendorid:_idvendor EquipmentType:@"5"];
        
        }
    }

}

- (void) xGetVendorsHandler: (id) value {
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
    result = (wcfVendorInfo*)value;
    
	for (UIView *uw in uv.subviews) {
        [uw removeFromSuperview];
    }
    
    [self drawPage];
    
}
-(void)drawPage{
    int y=10;
    int x=10;
    int lblwidth =self.uw.frame.size.width-20;
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
    lbl.text=result.Name;
    lbl.font=[UIFont boldSystemFontOfSize:17.0];
//    lbl.textColor= [Mysql getLabelTitleColor];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y = y+30;
    
    int x2=18;
    int lblwidth2=self.uw.frame.size.width-36;
    
    UILabel *lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(x2, y, lblwidth2, 30)];
    lbl2.layer.cornerRadius=8;
    lbl2.layer.borderWidth = 1.2;
    lbl2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl2.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    
    int tmph =10;
    int tmpy=y;
    [uv addSubview:lbl2];
    y = y+5;
    
    
    if (result.cname) {
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x2, y, lblwidth2, 21)];
        lbl.text=result.cname;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        y = y+30;
        tmph=tmph+30;
    }
    UITableView *tb;
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (result.phone) {
        tb=[[UITableView alloc]initWithFrame:CGRectMake(x+1, y, lblwidth-2, 35)];
        tb.delegate=self;
        tb.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        tb.dataSource=self;
        tb.separatorColor=[UIColor clearColor];
        tb.rowHeight=35;
        
        tb.tag=10;
        [uv addSubview:tb];
        y = y+35;
        tmph =tmph+35;
    }
   
    
    if (result.Fax) {
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x2, y, lblwidth2, 35)];
        lbl.text=[NSString stringWithFormat:@"Fax: %@", result.Fax];
        [uv addSubview:lbl];
        y = y+35;
         tmph =tmph+35;
    }
    
    if (result.Mobile) {
        tb =[[UITableView alloc]initWithFrame:CGRectMake(x+1, y, lblwidth-2, 35)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorColor=[UIColor clearColor];
        tb.tag=11;
         tb.autoresizingMask=UIViewAutoresizingFlexibleWidth;
         tb.rowHeight=35;
        [uv addSubview:tb];
        y = y+35;
         tmph =tmph+35;

    }
    
    tb =[[UITableView alloc]initWithFrame:CGRectMake(x+1, y, lblwidth-2, 35)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.separatorColor=[UIColor clearColor];
    tb.rowHeight=35;
    tb.tag=12;
    tb.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:tb];
    y = y+40;
     tmph =tmph+37;
    
    y= y+15;
    
    lbl2.frame=CGRectMake(x, tmpy, lblwidth, tmph);
//     lbl2.layer.cornerRadius = 10;
    
    
    if (result.ContractList &&[result.ContractList count]>0) {
        
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
        lbl.text=@"Contact List";
//        lbl.textColor= [Mysql getLabelTitleColor];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont boldSystemFontOfSize:17.0];
        [uv addSubview:lbl];
        y = y+31;
        
        
        //        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, lblwidth, 21*[result.AssemblyList count]+10)];
        //        lbl.layer.cornerRadius=10.0;
        //        [uv addSubview:lbl];
        naContactList=[[NSMutableArray alloc]init];
        NSMutableArray *ni;
        int i=14;
        tmph=0;
        tmpy=y;
        lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 30)];
        lbl2.layer.cornerRadius=8;
        lbl2.layer.borderWidth = 1.2;
        lbl2.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:lbl2];
        y=y+7;
        for (wcfVendorContactItem *wi in result.ContractList) {
           
            ni=[[NSMutableArray alloc]init];
            if (wi.Name) {
                [ni addObject:wi.Name];
            }else{
                [ni addObject:@""];
            }
            
            if (wi.phone) {
                [ni addObject:[NSString stringWithFormat:@"Phone: %@", wi.phone]];
            }
            if (wi.Fax) {
                [ni addObject:[NSString stringWithFormat:@"Fax: %@", wi.Fax]];
            }
            if (wi.Mobile) {
                [ni addObject:[NSString stringWithFormat:@"Mobile: %@", wi.Mobile]];
            }
            [ni addObject:wi.Email];
            [naContactList addObject:ni];
            tb =[[UITableView alloc]initWithFrame:CGRectMake(x+1, y, lblwidth-2, [ni count]*35)];
            tb.delegate=self;
            tb.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            tb.dataSource=self;
            tb.rowHeight=35;
            tb.separatorColor=[UIColor clearColor];
            tb.tag=i;
            i=i+1;
//            tb.layer.cornerRadius = 10;
            
            
            [uv addSubview:tb];
            
            tmph=tmph+[ni count]*35+1;
            y = y+[ni count]*35;
            if (i-14!=[result.ContractList count]) {
                lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 1)];
                
                lbl.backgroundColor=[UIColor colorWithWhite: 0.85 alpha: 1.0];
                lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                [uv addSubview:lbl];
                 y=y+1;
            }
           
           
            
        }
         lbl2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl2 .frame=CGRectMake(x, tmpy, lblwidth, tmph+14);
       
        y=y+20;
        if (result.AssemblyList &&[result.AssemblyList count]>0) {
            
            lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
            if ([self.idproject isEqualToString:@"-1"]) {
                lbl.text=@"Cost Code";
            }else{
                
//                lbl.text=@"Category List";
                lbl.text=@"Assemblies Linked";
            }
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont boldSystemFontOfSize:17.0];
            //        lbl.textColor= [Mysql getLabelTitleColor];
            [uv addSubview:lbl];
            y = y+31;
            
            
            //        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, lblwidth, 21*[result.AssemblyList count]+10)];
            //        lbl.layer.cornerRadius=10.0;
            //        [uv addSubview:lbl];
            
            tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, [result.AssemblyList count]*44)];
            tb.delegate=self;
            tb.dataSource=self;
            tb.layer.cornerRadius = 8;
            tb.layer.borderWidth = 1.2;
            tb.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            tb.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            tb.tag=13;
            tb.userInteractionEnabled=NO;
            [uv addSubview:tb];
            y = y+[result.AssemblyList count]*44+15;
            
        }
        
        
        
        
    }
    
    tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, 44)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.separatorColor=[UIColor clearColor];
    tb.rowHeight=44;
    tb.tag=9;
    tb.layer.cornerRadius = 8;
    tb.layer.borderWidth = 1.2;
      tb.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:tb];
    y = y+64;
    
    y=y+20;
    if (y > uv.frame.size.height+1) {
        uv.contentSize= CGSizeMake(lblwidth+20, y);
    }
    [ntabbar setSelectedItem:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self orientationChanged];
}
-(void)orientationChanged{
    [super orientationChanged];
    uv.contentSize= CGSizeMake( self.uw.frame.size.width, uv.contentSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    switch (tableView.tag) {
        case 10:
             case 9:
            case 11:
            case 12:
            return 1;
            break;
        case 13:
            return result.AssemblyList.count;
            break;
       
        default:
        {NSMutableArray *na =[naContactList objectAtIndex:tableView.tag-14];
            return [na count];}
            break;
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    switch (tableView.tag) {
        case 9:
            if ([_idproject isEqualToString:@"-1"]) {
                cell.textLabel.text=@"Open POs";
            }else{
                cell.textLabel.text=@"All POs";
            }
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 10:
            cell.textLabel.text=[NSString stringWithFormat:@"Phone: %@", result.phone];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 11:
            cell.textLabel.text=[NSString stringWithFormat:@"Mobile: %@", result.Mobile];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 12:
            if (result.Email) {
                 cell.textLabel.text=result.Email;
            }else{
             cell.textLabel.text=@"";
                  cell.accessoryType=UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellEditingStyleNone;
            }
           
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 13:{
            wcfVendorAssemblyItem *ai =[result.AssemblyList objectAtIndex:indexPath.row];
//            NSLog(@"%@", ai);
            cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@",ai.IdAssembly, ai.Name];
           cell.textLabel.font=[UIFont systemFontOfSize:17.0];
             cell.accessoryType=UITableViewCellAccessoryNone;
        }
           break;
//        case 14:{
//            wcfVendorContactItem *ai =[result.ContractList objectAtIndex:indexPath.row];
//            cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@",ai.Name, ai.Email];
//            
//        }
//            break;
        default:
        {
            NSMutableArray *na =[naContactList objectAtIndex:tableView.tag-14];
            if (indexPath.row==0) {
                
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellEditingStyleNone;
            }
            cell.textLabel.text=[na objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        }
         
            
            break;
    }
   
    //    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
    [cell .imageView setImage:nil];
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
    if (tableView.tag>13 && indexPath.row==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    tbview= tableView;
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
    
    NSString* result22 = (NSString*)value;
    if ([result22 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        switch (tbview.tag) {
            case 9:
            {
                if ([_idproject isEqualToString:@"-1"]) {
                    vendorpocials *cl =[[vendorpocials alloc]init];
                    cl.menulist=self.menulist;
                    cl.detailstrarr=self.detailstrarr;
                    cl.tbindex=self.tbindex;
                    cl.idvendor=self.idvendor;
                    cl.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cl animated:NO];
                }else{
                    
                    projectpo *cc =[[projectpo alloc]init];
                    
                    cc.menulist=self.menulist;
                    cc.detailstrarr=self.detailstrarr;
                    cc.tbindex=self.tbindex;
                    cc.idmaster=idmaster;
                    
                    //                    if ([result.Status isEqualToString:@"Closed"]) {
                    //                        cc.xtype=1;
                    //                    }else{
                    //                        cc.xtype=0;
                    //                    }
                    cc.idvendor=self.idvendor;
                    cc.idproject=self.idproject;
                    if (aaa) {
                        cc.isfromdevelopment=1;
                    }else{
                        cc.isfromdevelopment=0;
                    }
                    
                    cc.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cc animated:NO];
                }
                
            }
                break;
            case 10:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", result.phone]];
                [[UIApplication sharedApplication] openURL:url];
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];
            }
                break;
            case 11:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", result.Mobile]];
                [[UIApplication sharedApplication] openURL:url];
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];

            }
            case 12:
            {
                if (result.Email) {
                    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", result.Email ];
                    NSURL *url = [NSURL URLWithString:stringURL];
                    [[UIApplication sharedApplication] openURL:url];
                }
               
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];

            }

                break;
                
            default:
            {
               
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                if (indexPath.row==0) {
                    [tbview deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }else{
                     NSMutableArray *na =[naContactList objectAtIndex:tbview.tag-14];
                    NSString *t=[na objectAtIndex:indexPath.row];
                    if ([[na objectAtIndex:indexPath.row] hasPrefix:@"Fax:"]) {
                        [tbview deselectRowAtIndexPath:indexPath animated:YES];
                        return;
                    }else  if ([[na objectAtIndex:indexPath.row] hasPrefix:@"Phone:"]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [t substringFromIndex:7]]];
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }else if([[na objectAtIndex:indexPath.row] hasPrefix:@"Mobile:"]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [t substringFromIndex:8]]];
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }else{
                        NSString *stringURL = [NSString stringWithFormat:@"mailto:%@",t ];
                        
                        NSURL *url = [NSURL URLWithString:stringURL];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                   
                }
                [tbview deselectRowAtIndexPath:indexPath animated:YES];
                
               
                
                
            }
                
                break;
        }
//        NSIndexPath *indexPath = [uVendorTable indexPathForSelectedRow];
//        wcfVendor *vitem =[result objectAtIndex:indexPath.row];
//        developmentVendorInfo *pf =[developmentVendorInfo alloc];
//        pf.managedObjectContext=self.managedObjectContext;
//        pf.idproject=self.idproject;
//        pf.title=vitem.Name;
//        pf.idvendor=vitem.Idnumber;
//        
//        [self.navigationController pushViewController:pf animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
