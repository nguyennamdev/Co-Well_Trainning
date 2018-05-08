//
//  EditPasswordViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "DBManager.h"
#import "UIViewController+Alert.h"
#import "UITextField+PlaceHolder.h"
#import "UITextField+LeftView.h"
#import "Define.h"

@interface EditPasswordViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) DBManager *dbManager;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    
    // set delegate for textFields
    _oldPasswordTextField.delegate = self;
    _passwordNewTextField.delegate = self;
    _confirmPasswordTextField.delegate = self;
    
    NSLog(@"%@", self.userName);
    // custom navigation bar
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView:)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    // set up left view for textFields
    [self setupLeftViewTextFields];
    
}

- (void)setupLeftViewTextFields{
    UIImage *image = [UIImage imageNamed:@"padlock"];
    CGRect leftViewFrame = CGRectMake(0, 0, 31, 26);
    CGRect imageFrame = CGRectMake(0, 0, 26, 26);
    [self.oldPasswordTextField setImageForLeftView:image leftViewFrame:leftViewFrame andImageFrame:imageFrame];
    [self.passwordNewTextField setImageForLeftView:image leftViewFrame:leftViewFrame andImageFrame:imageFrame];
    [self.confirmPasswordTextField setImageForLeftView:image leftViewFrame:leftViewFrame andImageFrame:imageFrame];
}



// MARK: Actions

- (IBAction)backToRootView:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)changePasswordAdmin:(UIButton *)sender {
    if ([_oldPasswordTextField.text isEqualToString:@""] || [_passwordNewTextField.text isEqualToString:@""] || [_confirmPasswordTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Missing data" andMessage:@"You must enter data"];
    }else{
        // check old password
        NSString *query = [NSString stringWithFormat:@"Select * from tblAdmin where userName = '%@' and password = '%@'", self.userName, _oldPasswordTextField.text];
        NSLog(@"%@", query);
        if ([self.dbManager loadDataFromDatabase:query].count > 0){
            // password is true
            // confirm new password
            if (self.confirmPasswordTextField.text != self.passwordNewTextField.text){
                // confirm password don't match
                _confirmPasswordTextField.text = @"";
                [_confirmPasswordTextField setColorForPlaceholder:@"Password don't match" withColor:[UIColor redColor]];
            }else{
                // confirm password matched
                NSDate *updatedDate = [NSDate date];
                NSString *query = [NSString stringWithFormat:@"Update tblAdmin set password = '%@', updatedDate = '%@'", _passwordNewTextField.text, updatedDate];
                [self.dbManager executeQuery:query];
                if (self.dbManager.affectedRow != 0){
                    [self presentAlertControllerWithCancelAction:@"Complete" andMessage:@"Your password changed"];
                }
            }
        }else{
            // password is false
            [self presentAlertControllerWithCancelAction:@"Wrong" andMessage:@"Your old password is wrong"];
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
