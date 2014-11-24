//
//  Message.m
//  Lattice
//
//  Created by Xida Zheng on 11/23/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "Message.h"

@implementation Message

-(instancetype)initWithSender:(User *)sender content:(NSString *)content channelName:(NSString *)channelName;
{
    self = [super init];
    if (self) {
        _sender = sender;
        _content = content;
        _timestamp = [NSDate date];
        _channelName = channelName;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithSender:nil content:@"" channelName:@""];
}

@end
