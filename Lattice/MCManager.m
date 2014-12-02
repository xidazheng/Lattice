//
//  MultipeerManger.m
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "MCManager.h"

@interface MCManager ()

@end

@implementation MCManager

// Constants
NSString* const LatticeServiceType = @"lattice";

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
        _numberOfMessagesInCurrentChannel = [@0 stringValue];
    }
    
    return self;
}

#pragma mark Public Methods - Session, Browser and Advertising Setup
// Display name from NSUserDefaults

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:self.peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    _session.delegate = self;
}

- (void)setupMCBrowser{
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:LatticeServiceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
}

// Note: May not need BOOL
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise) {
        NSDictionary *elements = @{ @"numberOfMessagesInCurrentChannel": self.numberOfMessagesInCurrentChannel};
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:elements serviceType:LatticeServiceType];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
        
    }
    else {
        [self.advertiser stopAdvertisingPeer];
        self.advertiser = nil;
    }
}

- (void) disconnect
{
    
    [self.advertiser stopAdvertisingPeer];
    self.advertiser.delegate = nil;
    self.advertiser = nil;
    
    [self.browser stopBrowsingForPeers];
    self.browser.delegate = nil;
    self.browser = nil;
    
    [self.session disconnect];
    self.session.delegate = nil;
    self.session = nil;
}

#pragma mark Session Delegate Methods

// If state change post notification MCDidChangeStateNotification to all listeners,
// if connected adds peer to connected array, and removes you if now disconnected
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}

// Create dictonary from data recieved and peerID of sender. Send notification to chat viewController to display new string
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    // Not implemented
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    // Not implemented
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    // Not implemented
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Advertiser %@ did not start advertising with error: %@", self.peerID.displayName, error.localizedDescription);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"Advertiser %@ received an invitation from %@", self.peerID.displayName, peerID.displayName);
    invitationHandler(YES, self.session);
    NSLog(@"Advertiser %@ accepted invitation from %@", self.peerID.displayName, peerID.displayName);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveInvitationNotification"
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Browser %@ did not start browsing with error: %@", self.peerID.displayName, error.localizedDescription);
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Browser %@ found %@", self.peerID.displayName, peerID.displayName);
    NSLog(@"Info: %@", info);
    
    //the hash is an unreliable way to decide which one will invite the other, it only makes sure that one invites the other. A slightly better way to do this is to figure out which one has more items in it. I can do that using the info field, which must be set up in the advertiser.
    BOOL shouldInvite = [self.numberOfMessagesInCurrentChannel integerValue] < [info[@"numberOfMessagesInCurrentChannel"] integerValue];
    NSLog(@"%d", shouldInvite);
    
    if ([self.numberOfMessagesInCurrentChannel integerValue] == 0 && [info[@"numberOfMessagesInCurrentChannel"] integerValue] == 0){
        shouldInvite = self.peerID.hash < peerID.hash;
    }
    
    
    
    if (shouldInvite) {
        // I will invite the peer, the remote peer will NOT invite me.
        NSLog(@"Browser %@ invites %@ to connect", self.peerID.displayName, peerID.displayName);
        [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:10];
    } else {
        // I will NOT invite the peer, the remote peer will invite me.
        NSLog(@"Browser %@ does not invite %@ to connect", self.peerID.displayName, peerID.displayName);
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Browser %@ lost %@", self.peerID.displayName, peerID.displayName);
//    [self logPeers];
}

@end
