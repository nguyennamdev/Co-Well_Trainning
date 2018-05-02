//
//  Student.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSNumber *student_id;
@property (strong, nonatomic) NSNumber *room_id;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *homeTown;
@property (strong, nonatomic) NSString *_class;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *updatedDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
