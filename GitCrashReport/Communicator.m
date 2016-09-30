//
//  Communicator.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "Communicator.h"

@implementation Communicator

-(void)getRequest:(NSURL *)url{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    communicationState = requestInitialized;
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            communicationState = responseRecieved;
            if(error == nil)
            {
                communicationState = requestFinished;
                if (!body) {
                     body = [NSMutableData data];
                    [body appendData:data];
                }
                NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                NSLog(@"Data = %@",text);
            }
            
        }];
    
    [dataTask resume];
    
}

-(void)waitTillCommunicationCompletion {
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while ((communicationState != requestFinished) && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

-(NSData *)getData{
    [self waitTillCommunicationCompletion];
    return body;
}


@end
