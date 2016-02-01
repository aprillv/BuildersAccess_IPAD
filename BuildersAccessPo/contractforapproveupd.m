//
//  contractforapproveupd.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "contractforapproveupd.h"
#import "wcfService.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfContractDepositItem.h"
#import "contractforapproveupd1.h"
#import "ViewController.h"
#import "forapprove.h"
#import "project.h"

@interface contractforapproveupd (){
    int screenh;
}

@end

@implementation contractforapproveupd

@synthesize oidcia, ocontractid, atitle, xfromtype;

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
    
    [self setTitle:atitle];
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    [self.uw addSubview:uv];  
    uv.backgroundColor = [UIColor whiteColor];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
   
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
    
    [self getContractEntry];
    
}
-(void)getContractEntry{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service=[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetContractEntry:self action:@selector(xGetContractEntryHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd ] xidcia:oidcia contractid:ocontractid EquipmentType:@"5"];
    }

}

-(void)dorefresh{
    for (UIView *uw in uv.subviews) {
        [uw removeFromSuperview];
    }
    [self getContractEntry];
   
}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    //    sv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}

-(void)xGetContractEntryHandler: (id) value {
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
     result= (wcfContractEntryItem*)value;
    
    [self drawScreen];
}

-(void)drawScreen{

    int y=10;
    float rowheight=32.0;
    UILabel *lbl;
    UILabel * lblTitle ;
    [self setTitle:[NSString stringWithFormat:@"Contract - %@",result.IDDoc ]];
    uv.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    int dwidth=self.uw.frame.size.width-20;
    
    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
        lbl.text=[NSString stringWithFormat:@"Project # %@", result.IDProject];
        //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lbl];
        y=y+21+8;
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight*2)];
        lblTitle.layer.cornerRadius =10.0;
        lblTitle.layer.borderWidth = 1.2;
        lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lblTitle];
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-3)];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=result.NProject;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+rowheight, dwidth-20, rowheight-3)];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblTitle.backgroundColor=[UIColor clearColor];
        if (result.Stage==nil || [result.Stage isEqualToString:@""]) {
            lblTitle.text=@"Schedule Not Started";
            lblTitle.textColor=[UIColor redColor];
        }else{
            lblTitle.text=result.Stage;
        }
        
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        
        y=y+rowheight*2+8;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, dwidth, 21)];
        lbl.text=@"Floorplan";
        //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+30;
        int rtn =4;
        if (result.Reverseyn ) {
            rtn=rtn+1;
        }
        if (result.Repeated){
            rtn=rtn+1;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, rtn*rowheight)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.separatorColor=[UIColor clearColor];
        ciatbview.tag=6;
        ciatbview.layer.borderWidth = 1.2;
        ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [ciatbview setRowHeight:rowheight];
        [uv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+rtn*rowheight+10;
    }
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Contract Date";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(18, y+3, dwidth-16, rowheight-6)];
    lblTitle.text=result.ContractDate;lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Sub Division";
        //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
        lblTitle.layer.cornerRadius =10.0;
        lblTitle.layer.borderWidth = 1.2;
        lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview:lblTitle];
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
        lblTitle.text=result.SubDivision;
        lblTitle.layer.cornerRadius =10.0;
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];    
        y=y+40;
    }
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Consultant";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
    lblTitle.text=result.Consultant;
      lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Buyer Name";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
    lblTitle.text=result.Buyer;
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Broker Name";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
    lblTitle.text=result.Broker;
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
    lbl.text=@"Agent Name";
    //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.layer.borderWidth = 1.2;
    lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lblTitle];
    
    lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
    lblTitle.text=result.Agent;
    lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    if (xfromtype==1) {
        if (result.IsShow) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Base Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.BasePrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"List Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.ListPrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"A - Sales Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.SalesPrice;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
        }
    }
    
    
   
