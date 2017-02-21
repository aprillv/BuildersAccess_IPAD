//
//  project.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"

@interface project : mainmenuaaa<UIAlertViewDelegate,UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>{
    UIDocumentInteractionController *docController;
     NSString *xemail;
    UITableView *tbview;
    NSMutableArray *qllist;
    UIScrollView *sv;
    UIButton *btnNext;
}

@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property(copy, nonatomic) NSString *idproject;
@end
