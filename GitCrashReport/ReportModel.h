//
//  CrashReportModel.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject
{
    NSString *title;
    NSString *body;
    NSString *updatedTimeStamp;
    NSString *commentUrl;
    NSString *number;
}
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* body;
@property (nonatomic) NSString* updatedTimeStamp;
@property (nonatomic) NSString* commentUrl;
@property (nonatomic) NSString* number;

@end
