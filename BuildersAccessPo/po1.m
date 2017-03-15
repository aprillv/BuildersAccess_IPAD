//
//  po1.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "po1.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "poemail.h"
#import "emailVendor.h"
#import "assignVendor.h"
#import "forapprove.h"
#import "project.h"
#import "development.h"
#import "polbl.h"

@interface po1 ()

@end

int y;
@implementation po1

@synthesize idpo1, xcode, fromforapprove;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [self getPo];
   
}
-(void)getPo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetPODetail:self action:@selector(xGetPODetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xcode:xcode EquipmentType:@"5"];
    }
    
}
- (void) xGetPODetailHandler: (id) value {
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
    
    pd=(wcfPODetail *)value;
    [self drawPage];
}

-(void)drawPage{
    [self setTitle:[NSString stringWithFormat:@"%@-%@", pd.Doc, pd.IdDoc]];
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
    
    int dwidth;
    int dheight;
    CGSize cs = self.uw.frame.size;
    dwidth=cs.width;
    dheight=cs.height;
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dwidth, dheight)];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.uw addSubview:uv];
    uv.backgroundColor=[UIColor whiteColor];
    for (UIView *u in uv.subviews) {
        [u removeFromSuperview];
    }
    
    dwidth=dwidth-20;
    UILabel *lbl;
    y=10;
    float rowheight=40.0;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
    lbl.text=[NSString stringWithFormat:@"%@ # %@", pd.Doc, pd.IdDoc];
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    NSMutableArray *list1=[[NSMutableArray alloc]init];
    [list1 addObject:[@"Date: " stringByAppendingString:pd.Date]];
    [list1 addObject:[@"Project # " stringByAppendingString:pd.ProjectNumber]];
    [list1 addObject:pd.ProjectName];
    [list1 addObject:[NSString stringWithFormat:@"Vendor # %ld", pd.Idvendor]];
    [list1 addObject:pd.Nvendor];
    [list1 addObject:[NSString stringWithFormat:@"Status: %@", pd.Status]];
    if(pd.Cknumber!=nil){
        [list1 addObject:[NSString stringWithFormat:@"Check # %@ @ %@", pd.Cknumber, pd.Ckdate]];
    }
    
    
    UILabel *lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight*[list1 count])];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    for (NSString *s in list1) {
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-3)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=s;
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        y=y+rowheight;
    }
    y=y+10;
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
   
    if (pd.Shipto!=nil){
        if ([pd.Shipto rangeOfString:@";"].location != NSNotFound) {
            NSArray *na =[pd.Shipto componentsSeparatedByString:@";"];
           UILabel* lbl1=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, (([na count]+1)*22))];
            lbl1.layer.cornerRadius =10.0;
            lbl1.layer.borderWidth = 1.2;
            lbl1.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lbl1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
           
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+2, dwidth-16, [na count]*22)];
            lbl.numberOfLines=0;
            lbl.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
//            [lbl sizeToFit];
            lbl.font=[UIFont systemFontOfSize:14.0];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lbl.backgroundColor=[UIColor clearColor];
            CGRect f= lbl1.frame;
            f.size.height=lbl.frame.size.height+6;
            lbl1.frame=f;
             [uv addSubview:lbl1];
            [uv addSubview:lbl];
            y = y+ lbl.frame.size.height+16;
        }else{
            lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
            lbl.layer.cornerRadius =10.0;
            lbl.layer.borderWidth = 1.2;
            lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lbl];
            
            lbl=[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, 21)];
            lbl.layer.cornerRadius =10.0;
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:14.0];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lbl.text=pd.Shipto;
             [uv addSubview:lbl];
              y = y+ lbl.frame.size.height+16;
        }
    }else{
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
        lbl.layer.cornerRadius =10.0;
        lbl.text=@"";
        lbl.layer.borderWidth = 1.2;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
         [uv addSubview:lbl];
          y = y+ lbl.frame.size.height+10;
    }
   
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Reason";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    lbl.layer.cornerRadius =10.0;
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(18, y+3, dwidth-16, 24)];
    lbl.layer.cornerRadius =10.0;
     lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=pd.Reason;
    [uv addSubview:lbl];

    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Detail";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    int tablewidth=dwidth;
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight*5)];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
////    lblTitle.layer.cornerRadius =10.0;
//    lblTitle.layer.borderWidth = 1.2;
//    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    [uv addSubview:lblTitle];
    
    int lh=0;
    
    polbl *q=[[polbl alloc] init];
    //            q.dwidth=tablewidth;

    q.frame=CGRectMake(10, y, dwidth, rowheight);
    q.backgroundColor=[UIColor lightGrayColor];
    q.isfirst=YES;
        q.istwocolomum=NO;
        y=y+rowheight-1;
    lh=rowheight;
    q.desc=@"Description";
   
        q.qty=@"Quantity";
    q.price=@"Price";
    q.total=@"Amount";
    q.layer.borderColor=[UIColor lightGrayColor].CGColor;
    q.layer.borderWidth=1.0f;
    q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:q];
    
