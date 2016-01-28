//
//  requestvpo.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import "requestvpo.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "forapprove.h"
#import "CustomKeyboard.h"
#import "wcfReasonListItem.h"
#import "viewImage.h"
#import "ViewController.h"
#import "wcfArrayOfRequestedPO2Item.h"
#import "wcfRequestedPO2Item.h"
#import "requestpoemail.h"
#import "development.h"
#import "project.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI

@interface requestvpo ()< CustomKeyboardDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, MBProgressHUDDelegate, UITextViewDelegate>{
    UITextView *txtNote;
    CustomKeyboard* keyboard;
    UIButton *txtDate;
    UIDatePicker *pdate;
    UITextField *txtTotal;
    UIButton *txtReason;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    NSString *donext;
    NSMutableData *_data;
    UIImageView *uview;
    UISearchBar *searchtxt;
    UIButton *btnNext;
    UIScrollView *uv;
    UITableView *ciatbview;
    wcfRequestedPODetail *pd;
    bool dfdfdf;
    NSMutableArray *a;
    MBProgressHUD* HUD;
    NSString *extension;
    UILabel *lbl10;
    NSURL *turl;
    NSString *requestby;
    NSDateFormatter *formatter;
}

@end

@implementation requestvpo

@synthesize  idnum, xcode, fromforapprove, docController;

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
    [self setTitle:[NSString stringWithFormat:@"Request # %@", idnum]];
   
    
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
    
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.uw.frame.size.width, self.uw.frame.size.height)];
    [self.uw addSubview:uv];
    uv.contentSize=CGSizeMake(self.uw.frame.size.width, self.uw.frame.size.height+1);
    uv.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    if (fromforapprove==1) {
        [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    }else{
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }
    
    [[ntabbar.items objectAtIndex:0] setEnabled:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
//    
//    [[ntabbar.items objectAtIndex:13]setAction:@selector(doRefresh:)];
    [[ntabbar.items objectAtIndex:13]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:13]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:13] setEnabled:YES];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:nil];
    }else if(item.tag == 2){
        [self doRefresh: nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getPo];
    [ntabbar setSelectedItem:nil];
}
-(void)getPo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetRequestedPOForApproveDetail:self action:@selector(xGetPODetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum EquipmentType:@"5"];
    }
    
}
- (void) xGetPODetailHandler: (id) value {
    
	
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
    pd =[[wcfRequestedPODetail alloc]init];
    pd=(wcfRequestedPODetail *)value;
    [self drawPage];
}

-(void)drawPage{
    for (UIView *u in uv.subviews) {
        [u removeFromSuperview];
    }
    
    UILabel *lbl;
    int y=10;
    int x=5;
    float rowheight=32.0;
    int dwidth = self.uw.frame.size.width-20;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Status";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.text=pd.Status;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Vendor";
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.text=pd.Vendor;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
//    lbl.text=@"Requested By";
//    lbl.font=[UIFont systemFontOfSize:17.0];
//    lbl.backgroundColor=[UIColor clearColor];
//    [uv addSubview:lbl];
//    y=y+30;
//    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
//    lbl.layer.borderWidth = 1.2;
//    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    lbl.layer.cornerRadius=10.0;
//    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [uv addSubview:lbl];
//    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth, rowheight-6)];
//    lbl.text=pd.RequestedBy;
//    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    lbl.backgroundColor=[UIColor clearColor];
//    lbl.font=[UIFont systemFontOfSize:14.0];
//    [uv addSubview:lbl];
//    y=y+rowheight+x;
    
       
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Project";
    
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, dwidth-16, rowheight-6)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.text=pd.Proejct;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Date";
    
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(18, y+4, dwidth-16, 21)];
    txtDate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    if ([pd.DeliveryDate isEqualToString:@"01/01/1980"]) {
        [txtDate setTitle:@"" forState:UIControlStateNormal];
    }else{
        [txtDate setTitle:pd.DeliveryDate forState:UIControlStateNormal];
    }
    
    [uv addSubview: txtDate];
    y=y+30+10;

    
   
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Category";
    
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.borderWidth = 1.2;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    lbl.layer.cornerRadius=10.0;
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:lbl];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.text=pd.CostCode;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
//    lbl.text=@"Total";
//    
//    lbl.font=[UIFont systemFontOfSize:17.0];
//    lbl.backgroundColor=[UIColor clearColor];
//    [uv addSubview:lbl];
//    y=y+30;
//    
//    txtTotal= [[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
//    txtTotal.font=[UIFont systemFontOfSize:14.0];
//    txtTotal.text=pd.Total;
//    txtTotal.delegate=self;
//    [txtTotal setBorderStyle:UITextBorderStyleRoundedRect];
//    [uv addSubview:txtTotal];
//    y=y+rowheight+x;
    
       
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes";
    
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    txtProject.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, dwidth-4, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.delegate=self;
    txtNote.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    txtNote.tag=19;
