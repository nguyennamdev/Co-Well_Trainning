//
//  AddEditStudentViewController.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEditStudentViewController : UIViewController
{
    UIDatePicker *datePicker;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *hometownTextField;
@property (weak, nonatomic) IBOutlet UITextField *_classTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UIPickerView *roomPickerView;
@property (nonatomic) NSInteger studentId;
- (IBAction)completeAddNewStudent:(UIBarButtonItem *)sender;

@end
