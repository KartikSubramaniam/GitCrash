//
//  CrashReportReader.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "CrashReportReader.h"
#import "ReportModel.h"

@implementation CrashReportReader

-(NSMutableArray *)parse:(NSData *)data {
    
    NSError *error;
    NSArray *rawData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *parsedData = [[NSMutableArray alloc]init];
   
    
    for(NSDictionary *parseData in rawData){
         ReportModel *crashModel = [[ReportModel alloc]init];
        [crashModel setTitle:[parseData objectForKey:@"title"]];
        [crashModel setCommentUrl:[parseData objectForKey:@"comments_url"]];
        [crashModel setBody:[parseData objectForKey:@"body"]];
        [crashModel setUpdatedTimeStamp:[parseData objectForKey:@"updated_at"]];
        [crashModel setNumber:[NSString stringWithFormat:@"%@",[parseData objectForKey:@"number"]]];
        
        [parsedData addObject:crashModel];
    }
    return parsedData;
}



@end