//    [txtTotal setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO : YES]];
    if (pd.Notes ==nil) {
        txtNote.text=@"";
    }else{
        txtNote.text=pd.Notes;
    
    }
    [uv addSubview:txtNote];
    
    y=y+120;
    
    if ([pd.Fs isEqualToString:@"1"]) {
        
        extension=[pd.extension copy];
//        NSLog(@"%@", extension);
        if ([extension isEqualToString:@"jpg"]||[extension isEqualToString:@"jpeg"]||[extension isEqualToString:@"png"]||[extension isEqualToString:@"bmp"]||[extension isEqualToString:@"gif"]) {
           
            
            uview=[[UIImageView alloc]init];
            uview.frame = CGRectMake(10, y, 300, 225);
            y=y+245;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadvpo.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], idnum,[NSString stringWithFormat:@"tmp.%@", extension]]];
            
            _data =[[NSMutableData alloc]init];
            NSURLRequest* updateRequest = [NSURLRequest requestWithURL:url];
            
            NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
            self.view.userInteractionEnabled=NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            //        [_spinner startAnimating];
            [connection start];
            [uv addSubview:uview];
            
        }else{
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn1 setFrame:CGRectMake(10, y, dwidth, 36)];
            btn1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn1 setTitle:[NSString stringWithFormat:@"View Attached file.%@", extension] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(openFile:) forControlEvents:UIControlEventTouchDown];
            [uv addSubview:btn1];
            y=y+50;
            
        }
        
    }

    
    
