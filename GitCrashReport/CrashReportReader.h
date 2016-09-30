//
//  CrashReportReader.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashReportReader : NSObject

-(NSMutableArray *)parse:(NSData *)data;
@end
