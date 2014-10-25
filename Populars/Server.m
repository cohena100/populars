//
//  Server.m
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "Server.h"
#import "Response.h"

@interface Server ()

@property (strong, nonatomic) NSArray *baseQueryItems;

@end

@implementation Server

#pragma mark - Init -

- (id)init {
    self = [super init];
    if (self) {
        self.baseQueryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:@"9c0cbfb76c4b7e2b3e4e559d8d0ff13c"],
                                [NSURLQueryItem queryItemWithName:@"format" value:@"json"]];
    }
    return self;
}


- (void)topArtistsFromCountry:(Country)country complete:(void (^)(Response *response))complete {
    NSString *countryString = [self countryStringFromCountry:country];
    NSArray *additionalQueryItems = @[[NSURLQueryItem queryItemWithName:@"country" value:countryString]];
    [self get:@"geo.getTopArtists" additionalQuery:additionalQueryItems complete:complete];
}

- (void)topAlbumsFromArtist:(NSString *)artist complete:(void (^)(Response *response))complete {
    NSArray *additionalQueryItems = @[[NSURLQueryItem queryItemWithName:@"artist" value:artist]];
    [self get:@"artist.getTopAlbums" additionalQuery:additionalQueryItems complete:complete];
}

- (void)get:(NSString *)method additionalQuery:(NSArray *)additionalQuery complete:(void(^)(Response *response))complete {
    NSURL *url = [self composeURLMethod:method additionalQuery:additionalQuery];
    NSURLRequest *request = [self createRequest:url method:@"GET"];
    [self executeRequest:request complete:complete];
}

- (NSURL *)composeURLMethod:(NSString *)method additionalQuery:(NSArray *)additionalQueryItems {
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://ws.audioscrobbler.com/2.0"];
    NSArray *queryItems = [[@[[NSURLQueryItem queryItemWithName:@"method" value:method]] arrayByAddingObjectsFromArray:self.baseQueryItems] arrayByAddingObjectsFromArray:additionalQueryItems];
    components.queryItems = queryItems;
    return [components URL];
}

- (NSURLRequest *)createRequest:(NSURL *)url method:(NSString *)method {
    [self logRequestUrl:url method:method];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:method];
    return request;
}

- (void)executeRequest:(NSURLRequest *)request complete:(void(^)(Response *response))complete {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *body;
        if (data) {
            body = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        }
        else {
            body = @{};
        }
        NSInteger code = ResponseCodeClientError;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse != nil) {
            code = httpResponse.statusCode;
        }
        [self logResponseCode:httpResponse.statusCode data:data];
        Response *completeResponse = [[Response alloc] initWithCode:code body:body error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(completeResponse);
        });
    }];
    [task resume];
}

#pragma mark - Logging -

- (void)logResponseCode:(NSInteger)code data:(NSData *)data {
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [@[@"response, code: ", @(code), @" body: ", body] componentsJoinedByString:@" "]);
}

- (void)logRequestUrl:(NSURL *)url method:(NSString *)method {
    NSLog(@"%@", [@[@"createRequest, url: ", url, @" method: ", method] componentsJoinedByString:@" "]);
}

#pragma mark - Others -

#pragma mark helpers

- (NSString *)countryStringFromCountry:(Country)country {
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
