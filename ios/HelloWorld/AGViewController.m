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

@implementation AGViewController

NSMutableArray* _messages;
@synthesize deviceToken;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _messages = [@[@"Registering...."] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registered) name:@"success_registered" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorRegistration) name:@"error_register" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:@"message_received" object:nil];
}

- (void)registered {
    NSLog(@"registered");
    [_messages removeObjectAtIndex:0];
    [_messages addObject:@"Sucessfully registered"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* msg = [defaults objectForKey:@"message_received"];
    [defaults removeObjectForKey:@"message_received"];
    [defaults synchronize];
    
    if(msg) {
        [_messages addObject:msg];
    }
    [self.tableView reloadData];
}

- (void)errorRegistration {
    [_messages removeObjectAtIndex:0];
    [_messages addObject:@"Error during registration"];
    [self.tableView reloadData];
}

- (void)messageReceived:(NSNotification*)notification {
    NSLog(@"received");
    [_messages addObject:notification.object[@"aps"][@"alert"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textLabel.text = [_messages objectAtIndex:indexPath.row];
    return cell;
}


@end
