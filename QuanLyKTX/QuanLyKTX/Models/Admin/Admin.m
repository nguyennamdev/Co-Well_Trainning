//
//  Admin.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Admin.h"
#import "Define.h"

@implementation Admin

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.admin_id = [dictionary objectForKey:ADMIN_ID];
        self.userName = [dictionary objectForKey:USER_NAME];
        self.password = [dictionary objectForKey:PASSWORD];
        self.firstName = [dictionary objectForKey:FIRST_NAME];
        self.lastName = [dictionary objectForKey:LAST_NAME];
        self.createdDate = [dictionary objectForKey:CREATED_DATE];
        self.updatedDate = [dictionary objectForKey:UPDATED_DATE];
    }
    return self;
}

@end
