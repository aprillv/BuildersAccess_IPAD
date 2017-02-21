//
//  ViewController.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "ViewController.h"
#import "Mysql.h"

#define NAVBAR_HEIGHT   44
@interface ViewController (){
//    int i;
}

@end

@implementation ViewController
@synthesize xurl, atitle;

-(IBAction)goBack:(id)sender
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=atitle;
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
    
//    _zoomScrollView = [[MRZoomScrollView alloc]init];
//   
//    
//    CGRect frame;
//    frame.size.width=self.uw.frame.size.width*2;
//    frame.size.height=self.uw.frame.size.height*2;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    
//    _zoomScrollView.frame = frame;
//    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
////    
////    [_zoomScrollView initImageView:(self.uw.frame.size.width) andHeight:self.uw.frame.size.height];
//    
//    [self.uw addSubview:_zoomScrollView];

    
    
    
    
    
        [self.uw setBackgroundColor:[UIColor blackColor]];
    
    
//    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _spinner.hidesWhenStopped = YES;
//    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    _spinner.center = CGPointMake(floorf(self.uw.frame.size.width/2.0),
//                                  floorf(self.uw.frame.size.height/2.0));
//    [_spinner startAnimating];
//[self httpAsynchronousRequest];
    
    _data =[[NSMutableData alloc]init];
    NSURLRequest* updateRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:xurl]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.hidesWhenStopped = YES;
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.uw addSubview:_spinner];
    _spinner.center = CGPointMake(floorf(self.uw.frame.size.width/2.0),
                                  floorf(self.uw.frame.size.height/2.0));
    [_spinner startAnimating];
    [connection start];
    
    
}

- (void)httpAsynchronousRequest{
    
    NSURL *url = [NSURL URLWithString:xurl];
    
    NSString *post=@"postData";
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
                               }else{
                                   
                                   self.uw.backgroundColor=[UIColor whiteColor];
                                   [_spinner stopAnimating];
                                   [_spinner removeFromSuperview];
                                   if (data!=nil) {
                                       UIImage *img=[UIImage imageWithData:data];
                                       
                                       _zoomScrollView = [[MRZoomScrollView alloc]init];
                                       int xs =img.size.width;
                                       
                                       float xt = self.uw.frame.size.width/xs;
                                       int xh = img.size.height*xt;
                                       
                                       [_zoomScrollView initImageView:(xs/self.uw.frame.size.width) andHeight:xh];
                                       //            NSLog(@"%f %f %d", img.size.width, img.size.height, xh);
                                       
                                       _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                                       CGRect frame = self.uw.frame;
                                       frame.origin.x = 0;
                                       frame.origin.y = 0;
                                       
                                       _zoomScrollView.frame = frame;
                                       _zoomScrollView.imageView.image =img;
                                       [self.uw addSubview:_zoomScrollView];
                                     

                                   }

                                   
//                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                   
//                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   
//                                   NSLog(@"HttpResponseCode:%d", responseCode);
//                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.uw.backgroundColor=[UIColor whiteColor];
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    UIImage *img=[UIImage imageWithData:_data];
   
    _zoomScrollView = [[MRZoomScrollView alloc]init];
    int xs =img.size.width;
    
    float xt = self.uw.frame.size.width/xs;
    int xh = img.size.height*xt;
    
    [_zoomScrollView initImageView:(xs/self.uw.frame.size.width) andHeight:xh];
    //            NSLog(@"%f %f %d", img.size.width, img.size.height, xh);
  
    _zoomScrollView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect frame = self.uw.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    _zoomScrollView.frame = frame;
    _zoomScrollView.imageView.image =img;
    [self.uw addSubview:_zoomScrollView];
    
    

}

-(IBAction)gosmall:(id)sender{
    [super gosmall:sender];
    btnNext.frame = CGRectMake(10, 26, 40, 32);
}
-(IBAction)gobig:(id)sender{
    [super gobig:sender];
    btnNext.frame = CGRectMake(60, 26, 40, 32);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
