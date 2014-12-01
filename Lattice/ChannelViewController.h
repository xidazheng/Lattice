//
//  ChannelTableViewController.h
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HPLChatTableView.h>

@interface ChannelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *channelName;
@property (strong, nonatomic) NSMutableArray *recentMessages;


@end
