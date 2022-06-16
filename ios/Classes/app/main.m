//
//  main.m
//  re
//
//  Created by qun on 2021/5/11.
//  Copyright © 2021 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([BEAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
