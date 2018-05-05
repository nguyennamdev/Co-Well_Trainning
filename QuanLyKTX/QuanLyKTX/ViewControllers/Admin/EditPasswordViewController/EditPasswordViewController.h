//
//  EditPasswordViewController.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (strong, nonatomic) NSString *userName;

- (IBAction)changePasswordAdmin:(UIButton *)sender;

@end
