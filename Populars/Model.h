//
//  Model.h
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class Server;
@class Response;

@interface Model : NSObject

+ (instancetype)modelWithServer:(Server *)server;

- (void)topArtistsFromCountry:(Country)country complete:(void (^)(NSArray *topArtists))complete;
- (void)topAlbumsFromArtist:(NSString *)artist complete:(void (^)(NSArray *topAlbums))complete;

@end
