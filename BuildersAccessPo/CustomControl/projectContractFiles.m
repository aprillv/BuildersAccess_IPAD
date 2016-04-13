//
//  projectContractFiles.m
//  BuildersAccess
//
//  Created by April on 4/12/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "projectContractFiles.h"
#import "wcfService.h"
#import "wcfProjectFile.h"
#import "userInfo.h"
#import "MBProgressHUD.h"

@implementation projectContractFiles{
    MBProgressHUD *HUD;
}

@synthesize idproject, projectname, docController;
#pragma mark - TableView Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint p = [touch locationInView:self.view];
    return !CGRectContainsPoint(self.tableView.frame, p);

    
}
- (IBAction)dismissaaa:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.layer.cornerRadius = 10.f;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    lbl.font = [UIFont boldSystemFontOfSize:18];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    lbl.text = @"Contract Files";
    return lbl;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.fileListresult count]; // or self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    wcfProjectFile *cia =[self.fileListresult objectAtIndex:indexPath.row];
    //    NSString *idnm = [cia valueForKey:@"ciaid"];
    cell.textLabel.text = cia.FName;
    [cell.imageView setImage:nil];
    return cell;
    
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    cl_cia *mcia =[[cl_cia alloc]init];
//    mcia.managedObjectContext=self.managedObjectContext;
//    fileListresult =[mcia getCiaList];
//
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wcfProjectFile *item = [self.fileListresult objectAtIndex: indexPath.row];
  
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate openFiles:item];
        }
    }];
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.labelText=@"Download Project's Contract File...";
//    HUD.dimBackground = YES;
//    //    HUD.delegate = self;
//    [HUD show:YES];
//    //                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project File..." delegate:self otherButtonTitles:nil];
//    
//    //                [alertViewWithProgressbar show];
//    NSString *str;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    
//    NSString *url1 = [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname%@", item.ID, [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue], item.FSize, [item.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    wcfService* service = [wcfService service];
//    str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, projectname]stringByAddingPercentEscapesUsingEncoding:
//         NSASCIIStringEncoding];
//    
//    NSString* escapedUrlString =
//    [[NSString stringWithFormat:@"<view> %@", item.FName] stringByAddingPercentEscapesUsingEncoding:
//     NSASCIIStringEncoding];
//    
//    [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
//    
//    NSURL *url = [NSURL URLWithString:url1];
//    [self downloadFile: url];
    //    [self autoUpd];
}


@end
