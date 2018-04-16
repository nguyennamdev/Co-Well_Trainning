//
//  SettingTableViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Define.h"


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
                                                                      [UIColor purpleColor],
                                                                      [UIColor orangeColor],
                                                                      nil]],
        [[Setting alloc]init:@"Text colors" elements:[NSArray arrayWithObjects:[UIColor blackColor],
                                                                [UIColor redColor],
                                                                [UIColor magentaColor],
                                                                [UIColor cyanColor]
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
//    cell =  arrSetting[indexPath.section].element[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return arrSetting[section].section;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