//    [uv addSubview:lblTitle];
    
    if ([result.SalesList count]>0) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
        lbl.text=@"Items Included In Sales Price";
        //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        wcfContractDepositItem *di;
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, [result.SalesList count]*rowheight)];
        lblTitle.layer.cornerRadius =10.0;
        lblTitle.layer.borderWidth = 1.2;
        lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        
        for (int i=0; i<[result.SalesList count]; i++) {
            int y1=y;
            di= (wcfContractDepositItem *)[result.SalesList objectAtIndex:i];
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, dwidth-20, 21)];
            lbl.text=di.Description;
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lbl.numberOfLines=0;
            lbl.font=[UIFont systemFontOfSize:14.0];
            [lbl sizeToFit];
            y1=y1+lbl.frame.size.height;
            
            UILabel *lbl2;
            UILabel *lbl3;
            BOOL isshow=YES;
            
            if ([di.Price isEqualToString:@"$ 0.00"]) {
                if ([di.BType isEqualToString:@"Notes"]) {
                    isshow=NO;
                    
                    y1=y1+5;
                }else{
                    lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, y1, dwidth-20, 21)];
                    lbl2.text=di.BType;
                    lbl2.numberOfLines=0;
                    lbl2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    lbl2.font=[UIFont systemFontOfSize:14.0];
                    [lbl2 sizeToFit];
                    y1=y1+lbl2.frame.size.height+5;
                }
            }else{
                lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, y1, dwidth-20, 21)];
                lbl2.text=[NSString stringWithFormat:@"%@ %@", di.BType, di.Price];
                lbl2.numberOfLines=0;
                lbl2.font=[UIFont systemFontOfSize:14.0];
                [lbl2 sizeToFit];
                lbl2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                y1=y1+lbl2.frame.size.height+5;
            }
            lbl3 =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, y1-y)];
            lbl3.backgroundColor=[UIColor whiteColor];
            lbl3.layer.cornerRadius =8.0;
            lbl3.layer.borderWidth = 1.2;
            lbl3.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lbl3.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
            [uv addSubview:lbl3];
            [uv addSubview:lbl];
            if (isshow) {
                [uv addSubview:lbl2];
            }
            
            
            y=y1+8;
        }
        
    }
    
    if (xfromtype==1) {
        if (result.IsShow) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"B - Total Items Included";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.BSalesPrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            NSArray *firstSplit = [result.C1SalesPrice componentsSeparatedByString:@";"];
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=[NSString stringWithFormat:@"C1 - Broker Percentage %@", [firstSplit objectAtIndex:0] ];
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=[firstSplit objectAtIndex:1];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"C2 - Btsa";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.C2SalesPrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"C3 - Special Financing";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.C3SalesPrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"D - Adjusted Sales Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.DSalesPrice;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            firstSplit = [result.ESalesPrice componentsSeparatedByString:@";"];
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=[NSString stringWithFormat:@"E - # Of Days Closing Date Delayed %@", [firstSplit objectAtIndex:0]];
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=[firstSplit objectAtIndex:1];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"F - Final Adjusted Sales Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.FSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"G - List Price %";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.GSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Non-Refundable";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.NonRefundable;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Collected";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.Collected;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Balance";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.Balance;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Additional Dep.";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.AdditionalDep;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Final Price";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.FinalPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Lot Cost";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.LotCost;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Administrative Cost";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.AdministrativeCost;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Construction Cost";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.ConstructionCost;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Open PO'S";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.OpenPO;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 21)];
            lbl.text=@"Gran Total";
            //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.GranTotal;
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, 21)];
            lbl.text=@"Estimated Gross Profit(Before closing costs/Internal commission)";
            //    lbl.numberOfLines=0;
            ////    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            //    [lbl sizeToFit];
            lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+26;
            
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.layer.borderWidth = 1.2;
            lblTitle.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            
            lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+3, dwidth-20, rowheight-6)];
            lblTitle.text=result.Estimated;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            lblTitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [uv addSubview:lblTitle];
            y=y+40;
            
        }
    }
    
    
    
    

    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 310, 21)];
        lbl.text=@"Sitemap";
        //    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        UIImage *img ;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemapthumb.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub,result.IDProject]];
        //    NSLog(@"%@", url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=nil) {
            img =[UIImage imageWithData:data];
            if (img!=nil) {
                float f = dwidth/img.size.width;
                if (f>1) {
                    f=1;
                }
                //            NSLog(@"%f %f", img.size.width, img.size.height);
                UIImageView *ui =[[UIImageView alloc]initWithFrame:CGRectMake(10, y, img.size.width*f, img.size.height*f)];
                ui.layer.borderWidth = 1.2;
                ui.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
                ui.image=img;
                ui.userInteractionEnabled = YES;
                ui.layer.cornerRadius=10;
                ui.layer.masksToBounds = YES;
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction)];
                tapped.numberOfTapsRequired = 1;
                [ui addGestureRecognizer:tapped];
                y=y+img.size.height*f+20;
                //            ui.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [uv addSubview:ui];
            }
        }    

    }else{
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 310, 21)];
    lbl.text=@"Sitemap";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, dwidth, 44)];
    ciatbview.layer.cornerRadius = 10;
    ciatbview.tag=7;
    ciatbview.layer.borderWidth = 1.2;
    ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    ciatbview.layer.cornerRadius = 10;
    ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    [uv addSubview:ciatbview];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
    y=y+44+10;
    }
  
   
  
    
     
   
    UIButton *loginButton;
    if (xfromtype==1) {
        if (result.Approve) {
//            [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
//            [[ntabbar.items objectAtIndex:0]setTitle:@"Approve Contract" ];
//            [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:) ];
            loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth-20, 36)];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [loginButton setTitle:@"Approve Contract" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        if (result.DisApprove) {
//            [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"disapprove.png"] ];
//            [[ntabbar.items objectAtIndex:13]setTitle:@"Disapprove" ];
//            [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//            [[ntabbar.items objectAtIndex:13]setAction:@selector(dodisapprove:) ];
            loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth-20, 36)];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
            [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        
        
        
        if (result.Acknowledge) {
            loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, dwidth-20, 36)];
            loginButton.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
            [loginButton setTitle:@"PM Acknowledge" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doacknowledge:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
//            [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"approve.png"] ];
//            [[ntabbar.items objectAtIndex:0]setTitle:@"PM Acknowledge" ];
//            [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(doacknowledge) ];
            
        }
        
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];
        
    }else{
        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
        [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        
        [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
        [[ntabbar.items objectAtIndex:13] setEnabled:YES];
//        [[ntabbar.items objectAtIndex:13]setAction:@selector(dorefresh) ];
    }
    
    
    
    screenh=y+1;
    if (y<self.uw.frame.size.height) {
        y=self.uw.frame.size.height+1;}
    uv.contentSize=CGSizeMake(dwidth+20,y);
    [ntabbar setSelectedItem:nil]; 
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}


-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]] ||  [temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else if(tableView.tag==7){
        [self myFunction];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)doacknowledge{
[self gotonextpage:3];
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self orientationChanged];
    [ntabbar setSelectedItem:nil];
}

