//
//  RoomActionDelegate.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RoomActionDelegate <NSObject>

- (void)deleteRoomById:(NSInteger)roomId;

@end
