//
//  CustomTabbarViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "CustomTabbarViewController.h"
#import "NSUserDefaults+Login.h"
#import "LoginViewController.h"

@interface CustomTabbarViewController ()

@end

@implementation CustomTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //53,92,125
    self.tabBar.tintColor = [UIColor colorWithRed:53/255.0 green:92/255.0 blue:125/255.0 alpha:1];
    
    if ([[NSUserDefaults standardUserDefaults] getIsLoggedIn] == false){
         [self performSelector:@selector(showLogginViewController) withObject:nil afterDelay:0.01];
    }
//    self.viewControllers = @[];
    
}

// MARK: Function show login view controller
- (void)showLogginViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:loginViewController animated:true completion:nil];
}


@end
