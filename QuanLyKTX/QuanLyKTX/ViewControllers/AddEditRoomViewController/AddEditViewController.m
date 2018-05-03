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

    self.view.backgroundColor = [UIColor colorWithRed:62/255.0 green:81/255.0 blue:81/255.0 alpha:1];
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
}

// MARK: Function load data to edit
- (void)loadInfoToEdit{
    NSString *query = [NSString stringWithFormat:@"Select roomName, maxQuantity, currentQuantity, updatedDate from tblRoom where room_id = %ld", _roomIdToEdit];
    // load the relevant data
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    self.roomNameTextField.text = [arrResult.firstObject objectAtIndex:0];
    self.maxQuantityTextField.text = [arrResult.firstObject objectAtIndex:1];
    self.currentQuantityLabel.text = [arrResult.firstObject objectAtIndex:2];
    self.currentQuantitySlider.maximumValue = [self.maxQuantityTextField.text floatValue];
    self.currentQuantitySlider.value = [[arrResult.firstObject objectAtIndex:2] integerValue];
    NSLog(@"%@", [arrResult.firstObject objectAtIndex:3]);
}

// MARK: Actions
- (IBAction)completeAddEditRoom:(UIBarButtonItem *)sender {
    if ([_roomNameTextField.text isEqualToString:@""] || [_maxQuantityTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Error" andMessage:@"You must enter data"];
    }else{
        NSString *query;
        if (self.roomIdToEdit == -1){
            NSDate *createdDate = [NSDate date];
            NSDate *updatedDate = [NSDate date];
            query = [NSString stringWithFormat:@"INSERT INTO tblRoom (roomName, maxQuantity, currentQuantity, createdDate, updatedDate) VALUES ('%@', %d, %d, '%@', '%@')", _roomNameTextField.text, [_maxQuantityTextField.text intValue] , (int)_currentQuantitySlider.value, createdDate, updatedDate];
        }else{
            query = [NSString stringWithFormat:@"UPDATE tblRoom set roomName = '%@', maxQuantity = %d, currentQuantity = %d, updatedDate = '%@'", _roomNameTextField.text, [_maxQuantityTextField.text intValue], (int)_currentQuantitySlider.value, [NSDate date]];
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_maxQuantityTextField]){
        _currentQuantitySlider.maximumValue = [_maxQuantityTextField.text floatValue];
    }
}
@end
