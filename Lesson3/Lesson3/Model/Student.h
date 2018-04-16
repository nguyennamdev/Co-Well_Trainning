//
//  Student.h
//  Lesson3
//
//  Created by Nguyen Nam on 4/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *rollNo;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSNumber *relationShip;
@property (strong, nonatomic) NSNumber *findLover;
@property (strong, nonatomic) NSNumber *year;

- (id)initWithDict:(NSDictionary *)dict;

- (void)logMySelf;

@end
