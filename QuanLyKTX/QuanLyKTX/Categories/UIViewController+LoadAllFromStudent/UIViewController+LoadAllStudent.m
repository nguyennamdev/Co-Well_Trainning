//
//  UIViewController+LoadAllStudent.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/6/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "UIViewController+LoadAllStudent.h"
#import "Define.h"

@implementation UIViewController (LoadAllStudent)

-(NSArray<Student *> *)loadAllStudent:(DBManager *)dbManager byArrayResult:(NSArray *)arrResult{
    NSMutableArray<Student *> *arrStudent = [[NSMutableArray alloc]init];
    NSInteger indexOfStudentId = [dbManager.arrColumnsName indexOfObject:STUDENT_ID];
    NSInteger indexOfRoomId = [dbManager.arrColumnsName  indexOfObject:ROOM_ID];
    NSInteger indexOfFirstName = [dbManager.arrColumnsName  indexOfObject:FIRST_NAME];
    NSInteger indexOfLastName = [dbManager.arrColumnsName  indexOfObject:LAST_NAME];
    NSInteger indexOfBirthday = [dbManager.arrColumnsName  indexOfObject:BIRHDAY];
    NSInteger indexOfGender = [dbManager.arrColumnsName  indexOfObject:GENDER];
    NSInteger indexOfHometown = [dbManager.arrColumnsName  indexOfObject:HOME_TOWN];
    NSInteger indexOfClass = [dbManager.arrColumnsName  indexOfObject:CLASS];
    NSInteger indexOfCreatedDate = [dbManager.arrColumnsName  indexOfObject:CREATED_DATE];
    NSInteger indexOfUpdatedDate = [dbManager.arrColumnsName  indexOfObject:UPDATED_DATE];
    
    for (int i = 0; i < arrResult.count; i++) {
        Student *student = Student.new;
        student.student_id = [arrResult[i] objectAtIndex:indexOfStudentId];
        student.room_id = [arrResult[i] objectAtIndex:indexOfRoomId];
        student.firstName = [arrResult[i] objectAtIndex:indexOfFirstName];
        student.lastName = [arrResult[i] objectAtIndex:indexOfLastName];
        student.birthday = [arrResult[i] objectAtIndex:indexOfBirthday];
        student.gender = [arrResult[i] objectAtIndex:indexOfGender];
        student.homeTown = [arrResult[i] objectAtIndex:indexOfHometown];
        student._class = [arrResult[i] objectAtIndex:indexOfClass];
        student.createdDate = [arrResult[i] objectAtIndex:indexOfCreatedDate];
        student.updatedDate = [arrResult[i] objectAtIndex:indexOfUpdatedDate];
        [arrStudent addObject:student];
    }
    return arrStudent;
}

@end