//    a= [[NSMutableArray alloc]initWithArray:pd.PO2Ls];
//      
//    [a addObject:[NSString stringWithFormat:@"Total: %@", pd.Total]];
//        if (ciatbview ==nil) {
//            
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.uw.frame.size.width-20, 70*[a count])];
//            ciatbview.layer.cornerRadius = 10;
//            ciatbview.tag=2;
//            ciatbview.rowHeight=70;
//            ciatbview.layer.borderWidth = 1.2;
//            ciatbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//            [uv addSubview:ciatbview];
//            ciatbview.delegate = self;
//            ciatbview.dataSource = self;
//            ciatbview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//            
//        }else{
//            
//            [ciatbview reloadData];
//            [uv addSubview:ciatbview];
//        }
//        y=y+70*[a count]+10;
    
    UITextField *textField;
    int i =0;
    int xtag=20;
    for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight*3)];
        lbl.layer.cornerRadius=10.0;
        lbl.layer.borderWidth = 1.2;
        lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
        [uv addSubview:lbl];
        
        y = y+3;
        lbl= [[UILabel alloc] initWithFrame: CGRectMake( 15, y, dwidth-50, 21)];
        lbl.text= [NSString stringWithFormat:@"%@ ~ %@", pi.Part, pi.Des];;
          lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [uv addSubview: lbl];
        
        y=y+30;
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 45, 21)];
        lbl.text=@"Unit: ";
        [uv addSubview: lbl];
        
        lbl= [[UILabel alloc] initWithFrame: CGRectMake( 50, y, 250, 21)];
        lbl.text=pi.Unit;
        [uv addSubview: lbl];
        
        //        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 125, 30, 75, 21)];
        //        lbl.text=@"Amount: ";
        //        [self.contentView addSubview: lbl];
        
        //        lblamount= [[UILabel alloc] initWithFrame: CGRectMake( 200, 30, 95, 21)];
        //        [self.contentView addSubview: lblamount];
        
        y=y+30;
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 45, 21)];
        lbl.text=@"Qty: ";
        [uv addSubview: lbl];
        
        textField=[[UITextField alloc]initWithFrame:CGRectMake(50, y-4, 160, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        //        [textField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.tag=xtag+i*2;
        textField.text=pi.Quantity;
        textField.delegate=self;
        textField.keyboardType =UIKeyboardTypeNumberPad;
        pi.FixPrice=YES;
        //        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [uv addSubview: textField];
                
        if ([pd.PO2Ls count]==1) {
            if (!pi.FixPrice) {
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
            }else{
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
            }
        }else{
            if (i==0) {
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
            }else if(i == [pd.PO2Ls  count]-1){
                if (!pi.FixPrice) {
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                }else{
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                }
                
               
            }else{
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                
            }
        }

        
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 215, y, 55, 21)];
        lbl.text=@"Price: ";
        [uv addSubview: lbl];
        
        textField=[[UITextField alloc]initWithFrame:CGRectMake(270, y-4, 160, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.text=pi.Price;
        
        textField.tag=xtag+i*2+1;
        if (!pi.FixPrice) {
            [textField setEnabled:NO];
        }else{
            textField.delegate=self;
            textField.keyboardType =UIKeyboardTypeNumberPad;
            if ([pd.PO2Ls count]==1) {
                
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                
            }else{
                if (i==0) {
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                }else if(i == [pd.PO2Ls  count]-1){
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                }else{
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                    
                }
            }
            
            
        }
        //        [textField2 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [uv addSubview: textField];
        
        y= y+40;
        i=i+1;
        
    }
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, dwidth, rowheight)];
    lbl.layer.cornerRadius=10.0;
    lbl.layer.borderWidth = 1.2;
 lbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    lbl.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
    [uv addSubview:lbl];
    
    y = y+3;
    lbl10= [[UILabel alloc] initWithFrame: CGRectMake( 15, y, dwidth-50, 21)];
    lbl10.text= [NSString stringWithFormat:@"Total: %@", pd.Total];
    [uv addSubview: lbl10];
    
    y=y+30;
    
   
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Reason";
    
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, dwidth, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtReason=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtReason setFrame:CGRectMake(18, y+4, dwidth-16, 21)];
    [txtReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtReason addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [txtReason setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtReason setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtReason.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    txtReason.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [uv addSubview: txtReason];
    y=y+30+20;
    
    [self getReason];

    
    txtTotal.enabled=NO;
    if ([pd.BtnApprove isEqualToString:@"1"]) {
        UIButton * btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate setFrame:CGRectMake(10, y, dwidth, 44)];
        btnUpdate.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [btnUpdate setTitle:@"Acknowledge" forState:UIControlStateNormal];
        [btnUpdate.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnUpdate setBackgroundImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
        [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate addTarget:self action:@selector(doUpdate1) forControlEvents:UIControlEventTouchUpInside];
//        btnUpdate.enabled=NO;
        [uv addSubview:btnUpdate];
        y= y+50;

    }
    if ([pd.BtnDisapprove isEqualToString:@"1"]) {
             UIButton * btnUpdate1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate1 setFrame:CGRectMake(10, y, dwidth, 44)];
        btnUpdate1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
             [btnUpdate1 setTitle:@"Disapprove" forState:UIControlStateNormal];
        [btnUpdate1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
       [btnUpdate1 setBackgroundImage:[UIImage imageNamed:@"yButton.png"] forState:UIControlStateNormal];
              [btnUpdate1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              [btnUpdate1 addTarget:self action:@selector(doUpdate2) forControlEvents:UIControlEventTouchUpInside];
//        btnUpdate1.enabled=NO;
              [uv addSubview:btnUpdate1];
              y= y+50;
              
        }
    
    if ([pd.BtnHold isEqualToString:@"1"]) {
        UIButton * btnUpdate1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate1 setFrame:CGRectMake(10, y, dwidth, 44)];
        btnUpdate1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [btnUpdate1 setTitle:@"Hold" forState:UIControlStateNormal];
        [btnUpdate1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnUpdate1 setBackgroundImage:[UIImage imageNamed:@"grayButton.png"] forState:UIControlStateNormal];
        [btnUpdate1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate1 addTarget:self action:@selector(doUpdate4) forControlEvents:UIControlEventTouchUpInside];
        //        btnUpdate1.enabled=NO;
        [uv addSubview:btnUpdate1];
        y= y+50;
        
    }

    

              if ([pd.BtnVoid isEqualToString:@"1"]) {
                  UIButton * btnUpdate2 = [UIButton buttonWithType:UIButtonTypeCustom];
                  [btnUpdate2 setFrame:CGRectMake(10, y, dwidth, 44)];
                  btnUpdate2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                  [btnUpdate2 setTitle:@"Void" forState:UIControlStateNormal];
                  [btnUpdate2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                  [btnUpdate2 setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];
                   [btnUpdate2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   [btnUpdate2 addTarget:self action:@selector(doUpdate3) forControlEvents:UIControlEventTouchUpInside];
//                  btnUpdate2.enabled=NO;
                   [uv addSubview:btnUpdate2];
                   y= y+50;
                   
                   }

    if ([pd.Poauthlimit doubleValue]>=[pd.Total doubleValue]) {
    dfdfdf=YES;
    }else{
     dfdfdf=NO;
    }
    
    requestby=[pd.RequestedBy copy];
    uv.contentSize=CGSizeMake(dwidth+20,y+1);
    [ntabbar setSelectedItem:nil];
}


-(void)textFieldDidEndEditing:(UITextField *)theTextField{
    int xtag = (theTextField.tag-20);
    if (xtag %2==1) {
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            float a1 = [theTextField.text floatValue];
            if (a1==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [theTextField becomeFirstResponder];
            }else{
                
                wcfRequestedPO2Item *pi =[pd.PO2Ls objectAtIndex:(xtag-1)/2];
                
                if ([pi.Price floatValue]<a1) {
                    theTextField.text=pi.Price;
                }else{
                    pd.Total= [pd.Total stringByReplacingOccurrencesOfString:@"," withString:@""];
                    float tot = [pd.Total floatValue];
                    if (pi.hastax) {
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                        pi.Price=theTextField.text;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                    }else{
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue];
                        pi.Price=theTextField.text;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue];
                    }
                    pd.Total= [self getFormatFloat:tot];
                    lbl10.text= [NSString stringWithFormat:@"Total: %@",pd.Total ];
                   
                   
                }
                
                
            }
        }
        
        
    }else{
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            float a1 = [theTextField.text floatValue];
            if (a1==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [theTextField becomeFirstResponder];
            }else{
                
                wcfRequestedPO2Item *pi =[pd.PO2Ls objectAtIndex:(xtag)/2];
                
                if ([pi.Quantity floatValue]<a1) {
                    theTextField.text=pi.Quantity;
                }else{
                    
                    pd.Total= [pd.Total stringByReplacingOccurrencesOfString:@"," withString:@""];
                    float tot = [pd.Total floatValue];
                    if (pi.hastax) {
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                        pi.Quantity=theTextField.text;;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                    }else{
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue];
                        pi.Quantity=theTextField.text;;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue];
                    }
                    pd.Total= [self getFormatFloat:tot];
                    lbl10.text= [NSString stringWithFormat:@"Total: %@",pd.Total ];
                }
            }
        }
    }
    
}


