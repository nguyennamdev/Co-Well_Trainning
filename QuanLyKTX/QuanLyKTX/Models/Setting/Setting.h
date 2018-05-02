//
//  Setting.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (strong, nonatomic) NSNumber *setting_id;
@property (strong, nonatomic) NSString *attitude;
@property (strong, nonatomic) NSString *value;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
