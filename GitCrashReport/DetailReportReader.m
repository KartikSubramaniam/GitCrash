//
//  DetailReportReader.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "DetailReportReader.h"
#import "DetailModel.h"

@implementation DetailReportReader

-(NSMutableArray *)parse:(NSData *)data :(NSString *)crashId{
    
    NSError *error;
    NSArray *rawData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *parsedData = [[NSMutableArray alloc]init];
    
    
    for(NSDictionary *parseData in rawData){
        DetailModel *detailModel = [[DetailModel alloc]init];
        [detailModel setBody:[parseData objectForKey:@"body"]];
        [detailModel setUpdatedTimeStamp:[parseData objectForKey:@"updated_at"]];
        [detailModel setCrashId:crashId];
        
        NSDictionary *user = [parseData objectForKey:@"user"];
        [detailModel setUserId:[user objectForKey:@"login"]];
        [parsedData addObject:detailModel];
    }
    return parsedData;
}


@end