//    UILabel *tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y-1, dwidth, 1)];
//    tt.backgroundColor=[UIColor lightGrayColor];
//    tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:tt];
    
    
    for (int i=0; i<[pd.OrderDetailList count]; i++) {
        wcfOrderDetail *od =(wcfOrderDetail *)[pd.OrderDetailList objectAtIndex:i];
        
        
        polbl *q=[[polbl alloc] init];
        //            q.dwidth=tablewidth;
        lh=lh+rowheight;
        q.frame=CGRectMake(10, y, tablewidth, (rowheight));
        q.istwocolomum=NO;
        y=y+rowheight-1;
        
        q.layer.borderColor=[UIColor lightGrayColor].CGColor;
        q.layer.borderWidth=1.0f;
        q.desc=od.Description;
        if (od.Qty) {
            q.qty=od.Qty;
        }else{
        q.qty=@"";
        }
        q.isfirst=NO;
        q.price=od.Price;
        q.total=od.Amount;
        q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:q];
        
        
        if(od.Notes!=nil && ![od.Notes isEqualToString:@""]){
            UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, tablewidth, (rowheight)) ];
            lbl.text=[NSString stringWithFormat:@" %@", od.Notes];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
            lbl.layer.borderWidth=1.0f;
            [uv addSubview:lbl];
             y=y+rowheight-1;
       
        }
        
//        if (i<[pd.OrderDetailList count]-1) {
//        UILabel*    tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 1)];
//            tt.backgroundColor=[UIColor lightGrayColor];
//            tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:tt];
////        }
      
       
       
        
    }
    
//    NSLog(@"%d",lh);
//    lblTitle.frame=CGRectMake(10, lblTitle.frame.origin.y, dwidth, lh+2);
//     y=y+10;
    
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight*4)];
//    lblTitle.layer.cornerRadius =10.0;
//    lblTitle.layer.borderWidth = 1.2;
//    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:lblTitle];
//    
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-3)];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lblTitle.backgroundColor=[UIColor clearColor];
//    lblTitle.text=[NSString stringWithFormat:@"Non Taxable %@", pd.Nontaxable];
//    lblTitle.font=[UIFont systemFontOfSize:14.0];
//    [uv addSubview:lblTitle];
    
    q=[[polbl alloc] init];
    q.frame=CGRectMake(10, y, tablewidth, (rowheight));
    q.istwocolomum=YES;
    q.desc=@"Non Taxable";
    q.qty=@"";
    q.isfirst=NO;
    q.price=@"";
    q.total=pd.Nontaxable;
    q.layer.borderColor=[UIColor lightGrayColor].CGColor;
    q.layer.borderWidth=1.0f;
    q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:q];
     y=y+rowheight-1;
    //        if (i<[pd.OrderDetailList count]-1) {
//    UILabel *tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 1)];
//    tt.backgroundColor=[UIColor lightGrayColor];
//    tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:tt];

    
//    y=y+1;
    
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-3)];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lblTitle.backgroundColor=[UIColor clearColor];
//    lblTitle.text=[NSString stringWithFormat:@"Taxable %@", pd.Taxable];
//    lblTitle.font=[UIFont systemFontOfSize:14.0];
//    [uv addSubview:lblTitle];
    
    
    q=[[polbl alloc] init];
    q.frame=CGRectMake(10, y, tablewidth, (rowheight));
    q.istwocolomum=YES;
    q.desc=@"Taxable";
    q.qty=@"";
    q.price=@"";
    q.total=pd.Taxable;
    q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    q.layer.borderColor=[UIColor lightGrayColor].CGColor;
    q.layer.borderWidth=1.0f;
    [uv addSubview:q];
     y=y+rowheight-1;
    //        if (i<[pd.OrderDetailList count]-1) {
