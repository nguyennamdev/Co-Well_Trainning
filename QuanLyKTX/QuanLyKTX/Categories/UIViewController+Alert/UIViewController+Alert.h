//
//  UIViewController+Alert.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)presentAlertControllerWithCancelAction:(NSString *)title andMessage:(NSString *)message;

@end
