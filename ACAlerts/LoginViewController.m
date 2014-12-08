//
//  LoginViewController.m
//  ACAlerts
//
//  Created by Tammy Morris on 12/5/14.
//  Copyright (c) 2014 Global Solutions Development. All rights reserved.
//

#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "Team.h"
#import "LoginResult.h"


@interface LoginViewController ()

@property (nonatomic, strong) NSArray *userlogin;

@end

User *user;
LoginResult *loginresult;


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginUser:(id)sender {
    
    //first get user supplied username and password
    
    user = [User alloc];
    loginresult = [LoginResult alloc];
    
    user.username = _usernameField.text;
    user.password = _passwordField.text;
    
    // now bang that against the API and see if it is valid
    [self configureRestKit];
    [self attemptLogin];
        
}

- (void)configureRestKit{
    
    // initialized AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://54.84.48.247"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[LoginResult class]];
    [userMapping addAttributeMappingsFromArray:@[@"rowcount"]];
    //[userMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"rowcount"];
    
    // register mapping with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/acalerts/public/index.php/api/v1.0/login"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
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
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    [objectManager addResponseDescriptor:responseDescriptorTeams];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.username password:user.password];
    
}

- (void) attemptLogin{
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/acalerts/public/index.php/api/v1.0/login"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _userlogin = mappingResult.array;
                                                  [self didItWork];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"User login failed': %@", error);
                                                  UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Boooooo" message:@"Your login attempt failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                  
                                                  [errorView show];
                                              }];
    

    
}

- (void)didItWork{
    
    LoginResult *loginresult;
    loginresult = [_userlogin objectAtIndex:0];
    
    if([loginresult.rowcount isEqualToString:(@"1")]){
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    else{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Boooooo" message:@"Your login attempt failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
