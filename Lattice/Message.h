//
//  Message.h
//  Lattice
//
//  Created by Xida Zheng on 11/23/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Message : NSObject <NSCoding>

@property (strong, nonatomic) User *sender;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSString *channelName;
-(instancetype)initWithSender:(User *)sender content:(NSString *)content channelName:(NSString *)channelName;

@end
