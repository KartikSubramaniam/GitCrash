//
//  Task+CoreDataProperties.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 30/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *lastUpdated;

@end

NS_ASSUME_NONNULL_END
