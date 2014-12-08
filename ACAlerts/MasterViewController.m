//
//  MasterViewController.m
//  ACAlerts
//
//  Created by Tammy Morris on 11/25/14.
//  Copyright (c) 2014 Global Solutions Development. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <RestKit/RestKit.h>
#import "User.h"
#import "Team.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (nonatomic, strong) NSArray *teams;

@end

User *user;

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* original code removed, we will not have a add new button
     
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

     
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    */
    user = [[User alloc] init];
    
    
    /* this works
    [self testUser];
    */
    
    //[self configureRestKit];
    [self loadTeams];
    
}

- (void) testUser{
    
    /* this works declared within this function
    //User *user = [[User alloc] init];
    
    NSLog(user.username);
    NSLog(user.password);
     
     */
    
    
}

-(void)configureRestKit{
    
    // initialized AFNetworking HTTPClient
    NSURL *baseURLTeams = [NSURL URLWithString:@"http://54.84.48.247"];
    AFHTTPClient *clientTeams = [[AFHTTPClient alloc] initWithBaseURL:baseURLTeams];
    
    // initialize RestKit
    RKObjectManager *objectManagerTeams = [[RKObjectManager alloc] initWithHTTPClient:clientTeams];
    
    // setup object mappings
    RKObjectMapping *teamMapping = [RKObjectMapping mappingForClass:[Team class]];
    [teamMapping addAttributeMappingsFromArray:@[@"TeamName",@"TwilioPhoneNumber"]];
    
    // register mapping with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptorTeams =
        [RKResponseDescriptor responseDescriptorWithMapping:teamMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:@"/acalerts/public/index.php/api/v1.0/team"
                                                    keyPath:Nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];

    [objectManagerTeams addResponseDescriptor:responseDescriptorTeams];
    //[objectManagerTeams addResponseDescriptor:responseDescriptorTeams];
    [objectManagerTeams.HTTPClient setAuthorizationHeaderWithUsername:user.username password:user.password];
    
}
- (void) loadTeams{
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    
    /* Second attempt with a new RKObjectManager
    RKObjectManager *sharedManagerTeams = [RKObjectManager sharedManager];
    [sharedManagerTeams getObjectsAtPath: @"/acalerts/public/index.php/api/v1.0/team"
                              parameters:nil
                                 success:^(RKObjectRequestOperation *operationTeams, RKMappingResult *mappingResultTeams) {
                                     _teams = mappingResultTeams.array;
                                 }
                                 failure:^(RKObjectRequestOperation *operationTeams, NSError *error) {
                                     NSLog(@"What do you mean by 'there are no teams?': %@", error);
                                 }];
    
    */
    
    /*  THis works with only 1 call fails on get Teams */
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/acalerts/public/index.php/api/v1.0/team"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operationTeams, RKMappingResult *mappingResultTeams) {
                                                  _teams = mappingResultTeams.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operationTeams, NSError *error) {
                                                  NSLog(@"What do you mean by 'there are no teams?': %@", error);
                                              }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*  Can no longer insert reading from API
- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* original code
    return self.objects.count;
     */
    
    return _teams.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    /* original code replaced by tutorial
    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
     */
    
    Team *team = _teams[indexPath.row];
    cell.textLabel.text = team.TeamName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/* Original code remmed, no longer editable
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
 */

@end
