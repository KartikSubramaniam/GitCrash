//
//  Database.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 28/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

+(Database *)sharedInstance;

-(void)insertData:(NSArray *)parameters;
-(NSArray *)fetchData:(id)tableInstance :(NSPredicate *)query :(NSSortDescriptor *)orderBy;
-(void)updateData :(id)tableInstance :(NSPredicate *)query ;
- (void) deleteAllObjects: (NSString *) entityDescription;

@end
