//
//  AlbumsCollectionViewCell.h
//  Hexagon
//
//  Created by Avi Cohen on 10/25/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *playCount;

@end
