//
//  GlobalCache.h
//  Populars
//
//  Created by Avi Cohen on 10/27/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesCache : NSObject

+ (ImagesCache *)globalCache;

- (UIImage *)imageForURL:(NSURL *)url width:(NSUInteger)width height:(NSUInteger)height;

@end
