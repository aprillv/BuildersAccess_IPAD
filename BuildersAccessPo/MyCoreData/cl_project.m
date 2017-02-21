//
//  cl_project.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_project.h"
#import "wcfProjectListItem.h"
#import "userInfo.h"
#import "wcfProjectItem.h"

@implementation cl_project

@synthesize managedObjectContext;

-(BOOL)addToProject:(NSMutableArray *)result1 andscheleyn: (NSString *)scheduleyn{
    NSManagedObject *steve;
    NSError *error = nil;
    for(wcfProjectListItem *kv in result1){
        steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatProject" inManagedObjectContext:[self managedObjectContext]];
        [steve setValue:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] forKey:@"idcia"];
        [steve setValue:kv.IDNumber forKey:@"idnumber"];
        [steve setValue:kv.ProjectName forKey:@"name"];
        [steve setValue:kv.PlanName forKey:@"planname"];
        [steve setValue:kv.Status forKey:@"status"];
        
        if ([scheduleyn isEqualToString:@"1"] ) {
            if (kv.StageItem ==0) {
                [steve setValue:@"0" forKey:@"isactive"];
            }else{
                [steve setValue:@"1" forKey:@"isactive"];
            }
        }else{
            if (!kv.Idfloorplan) {
                [steve setValue:@"0" forKey:@"isactive"];
                
            }else{
                [steve setValue:@"1" forKey:@"isactive"];
            }
        }
        
        if ([[kv.IDNumber substringFromIndex:[kv.IDNumber length]-3]isEqualToString:@"000"]) {
            [steve setValue:@"-1" forKey:@"isactive"];
        }
        
        
        
        
        
        BOOL isSaveSuccess=[self.managedObjectContext save:&error];
        
        if (!isSaveSuccess) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"BuildersAccess"
                                  message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}
-(NSMutableArray *)getProjectList:(NSString *)str{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject" inManagedObjectContext:self.managedObjectContext];

    [request setEntity:entity];
    
    if (str==nil) {
       str=[NSString stringWithFormat:@"idcia ='%d'", [userInfo getCiaId]]; 
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
//    [rtnlist sortUsingComparator:^NSComparisonResult(NSEntityDescription * obj1, NSEntityDescription * obj2) {
//        if ([obj1 valueForKey:@"planname"]==nil || [[obj1 valueForKey:@"planname"] isEqualToString:@""]) {
//            return NSOrderedDescending;
//        }else{
//            return  NSOrderedAscending;
//        }
//        
//    }];

//    for (entity in rtnlist) {
//        NSLog(@"%@", [entity valueForKey:@"idnumber"]);
//    }
    
//    NSLog(@"%@", [entity valueForKey:@"idnumber"]);
    return rtnlist;

}

//-(NSMutableArray *)getProjectList:(NSString *)str :(NSString *)sortkey :(BOOL) isup{
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject" inManagedObjectContext:self.managedObjectContext];
//    
//    [request setEntity:entity];
//    
//    if (str==nil) {
//        str=[NSString stringWithFormat:@"idcia ='%d'", [userInfo getCiaId]];
//    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//    [request setPredicate:predicate];
//    
//    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:sortkey ascending:isup];
//    
//    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
//    [request setSortDescriptors:sortDescriptions];
//    
//    NSError *error = nil;
//    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//  
//    return rtnlist;
//    
//}


-(void)deletaAll:(int)xtype{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    switch (xtype) {
        case 0:
            str=[NSString stringWithFormat:@"idcia ='%d'", [userInfo getCiaId]];
            break;
        case 1:
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
            break;
        case 2:
            str=[NSString stringWithFormat:@"idcia ='%d' and (status<>'Development' and status<>'Closed'  and isactive='1')", [userInfo getCiaId]];
            break;
        case 3:
            str=[NSString stringWithFormat:@"idcia ='%d' and (status<>'Development' and status<>'Closed'  and isactive='0')", [userInfo getCiaId]];
            break;

        default:
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
            break;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *entity1 in mutableFetchResult) {
        [self.managedObjectContext deleteObject:entity1];
    }

}

-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"idcia ='%d' and idnumber='%@'", [userInfo getCiaId], idproject];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *steve in mutableFetchResult) {
       
        [steve setValue:pi.Name forKey:@"name"];
        [steve setValue:pi.PlanName forKey:@"planname"];
        [steve setValue:pi.Status forKey:@"status"];
        
        
        BOOL isSaveSuccess=[self.managedObjectContext save:&error];
        
        if (!isSaveSuccess) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"BuildersAccess"
                                  message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }    
}

-(void)deletaAllCias{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *entity1 in mutableFetchResult) {
        [self.managedObjectContext deleteObject:entity1];
    }
    
}

@end
