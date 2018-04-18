//
//  SettingTextViewController.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/16/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (nonatomic, assign) NSString *titleNav;
@property (nonatomic, assign) NSInteger row;

@end
