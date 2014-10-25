//
//  Model.m
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "Model.h"
#import "Response.h"
#import "Server.h"

@interface Model ()

@property (strong , nonatomic) Server *server;

@end

@implementation Model

+ (instancetype)modelWithServer:(Server *)server {
    Model *model = [[self class] new];
    model.server = server;
    return model;
}

- (void)topArtistsFromCountry:(Country)country complete:(void (^)(NSArray *topArtists))complete
{
    [self.server topArtistsFromCountry:country complete:^(Response *response) {
        NSArray *topArtists = nil;
        if (response.ok) {
            topArtists = response.body[@"topartists"][@"artist"];
        }
        else {
            NSLog(@"%@", response);
        }
        complete(topArtists);
    }];
}

- (void)topAlbumsFromArtist:(NSString *)artist complete:(void (^)(NSArray *topAlbums))complete {
    [self.server topAlbumsFromArtist:artist complete:^(Response *response) {
        NSArray *topAlbums = nil;
        if (response.ok) {
            topAlbums = response.body[@"topablums"][@"album"];
        }
        else {
            NSLog(@"%@", response);
        }
        complete(topAlbums);
    }];
}

#pragma mark helpers

- (NSString *)countryCodeFromCountry:(Country)country
{
    switch (country) {
        case CountryIsrael:
            return @"israel";
            break;
            
        default:
            break;
    }
    return nil;
}

@end
