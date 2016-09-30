//
//  DetailController.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : UIViewController <UIAlertViewDelegate>
{
    NSURL *url;
    NSString *title;
    NSString *number;
}
@property (weak, nonatomic) IBOutlet UITableView *detailView;
@property(nonatomic) NSURL *url ;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *number;

@end
