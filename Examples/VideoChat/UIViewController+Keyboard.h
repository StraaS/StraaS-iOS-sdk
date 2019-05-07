//
//  UIViewController+Keyboard.h
//  LiveHouse
//
//  Created by Luke Jang on 12/9/14.
//  Copyright (c) 2014 LIVEhouse.in. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Keyboard)

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWillBeShown:(NSNotification*)notification;
- (void)keyboardWillBeHidden:(NSNotification*)notification;
- (void)updateLayoutWithKeyboard:(BOOL)keyboard notification:(NSNotification *)notification;

@end
