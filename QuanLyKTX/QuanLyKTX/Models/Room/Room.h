//
//  Room.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (strong, nonatomic) NSNumber *roomId;
@property (strong, nonatomic) NSNumber *managerId;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSNumber *maxQuantity;
@property (strong, nonatomic) NSNumber *currentQuantity;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
