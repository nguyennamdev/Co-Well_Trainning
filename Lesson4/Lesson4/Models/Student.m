//
//  Student.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Student.h"
#import "Define.h"

@implementation Student

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self.rollNo = [dict objectForKey:ROLL_NO];
    self.name = [dict objectForKey:NAME];
    self.age = [dict objectForKey:AGE];
    self.gender = [dict objectForKey:GENDER];
    self.phoneNumber = [dict objectForKey:PHONE_NUMBER];
    return self;
}

@end
