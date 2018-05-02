//
//  BaseViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Home";
    // set up menu button on left navigation bar
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithTitle:@"menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    [self.navigationItem setLeftBarButtonItem:menuButton];
}

// MARK : Action show menu
- (void)showMenu{
    NSLog(@"show menu");
}




@end
