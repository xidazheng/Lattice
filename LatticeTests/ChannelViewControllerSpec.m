//
//  LatticeTests.m
//  LatticeTests
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//


#import <Specta.h>
#import "ChannelViewController.h"
#import <Expecta.h>
#import "User.h"
#import "Message.h"
#define EXP_SHORTHAND


SpecBegin(ChannelViewController)

//unit test for the channelViewController
describe(@"ChannelViewController", ^{
    __block ChannelViewController *newChannelVC;
    __block User *elliott;
    __block User *xida;
    
    beforeEach(^{
        newChannelVC = [[ChannelViewController alloc] init];
        elliott = [[User alloc]initWithUsername:@"Elliott"];
        elliott.UUID = [[NSUUID alloc] init];
        xida = [[User alloc]initWithUsername:@"Xida"];
        xida.UUID = [[NSUUID alloc] init];
        
        NSLog(@"%@", elliott);
        NSLog(@"%@", xida);
    });
    
    describe(@"make a message", ^{
//        beforeEach(^{
//            Message *greeting = [[Message alloc] initWithSender:elliott content:@"Hi" channelName:newChannelVC.channelName];
//            
//            [newChannelVC.recentMessages addObject:greeting];
//            
//        });
        
        it(@"should contain a message", ^{

//            expect(((Message *)newChannelVC.recentMessages[0]).content).to.equal(@"Hi");
        });
        
        
    });

});


SpecEnd