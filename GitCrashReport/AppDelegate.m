//
//  AppDelegate.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "AppDelegate.h"
#import "Communicator.h"
#import "Database.h"
#import "CrashReportReader.h"
#import "ReportModel.h"
#import "Reachability.h"
#import "TaskModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *databasePath = [NSString stringWithFormat:@"%@", docs];
    NSLog(@"%@",databasePath);
    
    Database *database = [Database sharedInstance];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@" crashId !='' "];
    NSSortDescriptor *orderBy = [[NSSortDescriptor alloc]initWithKey:@"updatedTimeStamp" ascending:NO];
    
    NSArray *reportData = [database fetchData:[[ReportModel alloc]init] :query :orderBy];
    
    if([reportData count] > 0){
        
        NSPredicate *query = [NSPredicate predicateWithFormat:@" lastUpdated !='' "];
        NSArray *lastUpdatedData = [database fetchData:[[TaskModel alloc]init] :query :nil];
        
        TaskModel *task = [lastUpdatedData objectAtIndex:0];
        double previous = [task.lastUpdated doubleValue];
        double current = [[NSDate new] timeIntervalSince1970];
        NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:current] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:previous]];
        int difference = (int)(differ/3600);
        
        if(difference >= 24){
            TaskModel *taskModel = [[TaskModel alloc]init];
            taskModel.lastUpdated = [NSString stringWithFormat:@"%f",current];
            [database updateData:taskModel :query];
            [database deleteAllObjects:@"Report"];
            [database deleteAllObjects:@"Detail"];
            [self updateDatabase];
        }
        
    }else {
        [self updateDatabase];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)updateDatabase {
    Database *database = [Database sharedInstance];
    if([self hasInternet]){
        Communicator *communicator = [[Communicator alloc]init];
        CrashReportReader *reader = [[CrashReportReader alloc]init];
        NSURL *url = [NSURL URLWithString:@"https://api.github.com/repos/crashlytics/secureudid/issues"];
        [communicator getRequest:url];
        
        NSData *data = [communicator getData];
        
        //get the json data
        NSArray * titleData = [reader parse:data];
        [database insertData:titleData];
        
        double current = [[NSDate new] timeIntervalSince1970];
        TaskModel *task = [[TaskModel alloc]init];
        task.lastUpdated = [NSString stringWithFormat:@"%f",current];
        NSArray *taskData = [[NSArray alloc]initWithObjects:task, nil];
        [database insertData:taskData];
    }
}

-(BOOL) hasInternet {
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    if(internetStatus == NotReachable){
        return false;
    } else {
        return true;
    }
}


@end