//    tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 1)];
//    tt.backgroundColor=[UIColor lightGrayColor];
//    tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:tt];
//    y=y+1;
    
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-3)];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lblTitle.backgroundColor=[UIColor clearColor];
//    lblTitle.text=[NSString stringWithFormat:@"Tax %@", [pd.Tax stringByReplacingOccurrencesOfString:@":" withString:@": "]];
//    lblTitle.font=[UIFont systemFontOfSize:14.0];
//    [uv addSubview:lblTitle];
//    y=y+rowheight;
    
    q=[[polbl alloc] init];
    q.frame=CGRectMake(10, y, tablewidth, (rowheight));
    q.istwocolomum=YES;
    q.desc=[NSString stringWithFormat:@"Tax %@", [[pd.Tax componentsSeparatedByString:@":"] objectAtIndex:0]];
    q.qty=@"";
    q.price=@"";
    q.total= [[pd.Tax componentsSeparatedByString:@":"] objectAtIndex:1];
    q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:q];
    q.layer.borderColor=[UIColor lightGrayColor].CGColor;
    q.layer.borderWidth=1.0f;
    y=y+rowheight-1;
    
    //        if (i<[pd.OrderDetailList count]-1) {
//    tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 1)];
//    tt.backgroundColor=[UIColor lightGrayColor];
//    tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:tt];
//    y=y+1;
    
//    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-3)];
//    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lblTitle.backgroundColor=[UIColor clearColor];
//    lblTitle.text=[NSString stringWithFormat:@"Total %@", pd.Total];
//    lblTitle.font=[UIFont systemFontOfSize:14.0];
//    [uv addSubview:lblTitle];
//    y=y+rowheight+10;

    q=[[polbl alloc] init];
    q.frame=CGRectMake(10, y, tablewidth, (rowheight));
    q.istwocolomum=YES;
    q.desc=@"Total";
    q.qty=@"";
    q.price=@"";
    q.total= pd.Total;
    q.layer.borderColor=[UIColor lightGrayColor].CGColor;
    q.layer.borderWidth=1.0f;
    q.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:q];
    
    //        if (i<[pd.OrderDetailList count]-1) {
//    tt =[[UILabel alloc]initWithFrame:CGRectMake(10, y-1, dwidth, 1)];
//    tt.backgroundColor=[UIColor lightGrayColor];
//    tt.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:tt];
    y=y+rowheight;
    
