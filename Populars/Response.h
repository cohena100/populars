//
//  Response.h
//  Hexagon
//
//  Created by Avi Cohen on 10/24/14.
//  Copyright (c) 2014 Avi Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ResponseCode) {
    ResponseCodeClientError = 600
};


@interface Response : NSObject

@property(nonatomic) NSInteger code;
@property(strong, nonatomic) NSDictionary *body;
@property(strong, nonatomic) NSError *error;
@property(readonly, nonatomic) BOOL ok;


+ (instancetype)response;

- (instancetype)initWithCode:(NSInteger)code body:(NSDictionary *)body error:(NSError *)error;

@end
