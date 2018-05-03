//
//  Room.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (strong, nonatomic, nonnull) NSNumber *  roomId;
@property (strong, nonatomic, nullable) NSNumber *managerId;
@property (strong, nonatomic, nonnull) NSString *roomName;
@property (strong, nonatomic, nonnull) NSNumber *maxQuantity;
@property (strong, nonatomic, nonnull) NSNumber *currentQuantity;
@property (strong, nonatomic, nonnull) NSDate *createdDate;
@property (strong, nonatomic, nonnull) NSDate *updatedDate;

- (instancetype _Nonnull )initWithDictionary:(NSDictionary *_Nonnull)dictionary;

@end