//    lblTitle.frame=CGRectMake(10, lblTitle.frame.origin.y, dwidth, lh+2+rowheight*4);
    y=y+20;
    if (fromforapprove==1) {
        if ([pd.Status isEqualToString:@"Turn In"]) {
//            UIButton *loginButton;
//            if (pd.Hold) {
//                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//                [loginButton setTitle:@"Hold" forState:UIControlStateNormal];
//                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//                [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//                [loginButton addTarget:self action:@selector(dohold:) forControlEvents:UIControlEventTouchUpInside];
//                [uv addSubview:loginButton];
//                y=y+54;
//                
////                [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"hold.png"] ];
////                [[ntabbar.items objectAtIndex:3]setTitle:@"Hold" ];
////                [[ntabbar.items objectAtIndex:3] setEnabled:YES];
////                [[ntabbar.items objectAtIndex:3]setAction:@selector(dohold:) ];
//            }
//            
//            if ([pd.ApprovePayment isEqualToString:@"1"]) {
//                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//                [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
//                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//                [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//                [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
//                [uv addSubview:loginButton];
//                y=y+54;
//                
////                [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
////                [[ntabbar.items objectAtIndex:0]setTitle:@"Approve" ];
////                [[ntabbar.items objectAtIndex:0] setEnabled:YES];
////                [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:) ];
//            }
//            
//            if ([pd.Disapprove isEqualToString:@"1"]) {
//                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//                [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
//                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//                [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//                [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
//                [uv addSubview:loginButton];
//                y=y+54;
//                
////                [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
////                [[ntabbar.items objectAtIndex:13]setTitle:@"Disapprove" ];
////                [[ntabbar.items objectAtIndex:13] setEnabled:YES];
////                [[ntabbar.items objectAtIndex:13]setAction:@selector(dodisapprove:) ];
//            }
//        }else if([pd.Status isEqualToString:@"For Approve"] || ([pd.Status isEqualToString:@"Hold"])){
//            if ([pd.ApprovePayment isEqualToString:@"1"]) {
//                UIButton *loginButton;
////                [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
////                [[ntabbar.items objectAtIndex:0]setTitle:@"Approve" ];
////                [[ntabbar.items objectAtIndex:0] setEnabled:YES];
////                [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:) ];
//                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//                [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
//                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//                [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//                [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
//                [uv addSubview:loginButton];
//                y=y+54;
//            }
//            if ([pd.Disapprove isEqualToString:@"1"]) {
//                 UIButton *loginButton;
////                [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
////                [[ntabbar.items objectAtIndex:13]setTitle:@"Disapprove" ];
////                [[ntabbar.items objectAtIndex:13] setEnabled:YES];
////                [[ntabbar.items objectAtIndex:13]setAction:@selector(dodisapprove:) ];
//                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//                [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
//                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//                [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//                [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
//                [uv addSubview:loginButton];
//                y=y+54;
//                
//            }           
//           
        }
        
        
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        
         [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1) ];
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshPrject) ];
        
    }else{
//        UIButton* loginButton;
//        if (pd.CanEmail && ![pd.Status isEqualToString:@"Paid"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Email Vendor" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if([pd.AssignVendor intValue]>0){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            if(pd.Idvendor>0){
//                [loginButton setTitle:@"Re-Assign Vendor" forState:UIControlStateNormal];
//            }else{
//                [loginButton setTitle:@"Assign Vendor" forState:UIControlStateNormal];
//            }
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if(pd.Release!=nil && [pd.Release isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Release" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//        }
//        if([pd.ForApprove isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Release" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if(pd.Hold){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Hold" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//        }
//        
//        if(pd.ApprovePayment !=nil && [pd.ApprovePayment isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Approve For Payment" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//        }
//        
//        if(pd.PartialPayment !=nil && [pd.PartialPayment isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Partial Payment" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if(pd.PrintCheck!=nil && [pd.PrintCheck isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Print Check" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if(pd.Disapprove !=nil && [pd.Disapprove isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//            
//        }
//        
//        if (pd.ReOpen!=nil && [pd.ReOpen isEqualToString:@"1"]) {
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Re-Open" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//        }
//        
//        if(pd.Void!=nil && [pd.Void isEqualToString:@"1"]){
//            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [loginButton setFrame:CGRectMake(10, y, dwidth, 44)];
//            [loginButton setTitle:@"Void" forState:UIControlStateNormal];
//            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
//            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//            [uv addSubview:loginButton];
//            y=y+54;
//        }
        
       
        if (fromforapprove==3) {
             [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
             [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
            [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1) ];
        }else if(fromforapprove==2){
             [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
         [[ntabbar.items objectAtIndex:0]setTitle:@"Development" ];
            [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1) ];
        }
        
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(refreshPrject) ];
    }
    
    if (y < dheight+1) {
         uv.contentSize=CGSizeMake(dwidth+20,dheight+1);
    }else{
    uv.contentSize=CGSizeMake(dwidth+20,y);
    }
   
    [ntabbar setSelectedItem:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1];
    }else if(item.tag == 2){
        [self refreshPrject];
    }
}

-(void)refreshPrject{
    [self getPo];
}
-(void)goback1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]] ||  [temp isKindOfClass:[project class]] || [temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }

}

