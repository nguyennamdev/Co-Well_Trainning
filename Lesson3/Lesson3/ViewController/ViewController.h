//
//  ViewController.h
//  Lesson3
//
//  Created by Nguyen Nam on 4/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *rollNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *haveLoverLabel;
@property (weak, nonatomic) IBOutlet UISwitch *haveLoverSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *findLoverSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *yearStepper;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;

@end

