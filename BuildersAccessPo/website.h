//
//  website.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"

@interface website : mainmenuaaa<UIWebViewDelegate>{
    UIButton *btnNext;
    UIWebView *webview1;
}
@property (nonatomic, retain) NSString *Url;
@property (nonatomic, retain) NSString *atitle;
@end
