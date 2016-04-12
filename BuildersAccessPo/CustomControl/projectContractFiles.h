//
//  projectContractFiles.h
//  BuildersAccess
//
//  Created by April on 4/12/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wcfProjectFile.h"

@protocol projectContractFilesDelegate<NSObject>
-(void)openFiles: (wcfProjectFile *)fileItem;
@end

@interface projectContractFiles : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray  *fileListresult;
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property(retain, nonatomic) NSString *idproject;
@property(retain, nonatomic) NSString *projectname;

- (IBAction)dismissaaa:(id)sender;

@property(retain, nonatomic) id <projectContractFilesDelegate> delegate;
@end
