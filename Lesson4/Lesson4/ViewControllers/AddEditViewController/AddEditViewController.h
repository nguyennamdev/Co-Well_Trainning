//
//  AddEditViewController.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface AddEditViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imagePickerController;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *rollNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *profileNameTextField;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (nonatomic, assign) BOOL isAddNewStudent;
@property (nonatomic, strong) Student *student;
@property (weak, nonatomic) IBOutlet UILabel *profileAgeLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end
