//
//  TransparentChatViewController.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "TransparentChatViewController.h"
#import "TransparentMessageTableViewCell.h"

@interface TransparentChatViewController ()
@end

@implementation TransparentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldShowPinnedMessage = NO;
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapRootView)];
    [self.view addGestureRecognizer:tapGR];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.clipsToBounds = YES;
    
    [self.tableView registerClass:[TransparentMessageTableViewCell class]
           forCellReuseIdentifier:TransparentMessengerCellIdentifier];
    
    [self setTextInputbarHidden:YES];
    [self clearCachedText];
    
    //This two lines are used to hide _UIBarBackground's seperate line since textInpubar is subclass of UIToolBar. ref: http://www.jianshu.com/p/23d9bde85f13
    UIView * backgroundView =  self.textInputbar.subviews.firstObject;
    backgroundView.subviews.firstObject.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (CGFloat)cellLeftPadding {
    return kTransparentCellLabelPaddingLeft - kTransparentCellBackgroundMaskHorizontalPadding;
}

#pragma mark - Gesture Recognizer

- (void)didTapRootView {
    [self dismissKeyboard:NO];
}

#pragma mark - Override Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        TransparentMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TransparentMessengerCellIdentifier
                                                                                     forIndexPath:indexPath];
        
        STSChatMessage *message = self.messages[indexPath.row];
        [cell setMessage:message];
        
        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        cell.transform = self.tableView.transform;
        
        return cell;
    }
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        STSChatMessage *message = self.messages[indexPath.row];
        return [TransparentMessageTableViewCell estimateCellHeightWithMessage:message
                                                                   widthToFit:tableView.bounds.size.width];
    }
    else {
        return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        STSChatMessage *message = self.messages[indexPath.row];
        return [TransparentMessageTableViewCell estimateCellHeightWithMessage:message
                                                                   widthToFit:tableView.bounds.size.width];
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        return NO;
    }
    else {
        return [super tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status {
    if (status == SLKKeyboardStatusWillShow) {
        self.textInputbarHidden = NO;
        self.tableView.hidden = YES;
    }
    else if (status == SLKKeyboardStatusWillHide) {
        [UIView performWithoutAnimation:^{
            self.textInputbarHidden = YES;
            self.tableView.hidden = NO;
        }];
    } else if (status == SLKKeyboardStatusDidHide) {
        //Force to layout to avoid strange animation. e.g. tableView would glide from the keyboard's position.
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [super didChangeKeyboardStatus:status];
    }
}

- (BOOL)shouldShowJumpToLatestButton {
    return self.keyboardStatus == SLKKeyboardStatusDidShow || [super shouldShowJumpToLatestButton];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder {
    return YES;
}

- (void)didPressRightButton:(id)sender {
    [self dismissKeyboard:NO]; 
    
    [super didPressRightButton:sender];
}

- (void)chatroomConnected:(STSChat *)chatroom {
    [super chatroomConnected:chatroom];
    NSLog(@"connected to chatroom: %@", chatroom.chatroomName);
}
- (void)chatroomDisconnected:(STSChat *)chatroom {
    NSLog(@"disconnect from chatroom: %@", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    NSLog(@"fail to connect to chatroom: %@ with error: %@", chatroom.chatroomName, error);
}

- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {
    NSLog(@"chatroom: %@ with error: %@", chatroom.chatroomName, error);
}

@end
