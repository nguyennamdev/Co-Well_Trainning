//
//  AddPersonViewController.h
//  Lesson7
//
//  Created by Nguyen Nam on 4/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "AddNewDelegate.h"

@interface AddPersonViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) id<AddNewDelegate> delegate;
@property (nonatomic) int pIdToEdit;

@end
