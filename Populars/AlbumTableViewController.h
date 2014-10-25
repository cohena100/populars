//
//  AlbumTableViewController.h
//  Populars
//
//  Created by Avi Cohen on 10/25/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface AlbumTableViewController : UITableViewController

@property(strong, nonatomic) NSString *artist;
@property(strong, nonatomic) NSString *album;
@property (strong, nonatomic) Model *model;

@end
