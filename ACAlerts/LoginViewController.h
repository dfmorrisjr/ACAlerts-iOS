//
//  LoginViewController.h
//  ACAlerts
//
//  Created by Tammy Morris on 12/5/14.
//  Copyright (c) 2014 Global Solutions Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)LoginUser:(id)sender;

@end
