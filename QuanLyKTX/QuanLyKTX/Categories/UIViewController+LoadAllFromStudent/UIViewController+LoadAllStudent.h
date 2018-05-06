//
//  UIViewController+LoadAllStudent.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/6/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "DBManager.h"

@interface UIViewController (LoadAllStudent)

- (NSArray<Student *> *)loadAllStudent:(DBManager *)dbManager byArrayResult:(NSArray *)arrResult;;

@end
