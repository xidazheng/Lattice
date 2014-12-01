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
    
    
    self.title = self.channelName;
    
    self.recentMessages = [[NSMutableArray alloc] init];
    self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
    
    self.multipeerManager = [[MCManager alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveInvitationNotification)
                                                 name:@"MCDidReceiveInvitationNotification"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    
    [self.recentMessages removeAllObjects];
    self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
    [self.tableView reloadData];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.multipeerManager setupPeerAndSessionWithDisplayName:user.username];
    [self.multipeerManager advertiseSelf:YES];
    [self.multipeerManager setupMCBrowser];
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
    
    if (content.length > 0) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        Message *newMessage = [[Message alloc] initWithSender:user content:content channelName:self.channelName];
        NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:@[newMessage]];
        
        //send the message
        NSError *error = nil;
        [self.multipeerManager.session sendData:messageData toPeers:self.multipeerManager.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
        NSLog(@"Error %@", error.localizedDescription);
        
        [self.recentMessages insertObject:newMessage atIndex:0];
        self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
        
        NSLog(@"%@ numberOfMessagesInCurrentChannel %@", user.username, self.multipeerManager.numberOfMessagesInCurrentChannel);
        
        [self.tableView reloadData];
        
        [self cancelTapped:nil];
    }
    
}


- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
//    NSLog(@"peerDidChangeStateWithNotification %@", notification);
    if ([notification.userInfo[@"state"] integerValue] == MCSessionStateConnected && self.recentMessages > 0) {
        //send up to the most recent 30 messages if a new device connects and this device has messages
        NSData *recentMessageData = [NSKeyedArchiver archivedDataWithRootObject:[self.recentMessages subarrayWithRange:NSMakeRange(0, MIN([self.recentMessages count], 30))] ];
        NSError *error = nil;
        [self.multipeerManager.session sendData:recentMessageData toPeers:self.multipeerManager.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
        NSLog(@"did send data");
    }
    
    
    
}

- (void)peerDidReceiveDataWithNotification:(NSNotification *)notification
{
    NSLog(@"peerDidReceiveDataWithNotification %@", notification);
    //parse the notification for the data and the displayName
    NSLog(@"extract data from notification");
    NSData *messageData = notification.userInfo[@"data"];
    NSLog(@"unarchive object");
    NSArray *messages = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
    
    if ([messages count] > 0 && [((Message *) messages[0]).channelName isEqualToString:self.channelName]) {
        if ([messages count] == 1)
        {
            NSLog(@"add one message to recentMessages");
            [self.recentMessages insertObject:messages[0] atIndex:0];
            self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
            NSLog(@"numberOfMessagesInCurrentChannel %@", self.multipeerManager.numberOfMessagesInCurrentChannel);
        }
        else{
            NSLog(@"add recent messages to an empty array");
            self.recentMessages = [NSMutableArray arrayWithArray:messages];
            self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
            NSLog(@"numberOfMessagesInCurrentChannel %@", self.multipeerManager.numberOfMessagesInCurrentChannel);

        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }
    
    
    
}

- (void)didReceiveInvitationNotification
{
    NSLog(@"didReceiveInvitation");
    [self.recentMessages removeAllObjects];
    self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.recentMessages count]] stringValue];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSLog(@"%@ numberOfMessagesInCurrentChannel %@", user.username, self.multipeerManager.numberOfMessagesInCurrentChannel);

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}


@end
