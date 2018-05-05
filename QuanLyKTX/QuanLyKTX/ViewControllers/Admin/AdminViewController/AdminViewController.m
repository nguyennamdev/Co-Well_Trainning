//
//  AdminViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AdminViewController.h"
#import "NSUserDefaults+Login.h"
#import "DBManager.h"
#import "LoginViewController.h"
#import "AddNewAccountViewController.h"
#import "EditPasswordViewController.h"

@interface AdminViewController ()
@property (strong, nonatomic) DBManager *dbManager;
@property (nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *userName;
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    _dbManager = [[DBManager alloc]initWithDatabaseFileName:@"quanly.sqlite"];
    
    // custom leftBarButtonItem
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(userLogout:)];
    [self.navigationItem setLeftBarButtonItem:logoutButtonItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadInfoUser];
}

- (void)loadInfoUser{
    self.userId = [[NSUserDefaults standardUserDefaults] getUserId] ;
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM tblAdmin where id = %ld",self.userId];
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    self.userNameLabel.text = [arrResult.firstObject objectAtIndex:1];
    self.firstNameTextField.text = [arrResult.firstObject objectAtIndex:3];
    self.lastNameTextField.text = [arrResult.firstObject objectAtIndex:4];
    // set value for userName property
    self.userName = [arrResult.firstObject objectAtIndex:1];
}

- (void)userLogout:(UIBarButtonItem *)sender {
    [[NSUserDefaults standardUserDefaults] setUserLogin:false];
     [self performSelector:@selector(showLogginViewController) withObject:nil afterDelay:0.01];
}
- (IBAction)editInfoUser:(UIBarButtonItem *)sender {
    NSString *firstName = _firstNameTextField.text;
    NSString *lastName = _lastNameTextField.text;
    NSString *query = [NSString stringWithFormat:@"Update tblAdmin set firstName = '%@', lastName = '%@', updatedDate = '%@' where id = %ld", firstName, lastName, [NSDate date], self.userId];
    [self.dbManager executeQuery:query];
}

- (IBAction)createNewAccount:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AdminStoryboard" bundle:nil];
    AddNewAccountViewController *addNewAccountViewController = [sb instantiateViewControllerWithIdentifier:@"addNewAccount"];
    [self.navigationController pushViewController:addNewAccountViewController animated:true];
}

- (IBAction)changePassword:(UIButton *)sender {
    EditPasswordViewController *adminEditPasswordViewController = [[EditPasswordViewController alloc]init];
    adminEditPasswordViewController.userName = self.userName;
    [self.navigationController pushViewController:adminEditPasswordViewController animated:true];
}



// MARK: Function show login view controller
- (void)showLogginViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:loginViewController animated:true completion:nil];
}

@end
