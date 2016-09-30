//
//  DetailReportModel.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
{
    NSString *body;
    NSString *updatedTimeStamp;
    NSString *userId;
    NSString *crashId;
}

@property (nonatomic) NSString *body;
@property (nonatomic) NSString *updatedTimeStamp;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *crashId;

@end
