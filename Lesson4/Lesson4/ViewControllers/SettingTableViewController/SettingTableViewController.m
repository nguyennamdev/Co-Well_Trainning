//
//  SettingTableViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Define.h"
#import "Setting.h"
#import "NSUserDefaults+Color.h"
#import "SettingTextViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Setting";
    [self.navigationController.navigationBar setBarTintColor:DEFAULT_COLOR_BLUE];
    [self initArraySetting];
    
}

// MARK: init array setting
- (void)initArraySetting{
    arrSetting = [NSMutableArray arrayWithObjects:
        [[Setting alloc]init:@"Background colors" elements:[NSArray arrayWithObjects:[UIColor blueColor],
                                                                      [UIColor greenColor],
                                                                      [UIColor grayColor],
                                                                      [UIColor whiteColor],
                                                                      [UIColor purpleColor],
                                                                      [UIColor orangeColor],
                                                                      nil]],
        [[Setting alloc]init:@"Text" elements:[NSArray arrayWithObjects:@"Giới thiệu",
                                               @"Liên hệ"
                                               , nil]],
        nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrSetting.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSetting[section].element.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    if (indexPath.section == 0){
         cell.backgroundColor =  arrSetting[indexPath.section].element[indexPath.row];
    }else if (indexPath.section == 1){
        cell.textLabel.text = arrSetting[indexPath.section].element[indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return arrSetting[section].section;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        UIColor *colorSelected = arrSetting[indexPath.section].element[indexPath.row];
        // save colorSelected by NSUserDefaults
        [[NSUserDefaults standardUserDefaults]setColorForKey:COLOR_SETTING color:colorSelected];
        // switch to homeViewController
        [self.tabBarController setSelectedIndex:0];
    }else if (indexPath.section == 1){
        SettingTextViewController *settingTextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingText"];
        // push title and index of row to settingTextVC
        settingTextViewController.titleNav = arrSetting[indexPath.section].element[indexPath.row];
        settingTextViewController.row = indexPath.row;
        [self.navigationController pushViewController:settingTextViewController animated:false];
    }
}



@end
