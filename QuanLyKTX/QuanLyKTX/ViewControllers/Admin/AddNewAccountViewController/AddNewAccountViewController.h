//
//  AddNewAccountViewController.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
- (IBAction)createNewAccount:(UIButton *)sender;

@end
