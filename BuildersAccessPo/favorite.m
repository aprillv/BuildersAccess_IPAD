//
//  favorite.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "favorite.h"
#import "cl_favorite.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "project.h"
#import "userInfo.h"
#import "cl_cia.h"
#import "Reachability.h"
#import "wcfService.h"
#import "projectCell.h"
#import "dfirstCell.h"
#import "firstcell.h"
#import "developmentCell.h"

#define NAVBAR_HEIGHT   44


@interface favorite ()<dfirstcellDelegate, firstcellDelegate>

@end

@implementation favorite{
    NSMutableArray *rtnlist;
    NSMutableArray *rtnlist1;
    firstcell *cell2;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Favorites"];
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"back.png"] ];
    //    UITabBarItem *t = [ntabbar.items objectAtIndex:6];
    //    [t setTitlePositionAdjustment:UIOffsetMake(100, 0)];
    //    [t setImageInsets:UIEdgeInsetsMake(0, 200, 0, 0)];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Go Back" ];
    [[ntabbar.items objectAtIndex:0]setEnabled:YES ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
   
    
    [self getPojectls];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:nil];
    }
}



-(void)doaClicked:(NSString *)str :(BOOL) isup{
    
    [rtnlist sortUsingComparator:^NSComparisonResult(NSEntityDescription* obj1, NSEntityDescription* obj2) {
        
        
        if (isup) {
            return [[obj1 valueForKey:str] compare:[obj2 valueForKey:str]];
        }else{
            return [[obj2 valueForKey:str] compare:[obj1 valueForKey:str]];
        }
        
    }];
    [tbview reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [ntabbar setSelectedItem:nil];
}

-(void)getPojectls{

    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.uw.frame.size.width, 44)];
    [self.uw addSubview: searchBar];
    searchBar.delegate=self;
    searchBar.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    rtnlist = [mf getProject:nil];
    rtnlist1=rtnlist;
    [tbview removeFromSuperview];
    int dh = ([rtnlist count]+1)*44;
    if (dh > self.uw.frame.size.height-44) {
        dh= self.uw.frame.size.height-44;
    }
    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.uw.frame.size.width, dh)];
//    tbview.layer.cornerRadius = 10;
    tbview.tag=2;
//    tbview.layer.borderWidth = 1.2;
//    tbview.layer.borderColor=[[UIColor colorWithWhite: 0.7 alpha: 1.0] CGColor];
//    [tbview setRowHeight:66.0f];
    
    tbview.delegate = self;
    tbview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    tbview.dataSource = self;
    [self.uw addSubview:tbview];

}

-(void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    str=[NSString stringWithFormat:@"name like [c]'*%@*' or planname like [c]'*%@*' or idnumber like [c]'%@*' or status like [c]'*%@*'", searchText, searchText, searchText,searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else{
    return ([rtnlist count]);
    }
     // or self.items.count;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        if (!cell2) {
            cell2 = [[firstcell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.delegate=self;
        }
        return cell2;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (tableView.tag ==1)
		return 0;
	else
		return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        static NSString *CellIdentifier;
        
//        if (indexPath.row==0) {
//            CellIdentifier = @"Cell";
////           if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
////                dfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////                if (cell == nil)
////                {
////                    cell = [[dfirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
////                    cell.accessoryType = UITableViewCellAccessoryNone;
////                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                }
////                cell.delegate=self;
////                
////                return cell;
////            }else{
//                firstcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                if (cell == nil)
//                {
//                    cell = [[firstcell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                
//                cell.delegate=self;
//                
//                return cell;
////            }
//        }else{
             NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
            CellIdentifier = @"Cell1";
//            if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
//                developmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                cell = [[developmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//                cell.accessoryType = UITableViewCellSelectionStyleNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row-1)];
//                cell.idproject=[kv valueForKey:@"idnumber"];
//                cell.projectname=[kv valueForKey:@"name"];
//                cell.status=[kv valueForKey:@"status"];
//                [cell .imageView setImage:nil];
//                return cell;
//            }else{
                projectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = [[projectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellSelectionStyleNone;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.idproject=[kv valueForKey:@"idnumber"];
                cell.planname=[kv valueForKey:@"planname"];
                cell.projectname=[kv valueForKey:@"name"];
                cell.status=[kv valueForKey:@"status"];
                [cell .imageView setImage:nil];
                return cell;
//            }
        }
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==2) {
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
        }else{
            wcfService* service = [wcfService service];
            NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xisupdate_ipad:self action:@selector(xisupdate_iphoneHandler:) version:version];
        }
    }else{
        if (indexPath.row==self.tbindex) {
            [self getPojectls];
        }else{
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        [searchBar resignFirstResponder];
        NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
        
        cl_cia *ma = [[cl_cia alloc]init];
        ma.managedObjectContext=self.managedObjectContext;
        NSMutableArray *rtnls =[ma getCiaListWithStr:[NSString stringWithFormat:@"ciaid=%@", [kv valueForKey:@"idcia"]]];
        if ([rtnls count]==1) {
            NSEntityDescription *cia=[rtnls objectAtIndex:0];
            [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"] intValue] andNm:[cia valueForKey:@"cianame"]];
            
            if ([[kv valueForKey:@"Status"] isEqualToString:@"Development"]) {
                development *LoginS=[[development alloc]init];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.menulist=self.menulist;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.tbindex=self.tbindex;
                LoginS.idproject=[kv valueForKey:@"idnumber"];
                [self.navigationController pushViewController:LoginS animated:NO];
            }else{
                project *LoginS=[[project alloc]init];
                LoginS.idproject=[kv valueForKey:@"idnumber"];
                LoginS.menulist=self.menulist;
                LoginS.detailstrarr=self.detailstrarr;
                LoginS.tbindex=self.tbindex;
                LoginS.managedObjectContext=self.managedObjectContext;
                 [self.navigationController pushViewController:LoginS animated:NO];
            }
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
