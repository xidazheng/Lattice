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
#import "MCManager.h"

@interface ChannelViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
- (IBAction)sendTapped:(id)sender;

@property (strong, nonatomic) MCManager *multipeerManager;

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.channelName = @"water";
    self.recentMessages = [[NSMutableArray alloc] init];
    
    self.multipeerManager = [[MCManager alloc]init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.multipeerManager setupPeerAndSessionWithDisplayName:user.username];
    [self.multipeerManager advertiseSelf:YES];
    [self.multipeerManager setupMCBrowser];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
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
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    Message *newMessage = [[Message alloc] initWithSender:user content:content channelName:self.channelName];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:newMessage];
    
    
    //send the message
    NSError *error = nil;
    [self.multipeerManager.session sendData:messageData toPeers:self.multipeerManager.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
    
    
    [self.recentMessages insertObject:newMessage atIndex:0];
    [self.tableView reloadData];
    
    [self cancelTapped:nil];
}


- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    NSLog(@"peerDidChangeStateWithNotification %@", notification);
}

- (void)peerDidReceiveDataWithNotification:(NSNotification *)notification
{
    NSLog(@"peerDidReceiveDataWithNotification %@", notification);
    //parse the notification for the data and the displayName
    NSLog(@"extract data from notification");
    NSData *messageData = notification.userInfo[@"data"];
    NSLog(@"unarchive object");
    Message *message = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
    NSLog(@"add object to recentMessages");
    [self.recentMessages insertObject:message atIndex:0];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}



@end
