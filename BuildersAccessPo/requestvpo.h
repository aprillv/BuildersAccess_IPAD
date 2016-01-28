//
//  requestvpo.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenuaaa.h"
#import "wcfRequestedPODetail.h"
#import "MBProgressHUD.h"
#import "requestpoemail.h"

@interface requestvpo : mainmenuaaa<UIAlertViewDelegate,UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>{
    
    int xtype;
    
    NSString *kv;
    UIDocumentInteractionController *docController;
    
    
}


@property(copy, nonatomic) NSString *idnum;
@property(copy, nonatomic) NSString *xcode;
@property (nonatomic, strong) UIDocumentInteractionController *docController;
//1 from for approve
//2 from development
//3 from project

@property int fromforapprove;



@end
