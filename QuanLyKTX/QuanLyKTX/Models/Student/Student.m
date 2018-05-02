//
//  Student.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Student.h"
#import "Define.h"

@implementation Student

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.student_id = [dictionary objectForKey:STUDENT_ID];
        self.room_id = [dictionary objectForKey:ROOM_ID];
        self.firstName = [dictionary objectForKey:FIRST_NAME];
        self.lastName = [dictionary objectForKey:LAST_NAME];
        self.birthday = [dictionary objectForKey:BIRHDAY];
        self.gender = [dictionary objectForKey:GENDER];
        self.homeTown = [dictionary objectForKey:HOME_TOWN];
        self._class = [dictionary objectForKey:CLASS];
        self.createdDate = [dictionary objectForKey:CREATED_DATE];
        self.updatedDate = [dictionary objectForKey:UPDATED_DATE];
    }
    return self;
}

@end
