//
//  MasterViewController.m
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "ArtistsTableViewController.h"
#import "Global.h"
#import "Model.h"
#import "ArtistsTableViewCell.h"
#import "AlbumsCollectionViewController.h"
#import "AlbumsCollectionViewCell.h"

@interface ArtistsTableViewController ()

@property (strong, nonatomic) NSArray *topArtists;
@property Country county;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *countriesBarButtonItem;
@property (strong, nonatomic) UIPopoverController *currentPopoverController;

@end

@implementation ArtistsTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [self populate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlbums"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *artist = self.topArtists[indexPath.row];
        AlbumsCollectionViewController *controller = (AlbumsCollectionViewController *)[segue destinationViewController];
        controller.artist = artist[@"name"];
        controller.model = self.model;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topArtists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *artist = self.topArtists[indexPath.row];
    cell.artistNameLabel.text = artist[@"name"];
    cell.artistNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    NSString *listenersFormat = NSLocalizedString(@"(%@ listeners)", @"number of listeners");
    cell.artistListenersLabel.text = [NSString localizedStringWithFormat:listenersFormat, artist[@"listeners"]];
    cell.artistListenersLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    NSURL *imageURL = [self correctImageUrl:artist[@"image"]];
    UIImage *originalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    UIImage *resizedImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(64, 48)];
    cell.artistImageView.image = resizedImage;
    cell.artistImageView.layer.cornerRadius = 4;
    cell.artistImageView.layer.masksToBounds = YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark Population

- (void)populate
{
    self.county = CountryIsrael;
    [self.model topArtistsFromCountry:self.county complete:^(NSArray *topArtists)
     {
         self.topArtists = topArtists;
         [self.tableView reloadData];
     }];
}

#pragma mark helpers

- (NSURL *)correctImageUrl:(NSArray *)images {
    for (NSDictionary *image in images) {
        NSString *size = image[@"size"];
        if ([size isEqualToString:@"medium"]) {
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

#pragma mark UIContentSizeCategoryDidChangeNotification

- (void)preferredContentSizeChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark Actions

- (IBAction)countriesTapped:(UIBarButtonItem *)sender {
    UITableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Countries"];
    self.currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.currentPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


@end
