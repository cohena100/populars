//
//  MasterViewController.h
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class Model;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) Model *model;

@end

