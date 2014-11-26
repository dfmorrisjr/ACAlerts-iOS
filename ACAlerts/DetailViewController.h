//
//  DetailViewController.h
//  ACAlerts
//
//  Created by Tammy Morris on 11/25/14.
//  Copyright (c) 2014 Global Solutions Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

