/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGViewController.h"
#import "AGNotificationCell.h"

static NSString * const AGNotificationCellIdentifier = @"AGNotificationCell";

@implementation AGViewController

NSMutableArray* _messages;

BOOL isRegistered;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _messages = [[NSMutableArray alloc] init];
    
    // register to be notified when state changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registered) name:@"success_registered" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorRegistration) name:@"error_register" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:@"message_received" object:nil];
}

- (void)registered {
    NSLog(@"registered");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* msg = [defaults objectForKey:@"message_received"];
    [defaults removeObjectForKey:@"message_received"];
    [defaults synchronize];
    
    if(msg) {
        [_messages addObject:msg];
    }
    
    isRegistered = YES;
    [self.tableView reloadData];
}

- (void)errorRegistration {
    // can't do much, inform user to verify the UPS details entered and return
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Registration Error!"
                                                      message:@"Please verify the provisionioning profile and the UPS details have been setup correctly."
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    [message show];
}

- (void)messageReceived:(NSNotification*)notification {
    NSLog(@"received");
    
    [_messages addObject:notification.object[@"aps"][@"alert"]];    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    UIView *bgView;
    
    // determine current state
    if (!isRegistered) {  // not yet registered
        UIViewController *progress = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ProgressViewController"];
        bgView = progress.view;
    } else if ([_messages count] == 0) { // registered but no notification received yet
        UIViewController *empty = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
        bgView = empty.view;
    }
 
    // set the background view if needed
    if (bgView != NULL) {
        self.tableView.backgroundView = bgView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    return 1;
}

// calculate the dynamic height of the cell based on it's contents
// Notice: on iOS 8 and later, this is no needed since it is provided by default by the system,
// if the property 'numberOfLines = 0' is set
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static AGNotificationCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:AGNotificationCellIdentifier];
    });
    
    // apply text for calculating height
    cell.message.text = _messages[indexPath.row];

    // calculate height
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // if it's the first message in the stream, let's clear the 'empty' placeholder vier
    if (self.tableView.backgroundView != NULL) {
        self.tableView.backgroundView = NULL;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    AGNotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AGNotificationCellIdentifier forIndexPath:indexPath];
    // apply text
    cell.message.text = _messages[indexPath.row];
    
    return cell;
}

@end
