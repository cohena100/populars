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
#import "ImagesCache.h"

@interface ArtistsTableViewController ()

@property (strong, nonatomic) NSArray *topArtists;
@property (strong, nonatomic) NSArray *allTopArtists;
@property (strong, nonatomic) UISearchController* searchController;
@property Country county;
@property (strong, nonatomic) UIPopoverController *currentPopoverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *countryButtonItem;

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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

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
        controller.imagesCache = self.imagesCache;
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
    cell.tag = indexPath.row;
    cell.artistImageView.image = nil;
    [self.imagesCache imageForURL:imageURL width:64 height:48 complete:^(UIImage *cachedImage) {
        if (cell.tag == indexPath.row) {
            cell.artistImageView.image = cachedImage;
            [cell setNeedsLayout];
        }
    }];
//    cell.artistImageView.layer.cornerRadius = 4;
//    cell.artistImageView.layer.masksToBounds = YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark Population

- (void)populate
{
    [self selectCountry:CountryIL];
}

- (void)selectCountry:(Country)country {
    self.county = country;
    [self.model topArtistsFromCountry:self.county complete:^(NSArray *topArtists)
     {
         self.allTopArtists = topArtists;
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
    FlagsPopoverViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"flags"];
    contentViewController.delegate = self;
    
    // Display Mode: Change this to display the popover display style.
    contentViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    // Set the popoverPresentationController property of the content view controller
    UIPopoverPresentationController *detailPopover = contentViewController.popoverPresentationController;
    
    
    // Set delegate and add delegate methods to display in fullscreen for iPhone
    detailPopover.delegate = self;
    
    // Button to display popover from
    detailPopover.barButtonItem = sender;
    detailPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:contentViewController animated:YES completion:nil];
}

#pragma mark FlagsPopoverViewControllerDelegate

- (void) flagsPopoverViewControllerDelegateSelectedCountry:(Country)country
{
    [self selectCountry:country];
    NSString *countryImageName =  [self imageNameFromCountry:country];
    self.countryButtonItem.image = [UIImage imageNamed:countryImageName];
}

#pragma mark helpers

- (NSString *)imageNameFromCountry:(Country) country {
    switch (country) {
        case CountryIL:
            return @"il";
            break;
        case CountryUS:
            return @"us";
            break;
        case CountryGB:
            return @"gb";
            break;
        case CountryCA:
            return @"ca";
            break;
        case CountryFR:
            return @"fr";
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSArray *searchResults = [self.allTopArtists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name contains[c] %@)", searchText]];
    self.topArtists = searchResults;
    [self.tableView reloadData];
}

#pragma mark UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    self.topArtists = self.allTopArtists;
    [self.tableView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.topArtists = self.allTopArtists;
    [self.tableView reloadData];
}

@end
