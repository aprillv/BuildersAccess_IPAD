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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wcfProjectFile *item = [self.fileListresult objectAtIndex: indexPath.row];
  
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate openFiles:item];
        }
    }];
}


@end
