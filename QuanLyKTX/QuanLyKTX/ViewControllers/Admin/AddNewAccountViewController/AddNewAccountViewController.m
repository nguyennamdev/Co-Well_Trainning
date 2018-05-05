//
//  AddNewAccountViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddNewAccountViewController.h"
#import "DBManager.h"
#import "UIViewController+Alert.h"
#import "UITextField+PlaceHolder.h"

@interface AddNewAccountViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) DBManager *dbManager;

@end

@implementation AddNewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"quanly.sqlite"];
    // custom navigation bar
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.title = @"Add new account";
    
    // set delegate for textFields
    _firstNameTextField.delegate = self;
    _lastNameTextField.delegate = self;
    _userNameTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmPasswordTextField.delegate = self;
    
}


- (IBAction)createNewAccount:(UIButton *)sender {
    if ([_firstNameTextField.text isEqualToString:@""] || [_lastNameTextField.text isEqualToString:@""] || [_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""] || [_confirmPasswordTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Missing data" andMessage:@"You must enter enough information."];
    }else{
        if ([_passwordTextField.text length] < 8){
            _passwordTextField.tintColor = [UIColor redColor];
            _passwordTextField.text = @"";
            [_passwordTextField setColorForPlaceholder:@"Length of password must more than 8 characters" withColor:[UIColor redColor]];
        }else if (_confirmPasswordTextField.text != _passwordTextField.text){
            _confirmPasswordTextField.text = @"";
            [_confirmPasswordTextField setColorForPlaceholder:@"Your password don't match" withColor:[UIColor redColor]];
        }else{
            NSDate *createdDate = [NSDate date];
            NSDate *updatedDate = [NSDate date];
            NSString *query = [NSString stringWithFormat:@"INSERT INTO tblAdmin values (null, '%@', '%@', '%@', '%@', '%@', '%@')", _userNameTextField.text, _passwordTextField.text, _firstNameTextField.text, _lastNameTextField.text, createdDate, updatedDate];
            [self.dbManager executeQuery:query];
            if (self.dbManager.affectedRow != 0){
                NSLog(@"Inserted");
                [self.navigationController popViewControllerAnimated:true];
            }
        }
    }
}

- (void)backToRootView{
    [self.navigationController popViewControllerAnimated:true];
}

// MARK: Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

// MARK: Implement UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_passwordTextField]){
        _passwordTextField.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}


@end
