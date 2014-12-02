//
//  XZMessage.m
//  Lattice
//
//  Created by Xida Zheng on 12/1/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "XZMessage.h"

@implementation XZMessage

- (instancetype)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text channelName:(NSString *)channelName
{
    self = [super initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    if (self) {
        _channelName = channelName;
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _channelName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(channelName))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.channelName forKey:NSStringFromSelector(@selector(channelName))];
    
}
@end