-(NSString *) getFormatFloat: (float) fnum{
    NSString *str = [NSString stringWithFormat:@"%.4f", fnum];
    
    int count = [str length];
    if (count>8) {
        for(int i =9; i<=count; i=i+3)
        {
            //        NSLog(@"%d %@ - %@",i, [str substringToIndex:(count-i+1)], [str substringFromIndex:(count-i+1)]);
            str=[NSString stringWithFormat:@"%@,%@",[str substringToIndex:(count-i+1)],  [str substringFromIndex:(count-i+1)] ];
        }
    }
    
    
    return str;
}

- (NSString *)UTIForURL:(NSURL *)url
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
    return (__bridge NSString *)UTI;
}

-(IBAction)openFile:(id)sender{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadvpo.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], idnum,[NSString stringWithFormat:@"tmp.%@", extension]]];
    
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    [data writeToFile:[self GetTempPath:[NSString stringWithFormat:@"tmp.%@", extension]] atomically:NO];
//    
//    BOOL exist = [self isExistsFile:[self GetTempPath:[NSString stringWithFormat:@"tmp.%@", extension]]];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//    if (exist) {
//        NSString *filePath = [self GetTempPath:[NSString stringWithFormat:@"tmp.%@", extension]];
//        NSURL *URL = [NSURL fileURLWithPath:filePath];
//        [self openDocumentInteractionController:URL];
//    }
    
    turl=url;
    _data =[[NSMutableData alloc]init];
    NSURLRequest* updateRequest = [NSURLRequest requestWithURL:url];

    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
    
    self.view.userInteractionEnabled=NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Downloading...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [connection start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
     return [a count];
    }
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if (indexPath.row==[a count]-1) {
        cell.textLabel.text =[a objectAtIndex:(indexPath.row)];
        cell.detailTextLabel.text=@" ";
    }else{
        wcfRequestedPO2Item *kv1 =[a objectAtIndex:(indexPath.row)];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", kv1.Part, kv1.Des];
        [cell.detailTextLabel setNumberOfLines:2];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"Quantity: %@\nPrice: %@", kv1.Quantity, kv1.Part];

    }
       
    
    [cell .imageView setImage:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
   
    if ([extension isEqualToString:@"jpg"]||[extension isEqualToString:@"jpeg"]||[extension isEqualToString:@"png"]||[extension isEqualToString:@"bmp"]||[extension isEqualToString:@"gif"]){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.view.userInteractionEnabled=YES;
        UIImage *img=[UIImage imageWithData:_data];
        
        
        if (img!=nil) {
            float f = uview.frame.size.height/img.size.height;
            
            CGRect r = uview.frame;
            r.size.width=img.size.width*f;
            uview.frame=r;
            uview.image=img;
            uview.userInteractionEnabled = YES;
            uview.layer.cornerRadius=10;
            uview.layer.masksToBounds = YES;
            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
            tapped.numberOfTapsRequired = 1;
            [uview addGestureRecognizer:tapped];}
        
    }else{
        
        
        
        NSString *fname =[NSString stringWithFormat:@"a.%@", extension];
        [_data writeToFile:[self GetTempPath:fname] atomically:NO];
        
        
       
        
        BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        if (exist) {
            
            
            
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            NSString *filePath = [self GetTempPath:fname];
            NSURL *URL = [NSURL fileURLWithPath:filePath];
          
            [self openDocumentInteractionController:URL];
        }else{
         self.view.userInteractionEnabled=YES;
        }
    }
    
}

