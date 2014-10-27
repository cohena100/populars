//
//  GlobalCache.m
//  Populars
//
//  Created by Avi Cohen on 10/27/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "ImagesCache.h"

@interface ImagesCache ()

@property (strong, nonatomic) NSCache *images;

@end

@implementation ImagesCache

+ (ImagesCache *)globalCache {
    ImagesCache *cache = [ImagesCache new];
    cache.images = [NSCache new];
    return cache;
}


- (UIImage *)imageForURL:(NSURL *)url width:(NSUInteger)width height:(NSUInteger)height {
    UIImage *cachedImage = [self.images objectForKey:[url absoluteString]];
    if (!cachedImage) {
        UIImage *serverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        cachedImage = [self imageWithImage:serverImage scaledToSize:CGSizeMake(width, height)];
        [self.images setObject:cachedImage forKey:[url absoluteString]];
    }
    return cachedImage;
}

#pragma mark helpers

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
