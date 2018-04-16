//
//  Setting.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSArray *element;

- (instancetype)init:(NSString *)section elements:(NSArray *)element;

@end
