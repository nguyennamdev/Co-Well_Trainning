//
//  RestApiManager.h
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestApiManager : NSObject
// make singleton pattern
+ (RestApiManager *_Nullable)shareInstance;

- (void)sendRequestToAPIURLString:(NSString *_Nonnull)urlString withMethod:(NSString *_Nonnull)method andParams:(NSDictionary * _Nullable) paramDict completeHandler:(void (^_Nullable)(NSData *_Nullable))completeHandler;

@end
