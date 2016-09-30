//
//  TableViewCell.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *information;
@property (weak, nonatomic) IBOutlet UILabel *issueTitle;
@property (weak, nonatomic) IBOutlet UITextView *issueBody;


@end
