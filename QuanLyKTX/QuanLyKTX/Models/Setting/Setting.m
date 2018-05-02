//
//  Setting.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Setting.h"
#import "Define.h"

@implementation Setting

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.setting_id = [dictionary objectForKey:SETTING_ID];
        self.attitude = [dictionary objectForKey:ATTITUDE];
        self.value = [dictionary objectForKey:VALUE];
    }
    return self;
}

@end
