//
//  AllbumsCollectionViewController.m
//  Hexagon
//
//  Created by Avi Cohen on 10/25/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "AlbumsCollectionViewController.h"
#import "Model.h"
#import "AlbumsCollectionViewCell.h"
#import "AlbumTableViewController.h"
#import "ImagesCache.h"

@interface AlbumsCollectionViewController ()

@property (strong, nonatomic) NSArray *topAlbums;

@end

@implementation AlbumsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(126, 178);
    
    self.title = self.artist;
    [self populate];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"showAlbum"]) {
         NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
         NSDictionary *album = self.topAlbums[indexPath.row];
         AlbumTableViewController *controller = (AlbumTableViewController *)[segue destinationViewController];
         controller.artist = self.artist;
         controller.album = album[@"name"];
         controller.model = self.model;
         controller.imagesCache = self.imagesCache;
     }
 }

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topAlbums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumsCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *album = self.topAlbums[indexPath.row];
    NSURL *imageURL = [self correctImageUrl:album[@"image"]];
    UIImage *cachedImage = [self.imagesCache imageForURL:imageURL width:126 height:126];
    cell.albumImageView.image = cachedImage;
//    cell.albumImageView.layer.cornerRadius = 4;
//    cell.albumImageView.layer.masksToBounds = YES;
    
    cell.name.text = album[@"name"];
    cell.playCount.text = album[@"playcount"];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

//#pragma mark UICollectionViewFlowLayoutDelegate
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //return CGSizeMake(126, 178);
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
//    return flowLayout.estimatedItemSize;
//}

#pragma mark Population

- (void)populate
{
    [self.model topAlbumsFromArtist:self.artist complete:^(NSArray *topAlbums) {
        self.topAlbums = topAlbums;
        [self.collectionView reloadData];
    }];
}

#pragma mark helpers

- (NSURL *)correctImageUrl:(NSArray *)images {
    for (NSDictionary *image in images) {
        NSString *size = image[@"size"];
        if ([size isEqualToString:@"large"]) {
            return [NSURL URLWithString:image[@"#text"]];
        }
    }
    return nil;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
