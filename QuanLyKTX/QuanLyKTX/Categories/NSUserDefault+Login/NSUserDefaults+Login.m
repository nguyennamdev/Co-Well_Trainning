//
//  NSUserDefaults+Login.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "NSUserDefaults+Login.h"
#import "Define.h"

@implementation NSUserDefaults (Login)

- (void)setUserLogin:(BOOL)isLogin{
    [self setBool:isLogin forKey:IS_LOG_IN];
    [self synchronize];
}

- (BOOL)getIsLoggedIn{
    return [self boolForKey:IS_LOG_IN];
}

@end
