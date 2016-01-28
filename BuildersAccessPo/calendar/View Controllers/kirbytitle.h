//
//  kirbytitle.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-31.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"
#import "mainmenuaaa.h"
#import "MBProgressHUD.h"


@interface kirbytitle : mainmenuaaa<MBProgressHUDDelegate>{

    MBProgressHUD *HUD;
}

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;

@end
