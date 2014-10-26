//
//  AlbumTableViewController.m
//  Populars
//
//  Created by Avi Cohen on 10/25/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "Model.h"
#import "AlbumTableViewCell.h"

@interface AlbumTableViewController ()

@property (strong, nonatomic) NSArray *tracks;
@property (strong, nonatomic) NSArray *images;

@end

@implementation AlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65;
    
    self.title = self.album;
    [self populate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count ? self.tracks.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        AlbumTableViewCell *cell = (AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
        NSURL *imageURL = [self correctImageUrl:self.images];
        UIImage *originalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        UIImage *resizedImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(126, 126)];
        cell.albumImageView.image = resizedImage;
//        cell.albumImageView.layer.cornerRadius = 4;
//        cell.albumImageView.layer.masksToBounds = YES;
        return cell;
    }
    else {
        NSUInteger index = (NSUInteger)row - 1;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track" forIndexPath:indexPath];
        NSDictionary *track = self.tracks[index];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger duration = ((NSNumber *)track[@"duration"]).integerValue;
        comps.minute = duration / 60;
        comps.second = duration % 60;
        NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
        NSString *trackLength = [formatter stringFromDateComponents:comps];
        cell.textLabel.text = [@[@(row), @". ", self.tracks[index][@"name"], @" (", trackLength, @")"] componentsJoinedByString:@""];
        return cell;
    }
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark Population

- (void)populate
{
    [self.model tracksFromAlbum:self.album artist:self.artist complete:^(NSArray *tracks, NSArray *images) {
        self.tracks = tracks;
        self.images = images;
        [self.tableView reloadData];
    }];
}

@end
