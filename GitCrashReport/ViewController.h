//
//  ViewController.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

