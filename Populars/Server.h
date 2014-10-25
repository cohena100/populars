//
//  Server.h
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class Response;

@interface Server : NSObject

@property (strong, nonatomic)NSString *baseUrl;

- (void)topArtistsFromCountry:(Country)country complete:(void (^)(Response *response))complete;
- (void)topAlbumsFromArtist:(NSString *)artist complete:(void (^)(Response *response))complete;

@end
