//
//  RestApiManager.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "RestApiManager.h"

@implementation RestApiManager

+ (RestApiManager *)shareInstance{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc]init];
    });
    return sharedObject;
}

- (void)sendRequestToAPIURLString:(NSString *)urlString withMethod:(NSString *)method andParams:(NSDictionary * _Nullable) paramDict completeHandler:(void (^)(NSData *))completeHandler{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    // set method and parameters
    [urlRequest setValue:@"Application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:method];
    NSError *err;
    if (paramDict != nil){
        NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingSortedKeys error:&err];
        if (err != nil){
            NSLog(@"%@", err);
            return;
        }
        [urlRequest setHTTPBody:data];
    }
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completeHandler(data);
    }];
    [task resume];
}

@end
