//
//  Database.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 28/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "Database.h"
#import "CoreDataStack.h"
#import "ReportModel.h"
#import "DetailModel.h"
#import "Detail.h"
#import "Report.h"
#import "TaskModel.h"
#import "Task.h"

static Database *database = nil;
static CoreDataStack *coreDataStack = nil;

@implementation Database

+(Database *)sharedInstance {
    
    if(database == nil){
        database = [[Database alloc]init];
        coreDataStack = [[CoreDataStack alloc]init];
    }
    return database;
}

-(void)insertData:(NSArray *)parameters {
    
    NSString *tableName = NSStringFromClass([[parameters objectAtIndex:0] class]);
    
    if([tableName containsString:@"Report"]){
        
        for(ReportModel *reports in parameters){
            NSManagedObject *report = [NSEntityDescription insertNewObjectForEntityForName:@"Report" inManagedObjectContext:[coreDataStack managedObjectContext]];
            [report setValue:reports.title forKey:@"title"];
            [report setValue:reports.number forKey:@"crashId"];
            [report setValue:reports.body forKey:@"body"];
            [report setValue:reports.commentUrl forKey:@"commentsLink"];
            [report setValue:reports.updatedTimeStamp forKey:@"updatedTimeStamp"];
            
            [coreDataStack saveContext];
            
        }
        
    }else if([tableName containsString:@"Detail"]){
        
        for(DetailModel *details in parameters){
            NSManagedObject *detail = [NSEntityDescription insertNewObjectForEntityForName:@"Detail" inManagedObjectContext:[coreDataStack managedObjectContext]];
            [detail setValue:details.body forKey:@"commentsBody"];
            [detail setValue:details.updatedTimeStamp forKey:@"updatedTimeStamp"];
            [detail setValue:details.userId forKey:@"userId"];
            [detail setValue:details.crashId forKey:@"crashId"];
            
            [coreDataStack saveContext];
        }
    } else if([tableName containsString:@"Task"]){
         NSManagedObject *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[coreDataStack managedObjectContext]];
        for(TaskModel *tasks in parameters){
            [task setValue:tasks.lastUpdated forKey:@"lastUpdated"];
            [coreDataStack saveContext];
        }
        
        
    }
}

-(NSArray *)fetchData:(id)tableInstance :(NSPredicate *)query :(NSSortDescriptor *)orderBy{
   
    NSString *tableName = NSStringFromClass([tableInstance class]);
    NSManagedObjectContext *context = [coreDataStack managedObjectContext];
    NSMutableArray *modularData = [[NSMutableArray alloc]init];
    if([tableName containsString:@"Report"]){
       
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Report"];
        [request setPredicate:query];
        if(orderBy != nil){
            [request setSortDescriptors:[NSArray arrayWithObjects:orderBy, nil]];
        }
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if (error != nil) {
            
            //Deal with failure
        }
        else {
            
            for(NSManagedObject *result in results){
                
                NSArray *keys = [[[result entity] attributesByName] allKeys];
                NSDictionary *dictionary = [result dictionaryWithValuesForKeys:keys];
                
                ReportModel *report = [[ReportModel alloc]init];
                report.body = [dictionary objectForKey:@"body"];
                report.commentUrl = [dictionary objectForKey:@"commentsLink"];
                report.title = [dictionary objectForKey:@"title"];
                report.updatedTimeStamp = [dictionary objectForKey:@"updatedTimeStamp"];
                report.number = [dictionary objectForKey:@"crashId"];
               
                [modularData addObject:report];
            }
        }
    } else if ([tableName containsString:@"Detail"]){
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Detail"];
        [request setPredicate:query];
        
        if(orderBy != nil){
            [request setSortDescriptors:[NSArray arrayWithObjects:orderBy, nil]];
        }
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if (error != nil) {
            
            //Deal with failure
        }
        else {
            for(NSManagedObject *result in results){
                
                NSArray *keys = [[[result entity] attributesByName] allKeys];
                NSDictionary *dictionary = [result dictionaryWithValuesForKeys:keys];
                
                DetailModel *detail = [[DetailModel alloc]init];
                detail.body = [dictionary objectForKey:@"commentsBody"];
                detail.userId = [dictionary objectForKey:@"userId"];
                detail.crashId = [dictionary objectForKey:@"crashId"];
                detail.updatedTimeStamp = [dictionary objectForKey:@"updatedTimeStamp"];
                
                [modularData addObject:detail];
            }
        }
    } else if ([tableName containsString:@"Task"]){
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Task"];
        [request setPredicate:query];
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if (error != nil) {
            
            //Deal with failure
        }
        for(NSManagedObject *result in results){
            
            NSArray *keys = [[[result entity] attributesByName] allKeys];
            NSDictionary *dictionary = [result dictionaryWithValuesForKeys:keys];
            
            TaskModel *task = [[TaskModel alloc]init];
            task.lastUpdated = [dictionary objectForKey:@"lastUpdated"];
            
            [modularData addObject:task];
        }
    }
    return modularData;
}

-(void)updateData :(id)tableInstance :(NSPredicate *)query {
    
    NSString *tableName = NSStringFromClass([tableInstance class]);
    NSManagedObjectContext *context = [coreDataStack managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   
    if([tableName containsString:@"Report"]){
       
        ReportModel *tableDetail = tableInstance;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Report" inManagedObjectContext:context];
        [fetchRequest setPredicate:query];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        
        for(int i = 0 ; i < [arrResult count]; i++){
            
            Report *report = [arrResult objectAtIndex:i];
            
            report.commentsLink = tableDetail.commentUrl;
            report.body = tableDetail.body;
            report.title = tableDetail.title;
            report.updatedTimeStamp = tableDetail.updatedTimeStamp;
            report.crashId = tableDetail.number;
            
            [coreDataStack saveContext];
            
        }
        
    } else if([tableName containsString:@"Detail"]) {
       
        DetailModel *tableDetail = tableInstance;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Detail" inManagedObjectContext:context];
        [fetchRequest setPredicate:query];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        
        for(int i = 0 ; i < [arrResult count]; i++){
           
            Detail *detail = [arrResult objectAtIndex:i];
            
            detail.commentsBody = tableDetail.body;
            detail.userId = tableDetail.userId;
            detail.crashId = tableDetail.crashId;
            detail.updatedTimeStamp = tableDetail.updatedTimeStamp;
            
            [coreDataStack saveContext];
        
        }
    } else if([tableName containsString:@"Task"]){
        TaskModel *tableDetail = tableInstance;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
        [fetchRequest setPredicate:query];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
        for(int i = 0 ; i < [arrResult count]; i++){

            Task *task = [arrResult objectAtIndex:i];
            
            task.lastUpdated = tableDetail.lastUpdated;
            [coreDataStack saveContext];
        }
    }
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [coreDataStack managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

@end
