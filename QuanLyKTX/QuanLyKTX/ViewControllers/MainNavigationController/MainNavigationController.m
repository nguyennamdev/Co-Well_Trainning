//
//  MainNavigationController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "MainNavigationController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "NSUserDefaults+Login.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // check user logged in by NSUserDefaults
    if ([[NSUserDefaults standardUserDefaults] getIsLoggedIn]){
        MenuViewController *menuVC = [[MenuViewController alloc]init];
        self.viewControllers = @[menuVC];
    }else{
        [self performSelector:@selector(showLogginViewController) withObject:nil afterDelay:0.01];
    }
}



// MARK: Function show login view controller
- (void)showLogginViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:loginViewController animated:true completion:nil];
}


@end
