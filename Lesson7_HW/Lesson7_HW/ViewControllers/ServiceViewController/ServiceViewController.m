//
//  ServiceViewController.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ServiceViewController.h"
#import "RestApiManager.h"
#import "Define.h"

@interface ServiceViewController ()
@property (strong, nonatomic) RestApiManager *restApiManager;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restApiManager = [RestApiManager shareInstance];
    
    NSString *urlString = @"https://wheel-ship.herokuapp.com/prices";
    [self.restApiManager sendRequestToAPIURLString:urlString withMethod:@"GET" andParams:nil completeHandler:^(NSData *data) {
        NSError *err;
        NSString *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"Result \n %@", result);
    }];
}


// MARK: Actions
- (IBAction)addNewUser:(UIButton *)sender {
    // get data
    NSString *userId = _idTextField.text;
    NSString *name = _nameTextField.text;
    NSString *email = _emailTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *phoneNumber = _phoneNumberTextField.text;
    NSNumber *isShipper = [NSNumber numberWithBool:_isShipperSwitch.isSelected];
    
    NSString *urlString = @"https://wheel-ship.herokuapp.com/users/insert_new_user";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, USER_ID,
                          name, USER_NAME,
                          email, USER_EMAIL,
                          password, USER_PASSWORD,
                          phoneNumber, USER_PHONE,
                          isShipper, USER_IS_SHIPPER, nil];
    [self.restApiManager sendRequestToAPIURLString:urlString withMethod:@"POST" andParams:dict completeHandler:^(NSData *data) {
        NSError *err;
        NSString *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"Result POST request \n %@", result);
    }];
}
- (IBAction)editUser:(UIButton *)sender {
    // get data
    NSString *userId = _idTextField.text;
    NSString *name = _nameTextField.text;
    NSString *email = _emailTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *phoneNumber = _phoneNumberTextField.text;
    NSNumber *isShipper = [NSNumber numberWithBool:_isShipperSwitch.isSelected];
    
    NSString *urlString = @"https://wheel-ship.herokuapp.com/users/update_a_user";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, USER_ID,
                          name, USER_NAME,
                          email, USER_EMAIL,
                          password, USER_PASSWORD,
                          phoneNumber, USER_PHONE,
                          isShipper, USER_IS_SHIPPER, nil];
    [self.restApiManager sendRequestToAPIURLString:urlString withMethod:@"PUT" andParams:dict completeHandler:^(NSData *data) {
        NSError *err;
        NSString *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"Result PUT request \n %@", result);
    }];
    
}

@end