-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}

-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}
//- (NSString *)UTIForURL:(NSURL *)url
//{
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
//    return (__bridge NSString *)UTI;
//}

- (void)openDocumentInteractionController:(NSURL *)fileURL{
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    docController.delegate = self;
     self.view.userInteractionEnabled=YES;
    
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    if(!isValid){
        
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?",
                                                                         @"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?"), deviceType];
        
        // Display alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil];
        alert.delegate=self;
        alert.tag=10;
        [alert show];
    }
}


  
 
-(IBAction)myFunction :(id) sender
{
    ViewController *si=[ViewController alloc];
    si.managedObjectContext=self.managedObjectContext;
    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadvpo.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], idnum,@"tmp"];
    si.atitle=@"View Picture";
    si.menulist=self.menulist;
    si.detailstrarr=self.detailstrarr;
    si.tbindex=self.tbindex;
    
    
    [self.navigationController pushViewController:si animated:NO];
}

-(BOOL) isNumeric:(NSString *)s
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

-(void)doUpdate1{
    
//    NSString *ttotal =[txtTotal.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([ttotal isEqualToString:@""]) {
//        UIAlertView *alert = [self getErrorAlert: @"Please input Total."];
//        [alert show];
//        [txtTotal becomeFirstResponder];
//        return;
//    }
//    
//    if (![self isNumeric:ttotal]) {
//        UIAlertView *alert = [self getErrorAlert: @"Total must be a number."];
//        [alert show];
//        [txtTotal becomeFirstResponder];
//        return;
//    }
    if ([txtReason.currentTitle isEqualToString:[pickerArray objectAtIndex:0]]) {
        UIAlertView *alert = [self getErrorAlert: @"Please select a Reason."];
        [alert show];
        [txtTotal becomeFirstResponder];
        return;
    }
    
donext=@"1";
    [self autoUpd];
}

-(void)doUpdate2{
    donext=@"2";
    [self autoUpd];
}

-(void)doUpdate3{
    donext=@"3";
    [self autoUpd];
}

