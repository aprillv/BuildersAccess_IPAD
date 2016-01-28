//
//  po1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfPODetail.h"
#import "MBProgressHUD.h"

@interface po1 : mainmenuaaa<UIAlertViewDelegate, MBProgressHUDDelegate>{
   
    int xtype;
    wcfPODetail *pd;
    NSString *kv;
    MBProgressHUD* HUD;
    UIScrollView *uv;
    UIButton *btnNext;
}


@property(copy, nonatomic) NSString *idpo1;
@property(copy, nonatomic) NSString *xcode;
//1 from for approve
//2 from development
//3 from project
//4 from multi search
@property int fromforapprove;
@end

