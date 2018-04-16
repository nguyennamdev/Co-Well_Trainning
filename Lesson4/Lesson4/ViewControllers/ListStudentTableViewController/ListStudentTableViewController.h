//
//  SecondViewController.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "AddEditViewController.h"

@interface ListStudentTableViewController : UITableViewController{
    NSMutableArray<Student *> *students;
}
@property (nonatomic, assign) AddEditViewController *aeViewController;

@end

