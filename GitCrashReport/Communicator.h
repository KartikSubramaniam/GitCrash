//
//  Communicator.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger requestInitialized = 100;
static NSInteger responseRecieved = 101;
static NSInteger requestFinished = 102;

@interface Communicator : NSURLSession
{
   NSInteger communicationState;
   NSMutableData *body;
}

-(void)getRequest:(NSURL *)url;
-(NSData *)getData;



@end