-(void)doUpdate4{
    donext=@"4";
    [self autoUpd];
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
        
        NSString *ns=@"";
        float tt=0.0;
        for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
            
            float amt;
            amt=[pi.Quantity floatValue]*[pi.Price floatValue];
            
            
            if ([ns isEqualToString:@""]) {
                ns=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",  pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue], pi.UPC, pi.Des];
            }else{
                ns=[NSString stringWithFormat:@"%@;%@,%@,%@,%@,%@,%@", ns, pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue], pi.UPC, pi.Des];
            }
            
            if (pi.hastax) {
                tt+=amt*(1+[pd.Taxrate floatValue]/100);
            }else{
                tt+=amt;
            }
            
            
            
        }
      
        
      if([donext isEqualToString:@"1"]){
          
          requestpoemail *re = [requestpoemail alloc];
          re.managedObjectContext=self.managedObjectContext;
          re.xxnotes=txtNote.text;
          re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
          re.xxstr=ns;
          re.tbindex=self.tbindex;
          re.menulist=self.menulist;
          re.detailstrarr=self.detailstrarr;
          re.xxdate=txtDate.currentTitle;
          re.xxreason=txtReason.currentTitle;
          re.idnum=self.idnum;
          re.xtype=0;
          re.fromforapprove=self.fromforapprove;
          re.aemail=pd.RequestedBy;
          [self.navigationController pushViewController:re animated:NO];
        }else if([donext isEqualToString:@"2"]){
            // save & finish
            
            requestpoemail *re = [requestpoemail alloc];
            re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
            re.tbindex=self.tbindex;
            re.menulist=self.menulist;
            re.detailstrarr=self.detailstrarr;
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=1;
            re.aemail=requestby;
             re.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:re animated:NO];

        }else if([donext isEqualToString:@"3"]){
            
            requestpoemail *re = [requestpoemail alloc];
            re.tbindex=self.tbindex;
            re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
            re.menulist=self.menulist;
            re.detailstrarr=self.detailstrarr;
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=2;
            re.aemail=requestby;
             re.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:re animated:NO];

        }else if([donext isEqualToString:@"4"]){
            
            requestpoemail *re = [requestpoemail alloc];
            re.tbindex=self.tbindex;
            re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
            re.menulist=self.menulist;
            re.detailstrarr=self.detailstrarr;
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=3;
            re.aemail=requestby;
             re.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:re animated:NO];
        }
        
    }
    
    
}

-(void)getReason{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xgetRequestedPoReason:self action:@selector(xGetPODetailHandler1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"5"];
    }
    
}
- (void) xGetPODetailHandler1: (id) value {
    
	
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

    pickerArray=  [[NSMutableArray alloc]init];
    for (wcfReasonListItem *wi in value) {
        [pickerArray addObject:[NSString stringWithFormat:@"%@ - %@", wi.IDNumber, wi.Name ]];
    }
    if ([pickerArray count]>0) {
         [txtReason setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    }

    
    
   
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (uv.frame.size.width>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-200) animated:YES];
    }
	return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (uv.frame.size.width>500) {
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-240) animated:YES];
    }else{
     [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-210) animated:YES];
    }
	return YES;
    
  
}



-(UITextField *)getFirstResponser{
    UITextField *firstResponder1;
    
    UITextField *firstResponder;
    for (  int i =0;i <[pd.PO2Ls count]*2; i++)
    {
        firstResponder=(UITextField *)[uv viewWithTag:(20+i)];
        if ([firstResponder isFirstResponder])
        {
            firstResponder1=firstResponder;
            break;
        }
        
        
        
    }
    
    return  firstResponder1;
}

- (void)nextClicked{
    if ([txtTotal isFirstResponder]) {
        [txtNote becomeFirstResponder];
    }else if([txtNote isFirstResponder]){
        UITextField *f=(UITextField *)[uv viewWithTag:20];
        [f becomeFirstResponder];
    }else{
        UITextField *f = [self getFirstResponser];
        UITextField *theTextField=f;
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            float a1 = [theTextField.text floatValue];
            if (a1==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [f becomeFirstResponder];
                if (f.frame.origin.y-100>0) {
                    
                    [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
                }
                
                return;
            }else{
                
                int tindex;
                wcfRequestedPO2Item *pi ;
                if (f.tag % 2==1) {
                    tindex=(f.tag-21)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Price floatValue]<a1) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Price;
                    }
                }else{
                    tindex=(f.tag-20)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Quantity floatValue]<a1) {
                        f.text=pi.Quantity;
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                    }
                    
                }
                
            }
        }
        
        f=(UITextField *)[uv viewWithTag:(f.tag+1)];
        
        if (f.enabled) {
            [f becomeFirstResponder];
        }else{
            f=(UITextField *)[uv viewWithTag:(f.tag+1)];
            
            [f becomeFirstResponder];
        }
    }
}

