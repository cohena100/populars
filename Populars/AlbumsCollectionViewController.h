//
//  AllbumsCollectionViewController.h
//  Hexagon
//
//  Created by Avi Cohen on 10/25/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface AlbumsCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic) NSString *artist;
@property (strong, nonatomic) Model *model;

@end
