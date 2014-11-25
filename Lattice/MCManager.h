//
//  MultipeerManger.h
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;

@end
