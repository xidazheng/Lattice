//
//  ChannelTableViewController.m
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "ChannelViewController.h"
#import "Message.h"
#import "User.h"

@interface ChannelViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
- (IBAction)sendTapped:(id)sender;


@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.channelName = @"water";
    self.recentMessages = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.recentMessages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Message *message = self.recentMessages[indexPath.row];
    cell.textLabel.text = message.sender.username;
    cell.detailTextLabel.text = message.content;
    
    return cell;
}



- (IBAction)cancelTapped:(id)sender {

    [self.messageText setText:@""];
    [self.messageText resignFirstResponder];
}

- (IBAction)sendTapped:(id)sender {
    NSString *content = self.messageText.text;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    Message *newMessage = [[Message alloc] initWithSender:user content:content channelName:self.channelName];
    
    [self.recentMessages addObject:newMessage];
    [self.tableView reloadData];
    
    [self cancelTapped:nil];
}
@end
