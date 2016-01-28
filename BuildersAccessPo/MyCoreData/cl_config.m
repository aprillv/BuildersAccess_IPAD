//
//  cl_config.m
//  BuildersAccess
//
//  Created by amy zhao on 13-6-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_config.h"

@implementation cl_config
@synthesize managedObjectContext;

-(BOOL)getIsTwoPart{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SystemConfig" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([rtnlist count]>0) {
        entity =[rtnlist objectAtIndex:0];
        
        return [[entity valueForKey:@"isTwoPart"] boolValue];
    }else{
        return NO;
    }

}
-(void)setIsTwoPart: (BOOL)value1{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SystemConfig" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSEntityDescription *newentity;
    if ([rtnlist count]>0) {
        newentity =[rtnlist objectAtIndex:0];
        
    }else{
     newentity = [NSEntityDescription insertNewObjectForEntityForName:@"SystemConfig" inManagedObjectContext:[self managedObjectContext]];
    }
   
    [newentity setValue:[NSNumber numberWithBool:value1] forKey:@"isTwoPart"];
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
@end
