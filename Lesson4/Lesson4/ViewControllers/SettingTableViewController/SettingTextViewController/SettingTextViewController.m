//
//  SettingTextViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/16/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "SettingTextViewController.h"
#import "Define.h"

@interface SettingTextViewController ()

@end

@implementation SettingTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup navigation
    self.navigationItem.title = self.titleNav;
    [self initBackButton];
    [self initDoneBarButtonItem];
}


// MARK: navigationbar
- (void)initBackButton{
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(backToRootView)];
    myBackButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = myBackButton;
}

- (void)initDoneBarButtonItem{
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSettingText)];
    done.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = done;
}

// MARK: Actions

- (void)backToRootView{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)doneSettingText{
    if (_contentTextField.text == NULL){
        return;
    }
    if (_row == 0){ // row 0 as intro text
        // save text by NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:_contentTextField.text forKey:INTRO_SETTING];
    }else{
        // save text by NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:_contentTextField.text forKey:CONTACT_SETTING];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:true];
    [self.tabBarController setSelectedIndex:0];
}

@end
