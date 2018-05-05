//
//  RoomCollectionViewCell.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "RoomCollectionViewCell.h"


@implementation RoomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 222,203,164
    self.backgroundColor = [UIColor colorWithRed:200/255.0 green:203/255.0 blue:184/255.0 alpha:0.5];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = true;
    self.layer.opacity = 0.5;
    self.userInteractionEnabled = true;
    
    [self initLongPressGesture];
    
    if (_room != nil){
        _roomImageView.image = [UIImage imageNamed:@"door"];
        _roomNameLabel.text = _room.roomName;
        _maxQuantityLabel.text = [NSString stringWithFormat:@"%@", _room.maxQuantity];
        _currentQuantityLabel.text = [NSString stringWithFormat:@"%@", _room.currentQuantity];
    }
}
// MARK: Setup longGesture
- (void)initLongPressGesture{
    _tapGesture = [[UILongPressGestureRecognizer alloc]init];
    [self addGestureRecognizer:_tapGesture];
    _tapGesture.minimumPressDuration = 1;
    [_tapGesture addTarget:self action:@selector(showDeleteAction:)];
}

- (void)showDeleteAction:(UILongPressGestureRecognizer *)sender {
    [self.roomDelegate deleteRoomById:self.roomIdToDelete];
}

@end
