//
//  Setting.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Setting.h"

@implementation Setting

- (instancetype)init:(NSString *)section elements:(NSArray *)element
{
    self = [super init];
    if (self) {
        self.section = section;
        self.element = element;
    }
    return self;
}

@end
