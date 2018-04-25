//
//  AddPersonViewController.m
//  Lesson7
//
//  Created by Nguyen Nam on 4/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddPersonViewController.h"
#import "DBManager.h"

@interface AddPersonViewController ()

@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.ageTextField.delegate = self;
    

    
    // init dbmanager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"mydatabase.sqlite"];
    
    if (self.pIdToEdit != -1){
        [self loadInfoToEdit];
    }
    
}

// MARK: Functions
- (void)loadInfoToEdit{
    // query
    NSString *query = [NSString stringWithFormat:@"select * from Person where id = %d", self.pIdToEdit];
    
    // load the relevant data
    NSArray *result = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.firstNameTextField.text = [result[0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"firstName"]];
     self.lastNameTextField.text = [result[0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lastName"]];
     self.ageTextField.text = [result[0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"age"]];
}

// MARK: Actions
- (IBAction)saveNewPerson:(UIBarButtonItem *)sender {
    // Prepare the query string.
    NSString *query;
    if (self.pIdToEdit == -1){
         query = [NSString stringWithFormat:@"Insert into Person values (null, '%@', '%@', %d);", self.firstNameTextField.text, self.lastNameTextField.text, [self.ageTextField.text intValue]];
    }else{
        query = [NSString stringWithFormat:@"Update Person set firstName = '%@', lastName = '%@', age = '%d' where id = %d", self.firstNameTextField.text, self.lastNameTextField.text, [self.ageTextField.text intValue], self.pIdToEdit];
    }
    NSLog(@"%@", query);
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRow != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRow);
        
        // Inform the delegate that the editing was finished.
        [self.delegate addedNewPerson];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }

}

// MARK: TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
