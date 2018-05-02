//
//  Room.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "Room.h"
#import "Define.h"

@implementation Room

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.roomId = [dictionary objectForKey:ROOM_ID];
        self.managerId = [dictionary objectForKey:ROOM_MANAGER_ID];
        self.roomName = [dictionary objectForKey:ROOM_NAME];
        self.maxQuantity = [dictionary objectForKey:ROOM_MAX_QUANTITY];
        self.currentQuantity = [dictionary objectForKey:ROOM_CURRENT_QUANTITY];
        self.createdDate = [dictionary objectForKey:CREATED_DATE];
        self.updatedDate = [dictionary objectForKey:UPDATED_DATE];
    }
    return self;
}


@end
