//
//  selectioncalendar.h
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "MBProgressHUD.h"
#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface selectioncalendar : mainmenuaaa<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;


@end
