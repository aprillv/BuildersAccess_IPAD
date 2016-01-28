//
//  ViewController.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"
#import "mainmenuaaa.h"

@interface ViewController : mainmenuaaa<UIScrollViewDelegate>{
    UIButton *btnNext;
    UIActivityIndicatorView *_spinner;
    NSMutableData *_data;
}

//@property (nonatomic, retain) UIScrollView      *scrollView;

@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;
@property(copy, nonatomic) NSString *xurl;
@property(copy, nonatomic) NSString *atitle;

@end
