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

@interface LoginViewController ()
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) Admin *admin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftViewUserNameTextField];
    [self setupLeftViewPasswordTextField];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"quanlyktx.sqlite"];
    
}

// MARK: Setup left view for textFields
- (void)setupLeftViewUserNameTextField{
    UIImage *image = [UIImage imageNamed:@"user"];
    [self setLeftView:image for:_userNameTextField];
}

- (void)setupLeftViewPasswordTextField{
    UIImage *image = [UIImage imageNamed:@"lock"];
    [self setLeftView:image for:_passwordTextField];
}

- (void)setLeftView:(UIImage *)image for:(UITextField *)textField{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 31, 26)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 26, 26)];
    [leftView addSubview:imageView];
    imageView.center = leftView.center;
    imageView.image = image;
    [textField setLeftView:leftView];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

// MARK: Actions
- (IBAction)loginUser:(UIButton *)sender{
    if ([_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Login" andMessage:@"You didn't enter data"];
    }else{
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




@end
