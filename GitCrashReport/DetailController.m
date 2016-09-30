//
//  DetailController.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "DetailController.h"
#import "Communicator.h"
#import "DetailReportReader.h"
#import "DetailViewCell.h"
#import "DetailModel.h"
#import "Database.h"
#import "Reachability.h"

@implementation DetailController
{
    NSArray *data;
}
@synthesize url,title,number;

- (void)viewDidLoad {
    [super viewDidLoad];
    data = nil;
    
    Database *database = [Database sharedInstance];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@" crashId = %@",number];
    NSSortDescriptor *orderBy = [[NSSortDescriptor alloc]initWithKey:@"updatedTimeStamp" ascending:NO];
    
    NSArray *detailData = [database fetchData:[[DetailModel alloc]init] :query :orderBy];
    
    if([detailData count] == 0){
        if ( [self hasInternet]){
            Communicator *communicator = [[Communicator alloc]init];
            DetailReportReader *reader = [[DetailReportReader alloc]init];
            [communicator getRequest:url];
            data = [reader parse:[communicator getData] :number];
            [database insertData:data];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Internet" message:@"Can't connect to the server" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil];
            [alert show];
        }
        
    } else{
        data = detailData;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else{
        [self viewDidLoad];
        self.detailView.reloadData;
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [data count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"DetailCell";
    
    DetailViewCell *cell = (DetailViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[DetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    DetailModel *detailModel = [[DetailModel alloc]init];
    detailModel = [data objectAtIndex:indexPath.row];
    
    //corner radius for text view
    cell.comments.clipsToBounds = YES;
    cell.comments.layer.cornerRadius = 10.0f;
    cell.comments.text = detailModel.body;
    
    cell.userId.text = detailModel.userId;
    
    //table view corner
    self.detailView.separatorColor = [UIColor grayColor];
    self.detailView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    self.detailView.layer.borderWidth = 2;
    self.detailView.layer.cornerRadius = 5;
    
    //corner radius for cell
    // corner radius for cells
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;

    
    return cell;
}

-(BOOL) hasInternet {
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    if(internetStatus == NotReachable){
        return false;
    } else {
        return true;
    }
}

@end
