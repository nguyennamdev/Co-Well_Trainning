//
//  NSUserDefaults+Login.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Login)

- (void)setUserLogin:(BOOL)isLogin;
- (BOOL)getIsLoggedIn;

@end
