//
//  LoginViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "LoginViewController.h"
#import "DBManager.h"
#import "DBManager+Tables.h"
#import "Admin.h"
#import "Define.h"
#import "UIViewController+Alert.h"
#import "NSUserDefaults+Login.h"
#import "UITextField+LeftView.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) Admin *admin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftViewUserNameTextField];
    [self setupLeftViewPasswordTextField];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
}

// MARK: Setup left view for textFields
- (void)setupLeftViewUserNameTextField{
    UIImage *image = [UIImage imageNamed:@"user"];
    [self.userNameTextField setImageForLeftView:image leftViewFrame:CGRectMake(0, 0, 31, 26) andImageFrame:CGRectMake(0, 5, 26, 26)];
    
}

- (void)setupLeftViewPasswordTextField{
    UIImage *image = [UIImage imageNamed:@"padlock"];
    [self.passwordTextField setImageForLeftView:image leftViewFrame:CGRectMake(0, 0, 31, 26) andImageFrame:CGRectMake(0, 5, 26, 26)];
}

// MARK: Actions
- (IBAction)loginUser:(UIButton *)sender{
    if ([_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Login" andMessage:@"You didn't enter data"];
    }else{
        // query login
        NSString *query = [NSString stringWithFormat:@"select * from tblAdmin where userName = '%@' and password = '%@'", _userNameTextField.text, _passwordTextField.text];
        NSArray *result = [self.dbManager loadDataFromDatabase:query];
        if (result.count > 0){
            // get user id
            NSInteger userId = [[result.firstObject objectAtIndex:0] integerValue];
            // save user id 
            [[NSUserDefaults standardUserDefaults] setUserId:userId];
            // save user is logged in
            [[NSUserDefaults standardUserDefaults] setUserLogin:true];
            // dismiss login view controller
            [self dismissViewControllerAnimated:true completion:nil];
        }else{
            [self presentAlertControllerWithCancelAction:@"Login error" andMessage:@"Your user name or password is wrong"];
        }
    }
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



@end
