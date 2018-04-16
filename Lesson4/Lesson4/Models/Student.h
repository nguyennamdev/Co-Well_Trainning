//
//  Student.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *rollNo;
@property (strong, nonatomic) NSString *name;
@property NSNumber *age;
@property (strong, nonatomic) NSNumber *gender;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
