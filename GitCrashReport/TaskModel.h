//
//  TaskModel.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 30/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject
{
    NSString *lastUpdated;
}

@property(nonatomic) NSString *lastUpdated;
@end
