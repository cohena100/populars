//
//  Response.m
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import "Response.h"

@implementation Response

+ (instancetype)response {
    return [[[self class] alloc] initWithCode:200 body:@{} error:nil];
}


- (instancetype)initWithCode:(NSInteger)code body:(NSDictionary *)body error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.code = code;
        self.body = body;
        self.error = error;
    }
    return self;
}

- (BOOL)ok
{
    return self.code == 200;
}

- (NSString *)description
{
    return [@[@"Response, code: ", @(self.code), @" body: ", (self.body == nil) ? @"" : self.body] componentsJoinedByString:@""];
}

@end
