//
//  AddEditViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddEditViewController.h"
#import "UIViewController+Alert.h"
#import "DBManager.h"

@interface AddEditViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) DBManager *dbManager;
@end

@implementation AddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set delegate for textFields
    _roomNameTextField.delegate = self;
    _maxQuantityTextField.delegate = self;

    // init dbManager
    _dbManager = [[DBManager alloc]initWithDatabaseFileName:@"quanly.sqlite"];
    
    self.navigationItem.title = @"Add new room";
    // check room id to edit.
    if (_roomIdToEdit != -1){
        self.navigationItem.title = @"Edit room";
        [self loadInfoToEdit];
    }
    // custom navigation bar
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView:)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
}

// MARK: Function load data to edit
- (void)loadInfoToEdit{
    NSString *query = [NSString stringWithFormat:@"Select roomName, maxQuantity, updatedDate from tblRoom where room_id = %ld", _roomIdToEdit];
    // load the relevant data
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    self.roomNameTextField.text = [arrResult.firstObject objectAtIndex:0];
    self.maxQuantityTextField.text = [arrResult.firstObject objectAtIndex:1];
    NSLog(@"%@", [arrResult.firstObject objectAtIndex:2]);
    self.currentQuantityLabel.text = [NSString stringWithFormat:@"%ld", [self countCurrentQuantityByRoomId:_roomIdToEdit]];
    
}

- (NSInteger)countCurrentQuantityByRoomId:(NSInteger )roomId{
    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM tblStudent where room_id = %ld", roomId];
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    NSInteger countResult = [[arrResult.firstObject objectAtIndex:0] integerValue];
    return countResult;
}

// MARK: Actions
- (IBAction)backToRootView:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)completeAddEditRoom:(UIBarButtonItem *)sender {
    if ([_roomNameTextField.text isEqualToString:@""] || [_maxQuantityTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Error" andMessage:@"You must enter data"];
    }else{
        NSString *query;
        if (self.roomIdToEdit == -1){
            NSDate *createdDate = [NSDate date];
            NSDate *updatedDate = [NSDate date];
            query = [NSString stringWithFormat:@"INSERT INTO tblRoom (roomName, maxQuantity, currentQuantity, createdDate, updatedDate) VALUES ('%@', %d, %d, '%@', '%@')", _roomNameTextField.text, [_maxQuantityTextField.text intValue] , 0 , createdDate, updatedDate];
        }else{
            query = [NSString stringWithFormat:@"UPDATE tblRoom set roomName = '%@', maxQuantity = %d,updatedDate = '%@' where room_id = %ld", _roomNameTextField.text, [_maxQuantityTextField.text intValue], [NSDate date], self.roomIdToEdit];
        }
        // execute query
         [_dbManager executeQuery:query];
         NSLog(@"%@", query);
        // pop to root view
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)currentQuantitySliderValueChanged:(UISlider *)sender {
    _currentQuantityLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

// MARK: Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

// MARK: Implement UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
