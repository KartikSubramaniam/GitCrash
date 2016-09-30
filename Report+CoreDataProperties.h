//
//  Report+CoreDataProperties.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 30/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Report.h"

NS_ASSUME_NONNULL_BEGIN

@interface Report (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *commentsLink;
@property (nullable, nonatomic, retain) NSString *crashId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *updatedTimeStamp;

@end

NS_ASSUME_NONNULL_END