- (void)previousClicked{
    if ([txtNote isFirstResponder]) {
        [txtTotal becomeFirstResponder];
    }else {
        UITextField *f = [self getFirstResponser];
        
        UITextField *theTextField=f;
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            
            float a1 = [theTextField.text floatValue];
            if (a1==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [f becomeFirstResponder];
                if (f.frame.origin.y-100>0) {
                    
                    [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
                }
                
                return;
            }else {
                int tindex;
                wcfRequestedPO2Item *pi ;
                if (f.tag % 2==1) {
                    tindex=(f.tag-21)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Price floatValue]<a1) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Price;
                    }
                }else{
                    tindex=(f.tag-20)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Quantity floatValue]<a1) {
                        
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
                        
//                        return;
                        f.text=pi.Quantity;
                    }
                    
                }
                
                
                
            }
        }
        f=(UITextField *)[uv viewWithTag:(f.tag-1)];
        if (f.enabled) {
            [f becomeFirstResponder];
        }else{
            f=(UITextField *)[uv viewWithTag:(f.tag-1)];
            [f becomeFirstResponder];
        }
    }
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
   
    UITextField *f1 =[self getFirstResponser];
    [f1 resignFirstResponder];
}

-(IBAction)popupscreen:(id)sender{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    
    [actionSheet setTag:2];
    actionSheet.delegate=self;
    
    
    if (pdate ==nil) {
        pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 270, 90)];
        pdate.datePickerMode=UIDatePickerModeDate;
        Mysql *msql=[[Mysql alloc]init];
        if (![txtDate.currentTitle isEqualToString:@""]) {
            [pdate setDate:[msql dateFromString:txtDate.currentTitle]];
        }
        
    }
    [actionSheet addSubview:pdate];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtDate.frame inView:uv animated:YES];
    
        
}

-(IBAction)doRefresh:(id)sender{
    [self getPo];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==2) {
        if (buttonIndex == 0) {
            if (!formatter) {
                formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM/dd/YYYY"];
            }
            [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
        }
        [uv setContentOffset:CGPointMake(0,0) animated:YES];
        
    }  else{
        if (buttonIndex == 0) {
            [txtReason setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
    }
    
}

-(IBAction)popupscreen2:(id)sender{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:nil
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:@"Select"
                                                     otherButtonTitles:nil];
    
    [actionSheet setTag:1];
    actionSheet.delegate=self;
    if (ddpicker ==nil) {
        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 90)];
        ddpicker.showsSelectionIndicator = YES;
        ddpicker.delegate = self;
        ddpicker.dataSource = self;
    }
    
    [actionSheet addSubview:ddpicker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:txtReason.frame inView:uv animated:YES]; // show from our table view (pops up in the middle of the table)
    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:NO];
        }    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	 if(alertView.tag==1){
//        if (buttonIndex==1) {
//            wcfService* service = [wcfService service];
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
//           
//            NSString *ns=@"";
//            UITextField *f =[self getFirstResponser];
//            [f resignFirstResponder];
//            float tt=0.0;
//            for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
//                
//                float amt;
//                amt=[pi.Quantity floatValue]*[pi.Price floatValue];
//                
//                
//                if ([ns isEqualToString:@""]) {
//                    ns=[NSString stringWithFormat:@"%@,%@,%@,%@",  pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue]];
//                }else{
//                    ns=[NSString stringWithFormat:@"%@;%@,%@,%@,%@", ns, pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue]];
//                }
//                
//                if (pi.hastax) {
//                    tt+=amt*(1+[pd.Taxrate floatValue]/100);
//                }else{
//                    tt+=amt;
//                }
//                
//                
//                
//            }
//            
////                        NSLog(@"%@ \n %@ %f %@", ns, pd.PO2Ls, tt, pd.Taxrate);
//            [service xAprroveRequestedPO:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum reason:txtReason.currentTitle xtotal:[NSString stringWithFormat:@"%.4f", tt] xdate:txtDate.currentTitle xnotes:txtNote.text xstr:ns EquipmentType:@"3"];
//            
//            
//        }
     }else if (alertView.tag==10) {
         self.view.userInteractionEnabled=YES;
         if (buttonIndex==1) {
             [[UIApplication sharedApplication] openURL:turl];
         }
    
     }
    
}

- (void) xisupdate_iphoneHandler2: (id) value {
   
    [HUD hide:YES];
    [HUD removeFromSuperViewOnHide];
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
    
    NSString *rtn =(NSString *)value;
    if ([rtn isEqualToString:@"1"]) {
        [self goback1:nil];
    }else if ([rtn isEqualToString:@"2"]) {
        UIAlertView *alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        [self goback1:nil];
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
