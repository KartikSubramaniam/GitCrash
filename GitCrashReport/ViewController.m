//
//  ViewController.m
//  GitCrashReport
//
//  Created by Kartik Subramaniam on 25/09/16.
//  Copyright © 2016 Kartik Subramaniam. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Communicator.h"
#import "CrashReportReader.h"
#import "ReportModel.h"
#import "DetailController.h"
#import "Database.h"
#import "Reachability.h"
#import "TaskModel.h"


@interface ViewController ()
{
    NSArray *titleData;
}
@end

static NSIndexPath *rowIndex;
static NSUInteger buttonTag;
static Database *database = nil;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    database = [Database sharedInstance];
    NSPredicate *query = [NSPredicate predicateWithFormat:@" crashId !='' "];
    NSSortDescriptor *orderBy = [[NSSortDescriptor alloc]initWithKey:@"updatedTimeStamp" ascending:NO];
    
    titleData = [database fetchData:[[ReportModel alloc]init] :query :orderBy];
    if([titleData count] == 0){
        if([self hasInternet]){
            [self updateDatabase];
            NSPredicate *query = [NSPredicate predicateWithFormat:@" crashId !='' "];
            NSSortDescriptor *orderBy = [[NSSortDescriptor alloc]initWithKey:@"updatedTimeStamp" ascending:NO];
            
            titleData = [database fetchData:[[ReportModel alloc]init] :query :orderBy];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Internet" message:@"Can't connect to the server" delegate:self cancelButtonTitle:@"retry" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [self viewDidLoad];
        self.tableView.reloadData;
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
    
    return [titleData count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    ReportModel *crashModel = [[ReportModel alloc]init];
    crashModel = [titleData objectAtIndex:indexPath.row];
   
    cell.issueTitle.text = crashModel.title;
    
    //corner radius for text view
    cell.issueBody.clipsToBounds = YES;
    cell.issueBody.layer.cornerRadius = 10.0f;
    cell.issueBody.text = [crashModel.body substringToIndex:140];
   
    
    
    // corner radius for cells
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    // corner radius for tabel
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    self.tableView.layer.borderWidth = 2;
    self.tableView.layer.cornerRadius = 5;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowIndex = indexPath;
    [self performSegueWithIdentifier:@"Detail_Segue" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Detail_Segue"])
    {
        // Get reference to the destination view controller
        DetailController *detailController= [segue destinationViewController];
        ReportModel *crashModel = [[ReportModel alloc]init];
        crashModel = [titleData objectAtIndex:rowIndex.row];
        detailController.url =  [NSURL URLWithString:crashModel.commentUrl];
        detailController.title = crashModel.title;
        detailController.number = crashModel.number;
        // Pass any objects to the view controller here, like...
        
    }
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

-(void)updateDatabase{
    
    Communicator *communicator = [[Communicator alloc]init];
    CrashReportReader *reader = [[CrashReportReader alloc]init];
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/repos/crashlytics/secureudid/issues"];
    [communicator getRequest:url];
    
    NSData *data = [communicator getData];
    
    //get the json data
    NSArray *titlData = [reader parse:data];
    [database insertData:titlData];
    
    double current = [[NSDate new] timeIntervalSince1970];
    TaskModel *task = [[TaskModel alloc]init];
    task.lastUpdated = [NSString stringWithFormat:@"%f",current];
    NSArray *taskData = [[NSArray alloc]initWithObjects:task, nil];
    [database insertData:taskData];
}

@end
