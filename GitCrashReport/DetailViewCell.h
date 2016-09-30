//
//  DetailViewCell.h
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UITextView *comments;

@end
