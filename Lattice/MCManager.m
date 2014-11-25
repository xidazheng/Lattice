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
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:nil serviceType:LatticeServiceType];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
        
    }
    else {
        [self.advertiser stopAdvertisingPeer];
        self.advertiser = nil;
    }
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

// Create dicitonary from data recieved and peerID of sender. Send notification to chat viewController to display new string
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
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Browser %@ did not start browsing with error: %@", self.peerID.displayName, error.localizedDescription);
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Browser %@ found %@", self.peerID.displayName, peerID.displayName);
    NSLog(@"Browser %@ invites %@ to connect", self.peerID.displayName, peerID.displayName);
    BOOL shouldInvite = self.peerID.hash < peerID.hash;
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