-(void)orientationChanged{
    [super orientationChanged];
    int dheight =self.uw.frame.size.height;
    if (y < dheight+1) {
        y=dheight+1;
    }
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    int dheight =self.uw.frame.size.height;
    if (y < dheight+1) {
        y=dheight+1;
    }
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    int dheight =self.uw.frame.size.height;
    if (y < dheight+1) {
        y=dheight+1;
    }
    [uv setContentSize:CGSizeMake(self.uw.frame.size.width, y)];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(IBAction)doRefresh:(id)sender{
    [self getPo];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 11:
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                    [self gotoEmailScreen:7];
            }
            break;
            
        case 1:
            //Approve for Payment
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                
                    {
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.labelText=@"Updating...";
                        HUD.dimBackground = YES;
                        HUD.delegate = self;
                        [HUD show:YES];
                        [self updpostatus:@"1" andpartail:@""];
                    }
                    break;
                
            }
            break;
            
        case 3:
            //Print Check
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [self updpostatus:@"2" andpartail:@""];
                }
                    break;
                    
                                    
            }
            break;
            
        case 4:
            //Partial Payment
            
        {
            NSString  *spartial;
            
            switch (buttonIndex) {
                case 1:
                    spartial = @"25";
                    break;
                case 2:
                    spartial = @"50";
                    break;
                case 3:
                    spartial = @"75";
                    break;
                case 4:
                    spartial = @"90";
                    break;
                default:
                    spartial = @"";
                    break;
            }
            if (![spartial isEqualToString:@""]) {
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [self updpostatus:@"9" andpartail:spartial];
                }
                break;
            }
            
        }
            break;
        case 5:
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 6:
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                    [self todo2ndApproveForPayment];
            }
            break;
        default:
            break;
    }
}

-(void)todo2ndApproveForPayment{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide:YES];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Updating...";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        wcfService *service = [wcfService service];
        
        [service xUpdateUserPurchaseOrder:self action:@selector(doapprovea:) xemail:[userInfo getUserName]  xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xtype:@"1" update:@"" vendorid:@"" delivery:pd.Delivery xlgsel:@"" xcode:xcode EquipmentType:@"3" continueyn:@"1"];
    }
}

