//
//  development.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"


@interface development : mainmenuaaa<UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *docController;
    NSString *xemail;
    UIScrollView *sv;
    UIButton *btnNext;
}

@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property(copy, nonatomic) NSString *idproject;
@end
