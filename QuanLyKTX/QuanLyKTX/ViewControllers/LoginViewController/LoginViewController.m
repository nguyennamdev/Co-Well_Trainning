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
#import "MenuViewController.h"
#import "MainNavigationController.h"
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
            NSLog(@"Logged in");
            [self convertArrayResultToAdmin:result];
            // set user is logged in
            [[NSUserDefaults standardUserDefaults] setUserLogin:true];
            
            // get navigation to set menu vc is root view controller
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            MainNavigationController *mainNavigation = (MainNavigationController *)rootViewController;
            // init MenuController

            MenuViewController *menuVC = [[MenuViewController alloc]init];
            mainNavigation.viewControllers = @[menuVC];
            // dismiss login view controller
            [self dismissViewControllerAnimated:true completion:nil];
        }else{
            [self presentAlertControllerWithCancelAction:@"Login error" andMessage:@"Your user name or password is wrong"];
        }
    }
}

// MARK: Functions
// Convert Array result from database to a admin object
- (void)convertArrayResultToAdmin:(NSArray *)array{
    NSInteger indexOfId = [_dbManager.arrColumnsName indexOfObject:ADMIN_ID];
    NSInteger indexOfUserName = [_dbManager.arrColumnsName indexOfObject:USER_NAME];
    NSInteger indexOfPassword = [_dbManager.arrColumnsName indexOfObject:PASSWORD];
    NSInteger indexOfFirstName = [_dbManager.arrColumnsName indexOfObject:FIRST_NAME];
    NSInteger indexOfLastName = [_dbManager.arrColumnsName indexOfObject:LAST_NAME];
    NSInteger indexOfCreatedDate = [_dbManager.arrColumnsName indexOfObject:ADMIN_CREATED_DATE];
    NSInteger indexOfUpdateDate = [_dbManager.arrColumnsName indexOfObject:ADMIN_UPDATED_DATE];
    // init admin object
    self.admin = [[Admin alloc]init];
    self.admin.admin_id = [array.firstObject objectAtIndex:indexOfId];
    self.admin.userName = [array.firstObject objectAtIndex:indexOfUserName];
    self.admin.password = [array.firstObject objectAtIndex:indexOfPassword];
    self.admin.firstName = [array.firstObject objectAtIndex:indexOfFirstName];
    self.admin.lastName = [array.firstObject objectAtIndex:indexOfLastName];
    self.admin.createdDate = [array.firstObject objectAtIndex:indexOfCreatedDate];
    self.admin.updatedDate = [array.firstObject objectAtIndex:indexOfUpdateDate];
}


@end
