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
static NSString* const LatticeServiceType = @"Lattice-PublicChannels";

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
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:LatticeServiceType session:_session];
}

// Note: May not need BOOL
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:LatticeServiceType
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else {
        [_advertiser stop];
        _advertiser = nil;
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


@end
