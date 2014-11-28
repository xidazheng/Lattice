//
//  Message.m
//  Lattice
//
//  Created by Xida Zheng on 11/23/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "Message.h"
#import "User.h"

@implementation Message

-(id)initWithCoder:(NSCoder *)aDecoder
{
    User *sender= [aDecoder decodeObjectForKey:@"sender"];
    NSString *content = [aDecoder decodeObjectForKey:@"content"];
    NSString *channelName = [aDecoder decodeObjectForKey:@"channelName"];
    NSDate *timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    return [self initWithSender:sender content:content channelName:channelName timeStamp:timestamp];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_sender forKey:@"sender"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_channelName forKey:@"channelName"];
    [aCoder encodeObject:_timestamp forKey:@"timestamp"];
}

-(instancetype)initWithSender:(User *)sender content:(NSString *)content channelName:(NSString *)channelName timeStamp:(NSDate *)timestamp;
{
    self = [super init];
    if (self) {
        _sender = sender;
        _content = content;
        _timestamp = timestamp;
        _channelName = channelName;
    }
    return self;
}

-(instancetype)initWithSender:(User *)sender content:(NSString *)content channelName:(NSString *)channelName;
{
    return [self initWithSender:sender content:content channelName:channelName timeStamp:[NSDate date]];
}

- (instancetype)init
{
    return [self initWithSender:nil content:@"" channelName:@""];
}

@end
