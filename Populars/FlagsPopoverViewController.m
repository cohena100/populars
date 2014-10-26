//
//  FlagsPopoverViewController.m
//  Populars
//
//  Created by Avi Cohen on 10/26/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "FlagsPopoverViewController.h"

@interface FlagsPopoverViewController ()

@end

@implementation FlagsPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tappedIL:(id)sender {
    [self tappedCountry:CountryIL];
}
- (IBAction)tappedUS:(id)sender {
    [self tappedCountry:CountryUS];
}
- (IBAction)tappedGB:(id)sender {
    [self tappedCountry:CountryGB];
}
- (IBAction)tappedCA:(id)sender {
    [self tappedCountry:CountryCA];
}
- (IBAction)tappedFR:(id)sender {
    [self tappedCountry:CountryFR];
}

- (void)tappedCountry:(Country) country {
    if ([self.delegate respondsToSelector:@selector(flagsPopoverViewControllerDelegateSelectedCountry:)]) {
        [self.delegate flagsPopoverViewControllerDelegateSelectedCountry:country];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