-(void)orientationChanged{
    [super orientationChanged];
  int  y=screenh;
    if (y<self.uw.frame.size.height) {
        y=self.uw.frame.size.height+1;}
    
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, y);
}
-(void)myFunction{

    ViewController *si = [[ViewController alloc] init];
    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/contractsitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub, result.IDProject ];
    si.managedObjectContext=self.managedObjectContext;
    si.menulist=self.menulist;
    si.atitle=@"Site Map";
    si.detailstrarr=self.detailstrarr;
    si.tbindex=self.tbindex;
   [self.navigationController pushViewController:si animated:NO];
}

-(IBAction)doapprove:(id)sender{
    [self gotonextpage:1];
}

-(IBAction)dodisapprove:(id)sender{
    [self gotonextpage:2];
}

-(void)gotonextpage:(int)xtype3{
    xtype=xtype3;
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
        contractforapproveupd1 *cp =[[contractforapproveupd1 alloc]init];
        cp.managedObjectContext=self.managedObjectContext;
        cp.idcia=result.IDCia;
        cp.idcontract1=result.IDNumber;
        cp.idproject=result.IDProject;
        cp.projectname=result.NProject;
        cp.xtype=xtype;
        cp.atitle=self.atitle;
        cp.detailstrarr=self.detailstrarr;
        cp.menulist=self.menulist;
        cp.tbindex=self.tbindex;
        [self.navigationController pushViewController:cp animated:NO];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag!=1) {
        int rtn =4;
        if (result.Reverseyn ) {
            rtn=rtn+1;
        }
        if (result.Repeated){
            rtn=rtn+1;
        }
        
        return rtn;
    }else if (tableView.tag==1){
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (tableView.tag==6) {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 32)];
        CGRect rect = CGRectMake(10, 0, 295, 32);
        UILabel * label= [[UILabel alloc]initWithFrame:rect];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14.0];
        
        switch (indexPath.row){
            case 0:{
                if (result.IDFloorplan !=nil) {
                    label.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
                }else{
                    label.text=@"Plan No.";
                }
            }
                
                break;
            case 1:{
                
                if (result.PlanName==nil) {
                    label.text=@"n / a";
                    label.textColor=[UIColor redColor];
                }else{
                    label.text=result.PlanName;
                }
                
            }
                break;
            case 2:{
                if (result.Bedrooms ==nil || result.Baths == nil) {
                    label.text=@"Beds  / Baths ";
                }else if (result.Bedrooms ==nil ) {
                    label.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
                }else if(result.Baths==nil){
                    label.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
                }else{
                    label.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
                }                        }
                break;
            case 3:{
                if(result.Garage !=nil){
                    label.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
                }else{
                    label.text=@"Garage";
                }                        }
                
                break;
            case 4:
                if (result.Reverseyn ) {
                    
                    label.text=@"Builder Reverse";
                    
                }else if (result.Repeated){
                    label.text=@"Repeated Plan";
                    
                }
                break;
            default:
                label.text=@"Repeated Plan";
                break;
        }
        [cell.contentView addSubview:label];
        cell.userInteractionEnabled = NO;

        
    }

    
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell ==nil) {
            
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.text=@"View Sitemap";
                cell.textLabel.font=[UIFont systemFontOfSize:14.0];
                
                       
            
            
        }
        
        [cell .imageView setImage:nil];
        return cell;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
