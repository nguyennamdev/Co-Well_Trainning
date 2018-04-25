//
//  Student.h
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic) NSInteger studentId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic) NSInteger age;
@property (nonatomic, strong) NSString *gender;


@end
