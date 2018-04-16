//
//  Student.m
//  Lesson3
//
//  Created by Nguyen Nam on 4/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Student.h"
#import "Define.h"

@implementation Student

- (id)initWithDict:(NSDictionary *)dict{
    self.rollNo = [dict objectForKey:ROLL_NO];
    self.name = [dict objectForKey:NAME];
    self.age = [dict objectForKey:AGE];
    self.gender = [dict objectForKey:GENDER];
    self.email = [dict objectForKey:EMAIL];
    self.relationShip = [dict objectForKey:RELATIONSHIP];
    self.findLover = [dict objectForKey:FIND_LOVER];
    self.year = [dict objectForKey:YEAR];
    return self;
}

- (void)logMySelf{
    NSLog(@"Student information:");
    NSLog(@"rollNo: %@", self.rollNo);
    NSLog(@"name: %@", self.name);
    NSLog(@"age: %@", self.age);
    NSLog(@"gender: %@", self.gender);
    NSLog(@"email: %@", self.email);
    NSLog(@"relationship: %@", _relationShip.boolValue == YES ? @"have lover" : @"don't have lover");
    NSLog(@"find lover: %@", _findLover.boolValue == YES ? @"can find lover" : @"can't find lover");
    NSLog(@"year: %@", self.year);
}

@end
