//
//  fathercontroller.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-12.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fViewController.h"

@interface fathercontroller : fViewController

-(IBAction)gohome:(id)sender;
-(IBAction)goBack:(id)sender;
-(UIBarButtonItem *)getbackButton;
@end
