//
//  AddEditViewController.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxQuantityTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentQuantityLabel;
@property (nonatomic) NSInteger roomIdToEdit;

@end
