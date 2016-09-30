//
//  DetailReportReader.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailReportReader : NSObject

-(NSMutableArray *)parse:(NSData *)data :(NSString *)crashId;

@end
