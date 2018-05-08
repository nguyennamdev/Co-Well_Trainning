//
//  SettingTableViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "SettingTableViewController.h"
#import "DBManager+Tables.h"
#import "DBManager.h"
#import "Setting.h"
#import "Define.h"

@interface SettingTableViewController ()
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray<Setting *> *arrSetting;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    [self.dbManager showTables];
    
    [self loadSettings];
}

- (void)loadSettings{
    NSString *query = @"SELECT * FROM tblSetting";
    NSArray *array = [self.dbManager loadDataFromDatabase:query];
    // init arrSetting
    self.arrSetting = [[NSMutableArray alloc]init];
    NSInteger indexOfId = [self.dbManager.arrColumnsName indexOfObject:SETTING_ID];
    NSInteger indexOfAttitude = [self.dbManager.arrColumnsName indexOfObject:ATTITUDE];
    NSInteger indexOfValue = [self.dbManager.arrColumnsName indexOfObject:VALUE];
    NSInteger indexOfCreatedDate = [self.dbManager.arrColumnsName indexOfObject:CREATED_DATE];
    NSInteger indexOfUpdatedDate = [self.dbManager.arrColumnsName indexOfObject:UPDATED_DATE];
    // loop to get data then add to arrSetting
    for (int i = 0; i < array.count; i++) {
        Setting *setting = Setting.new;
        setting.setting_id = [array[i] objectAtIndex:indexOfId];
        setting.attitude = [array[i] objectAtIndex:indexOfAttitude];
        setting.value = [array[i] objectAtIndex:indexOfValue];
        setting.createdDate = [array[i] objectAtIndex:indexOfCreatedDate];
        setting.updatedDate = [array[i] objectAtIndex:indexOfUpdatedDate];
        // add to arrSetting
        [self.arrSetting addObject:setting];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrSetting.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCellId" forIndexPath:indexPath];
    // set right arrow in cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.arrSetting[indexPath.row].attitude;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.text = self.arrSetting[indexPath.row].value;
    cell.detailTextLabel.textColor = [UIColor redColor];
    return cell;
}

- (void)updateSettingValue:(NSString *)newValue settingId:(NSInteger)settingId{
    NSString *query = [NSString stringWithFormat:@"Update tblSetting set value = '%@', updatedDate = '%@' where id = %ld", newValue, [NSDate date], settingId];
    [self.dbManager executeQuery:query];
    [self loadSettings];
}

- (void)showAlertControllerToEditSettingTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    // init alert controller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"enter new rule";
    }];
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![alertController.textFields.firstObject.text isEqualToString:@""]){
            // invoke update setting function to edit
            [self updateSettingValue:alertController.textFields.firstObject.text settingId:[self.arrSetting[indexPath.row].setting_id integerValue]];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:changeAction];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *attitudeString = self.arrSetting[indexPath.row].attitude;
    [self showAlertControllerToEditSettingTitle:attitudeString indexPath:indexPath];
}


@end
