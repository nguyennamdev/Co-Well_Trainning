//
//  ViewController.h
//  Lesson2
//
//  Created by Nguyen Nam on 4/10/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;

@property (weak, nonatomic) IBOutlet UITextField *numberCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

