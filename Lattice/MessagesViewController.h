//
//  MessagesViewController.h
//  Lattice
//
//  Created by Xida Zheng on 12/1/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import <JSQMessages.h>
#import "DemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"

@interface MessagesViewController : JSQMessagesViewController
@property (strong, nonatomic) DemoModelData *demoData;
@property (strong, nonatomic) NSString *channelName;
@end
