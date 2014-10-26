//
//  FlagsPopoverViewController.h
//  Populars
//
//  Created by Avi Cohen on 10/26/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"


@protocol FlagsPopoverViewControllerDelegate <NSObject>

- (void) flagsPopoverViewControllerDelegateSelectedCountry:(Country)country;

@end


@interface FlagsPopoverViewController : UIViewController

@property (weak, nonatomic) id<FlagsPopoverViewControllerDelegate> delegate;

@end