-(void)updpostatus: (NSString *)xtype2 andpartail:(NSString *)partail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide:YES];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service = [wcfService service];
        
        [service xUpdateUserPurchaseOrder:self action:@selector(doapprovea:) xemail:[userInfo getUserName]  xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xtype:xtype2 update:@"" vendorid:@"" delivery:pd.Delivery xlgsel:partail xcode:xcode EquipmentType:@"5" continueyn: @"0"];
    }

    
}
-(IBAction)doapprovea: (NSString *) value {
    NSString* rtn = value;
    [HUD hide:YES];
	if(!value){
        UIAlertView *alert =[self getErrorAlert:@"Update failed, please try it again later"];
        alert.tag=5;
        [alert show];
    }else{
        if ([rtn isEqualToString:@"4"]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Related task has not been finished.\nDo you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 6;
            [alert show];
            
            //
        }else if ([rtn isEqualToString:@"5"]) {
            [HUD hide:YES];
            UIAlertView *alert =[self getErrorAlert:@"Related task has not been finished."];
            alert.tag=5;
            [alert show];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
}

-(IBAction)dohold:(id)sender{
    [self gotoEmailScreen:10];

}
-(IBAction)doapprove:(id)sender{
     xtype=1;
    [self autoUpd];
    
}

-(IBAction)dodisapprove:(id)sender{
    xtype=2;
    [self autoUpd];
}

-(void)autoUpd{
    
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
        if (xtype==1) {
            
            
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure you want to approve?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
        }else{
            [self gotoEmailScreen:3];
        }
    }
    
    
}

//@"Email Vendor"

-(IBAction)doupdate1:(UIButton *)sender {
//    if ([sender.currentTitle isEqualToString:@"Approve For Payment"] && [pd.canApprovePayment isEqualToString:@"0"]) {
//        UIAlertView *alert=[self getErrorAlert:@"Related task has not been finished."];
//        [alert show];
//        return;
//    }
    kv= sender.titleLabel.text;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler5:) version:version];
    }
}
- (void) xisupdate_iphoneHandler5: (id) value {
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{

        if ([kv isEqualToString:@"Email Vendor"]) {
            emailVendor *LoginS=[emailVendor alloc];
            LoginS.fromforapprove=self.fromforapprove;
            LoginS.detailstrarr=self.detailstrarr;
            LoginS.menulist=self.menulist;
            LoginS.tbindex=self.tbindex;
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.pd=pd;
            LoginS.poid=self.idpo1;
            LoginS.title=kv;
            [self.navigationController pushViewController:LoginS animated:NO];
        }else if([kv isEqualToString:@"Print Check"]){
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure you want to Print Check?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 3;
            [alert show];
        }else if([kv isEqualToString:@"Release"]){
            [self gotoEmailScreen:4];
        }else if([kv isEqualToString:@"Void"]){
            if(pd.MTakeOff && [pd.Void isEqualToString:@"1"]){
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Takeoff purchase order. Are you sure you want to continue?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
                alert.tag = 11;
                [alert show];
                
            }else{
                [self gotoEmailScreen:7];
            }
            
        }else if([kv isEqualToString:@"Re-Open"]){
            [self gotoEmailScreen:6];
        
        }else if([kv isEqualToString:@"Approve For Payment"]){
            [self doapprove:nil];
        }else if([kv isEqualToString:@"Partial Payment"]){
            if ([pd.Total length]<3) {
                UIAlertView *alert=[self getErrorAlert:@"Total cannot be empty!"];
                [alert show];
                return;
            }
            float lblTotal;
            UIAlertView *alert;
            if ([pd.Total rangeOfString:@"("].location == NSNotFound) {
                lblTotal=[[pd.Total substringFromIndex:2] floatValue];
                NSString *tmp1 = [@"25%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.25] stringValue]];
                NSString *tmp2 = [@"50%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.5] stringValue]];
                NSString *tmp3 = [@"75%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.75] stringValue]];
                NSString *tmp4 = [@"90%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.90] stringValue]];
                NSString *tmp5 = [@"100%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal] stringValue]];
                alert = [[UIAlertView alloc] initWithTitle:@"Select" message:nil
                                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:tmp1,tmp2,tmp3,tmp4,tmp5, nil];
            }else{
                NSString *a = [pd.Total stringByReplacingOccurrencesOfString:@"(" withString:@""];
                a =[a stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                lblTotal=[[a substringFromIndex:2] floatValue];
                NSString *tmp1 = [[@"25%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.25] stringValue]]stringByAppendingString:@")"];
                NSString *tmp2 = [[@"50%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.50] stringValue]]stringByAppendingString:@")"];
                NSString *tmp3 = [[@"75%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.75] stringValue]]stringByAppendingString:@")"];
                NSString *tmp4 = [[@"90%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.90] stringValue]]stringByAppendingString:@")"];
                NSString *tmp5 = [[@"100%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal] stringValue]]stringByAppendingString:@")"];
                alert = [[UIAlertView alloc] initWithTitle:@"Select" message:nil
                                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:tmp1,tmp2,tmp3,tmp4,tmp5, nil];
            }
            alert.tag = 4;
            [alert show];
            return;

            //  [rtnlist addObject:@"Re-Assign Vendor"];
      
            //[rtnlist addObject:@"Assign Vendor"];
        }else if([kv isEqualToString:@"Re-Assign Vendor"] || [kv isEqualToString:@"Assign Vendor"]){
            assignVendor *next =[assignVendor alloc];
            next.detailstrarr=self.detailstrarr;
            next.menulist=self.menulist;
            next.tbindex=self.tbindex;
            next.managedObjectContext=self.managedObjectContext;
            next.xpocode=self.xcode;
            next.xpoid=self.idpo1;
            next.xidproject=pd.ProjectNumber;
            next.xidcostcode=pd.Idcostcode;
            next.xshipto=pd.Shipto;
            next.xdelivery=pd.Delivery;
            next.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:next animated:NO];
        }
    }
}

-(void) gotoEmailScreen:(int)xtype1{
    poemail *LoginS=[poemail alloc];
    LoginS.menulist=self.menulist;
    LoginS.detailstrarr=self.detailstrarr;
    LoginS.tbindex=self.tbindex;
    LoginS.managedObjectContext=self.managedObjectContext;
    LoginS.idpo1=self.idpo1;
    LoginS.xmcode=self.xcode;
    LoginS.idvendor=[NSString stringWithFormat:@"%ld", pd.Idvendor];
    LoginS.xtype=xtype1;
    [self.navigationController pushViewController:LoginS animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
