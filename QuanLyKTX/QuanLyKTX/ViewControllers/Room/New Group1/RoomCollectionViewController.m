//
//  RoomCollectionViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "RoomCollectionViewController.h"
#import "RoomCollectionViewCell.h"
#import "Room.h"
#import "DBManager.h"
#import "Define.h"
#import "AddEditViewController.h"
#import "DBManager+Tables.h"
#import "RoomActionDelegate.h"

@interface RoomCollectionViewController ()<RoomActionDelegate>

@property (strong, nonatomic) NSMutableArray<Room *> *arrRoom;
@property (strong, nonatomic) DBManager *dbManager;


@end

@implementation RoomCollectionViewController

static NSString * const reuseIdentifier = @"roomCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init dbManager
    _dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"RoomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView setBackgroundColor:[UIColor colorWithRed:62/255.0 green:81/255.0 blue:81/255.0 alpha:1]];
    
    //    [self.dbManager showTables];
}

- (void)viewWillAppear:(BOOL)animated{
    _roomIdToEdit = -1;
    [self fetchRoomInDatabase];
}

// MARK: Fetch room in database
- (void)fetchRoomInDatabase{
    NSString *query = @"SELECT * FROM tblRoom";
    NSArray *arrayResult = [_dbManager loadDataFromDatabase:query];
    // init arrRoom
    _arrRoom = [[NSMutableArray alloc]init];
    
    NSInteger indexOfRoomId = [self.dbManager.arrColumnsName indexOfObject:ROOM_ID];
    NSInteger indexOfIdManager = [self.dbManager.arrColumnsName indexOfObject:ROOM_ID_MANAGER];
    NSInteger indexOfRoomName = [self.dbManager.arrColumnsName indexOfObject:ROOM_NAME];
    NSInteger indexOfMaxQuantity = [self.dbManager.arrColumnsName indexOfObject:ROOM_MAX_QUANTITY];
    NSInteger indexOfCurrentQuantity = [self.dbManager.arrColumnsName indexOfObject:ROOM_CURRENT_QUANTITY];
    NSInteger indexOfCreatedDate = [self.dbManager.arrColumnsName indexOfObject:CREATED_DATE];
    NSInteger indexOfUpdatedDate = [self.dbManager.arrColumnsName indexOfObject:UPDATED_DATE];
    // loop to get arrRoom
    for (int i = 0; i < arrayResult.count; i++) {
        Room *room = Room.new;
        room.roomId = [arrayResult[i] objectAtIndex:indexOfRoomId];
        room.managerId = [NSNumber numberWithInteger:[[arrayResult[i] objectAtIndex:indexOfIdManager] integerValue]];
        room.roomName = [arrayResult[i] objectAtIndex:indexOfRoomName];
        room.maxQuantity = [arrayResult[i] objectAtIndex:indexOfMaxQuantity];
        room.currentQuantity = [arrayResult[i] objectAtIndex:indexOfCurrentQuantity];
        room.createdDate = [arrayResult[i] objectAtIndex:indexOfCreatedDate];
        room.updatedDate = [arrayResult[i] objectAtIndex:indexOfUpdatedDate];
        [_arrRoom addObject:room];
    }
    [self.collectionView reloadData];
}

// MARK: Actions

- (IBAction)addEditRoom:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

// MARK: Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addEditSegue"]){
        AddEditViewController *addEditViewController;
        addEditViewController = [segue destinationViewController];
        addEditViewController.roomIdToEdit = self.roomIdToEdit;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrRoom.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Room *room = _arrRoom[indexPath.row];
    if (room.currentQuantity == room.maxQuantity){
        cell.roomImageView.image = [UIImage imageNamed:@"door"];
    }else{
        cell.roomImageView.image = [UIImage imageNamed:@"door-open"];
    }
    cell.roomNameLabel.text = room.roomName;
    cell.maxQuantityLabel.text = [NSString stringWithFormat:@"%@", room.maxQuantity];
    cell.currentQuantityLabel.text =  [NSString stringWithFormat:@"%@", room.currentQuantity];
    cell.roomIdToDelete = [room.roomId integerValue];
    cell.roomDelegate = self;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.roomIdToEdit = [self.arrRoom[indexPath.row].roomId integerValue];
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

// MARK: Implement RoomActionDelegate

- (void)deleteRoomById:(NSInteger)roomId{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Delete room" message:@"Do you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM tblRoom WHERE room_id = %ld", roomId];
        [self.dbManager executeQuery:query];
        [self fetchRoomInDatabase];
    }];
    [alertVC addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:true completion:nil];
}

@end
