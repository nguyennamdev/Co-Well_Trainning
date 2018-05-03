//
//  RoomCollectionViewCell.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomActionDelegate.h"

@interface RoomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentQuantityLabel;
@property (weak, nonatomic) Room *room;
@property (strong, nonatomic) UILongPressGestureRecognizer *tapGesture;
@property (nonatomic) NSInteger roomIdToDelete;
@property (strong, nonatomic) id<RoomActionDelegate> roomDelegate;

@end
