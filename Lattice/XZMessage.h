//
//  XZMessage.h
//  Lattice
//
//  Created by Xida Zheng on 12/1/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "JSQMessage.h"

@interface XZMessage : JSQMessage <JSQMessageData, NSCoding>
@property (strong, nonatomic) NSString *channelName;

- (instancetype)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text channelName:(NSString *)channelName;

@end
