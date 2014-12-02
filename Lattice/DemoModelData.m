//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "DemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"
#import "User.h"

/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DemoModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.messages = [NSMutableArray new];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

        self.avatars = [[NSMutableDictionary alloc] init];
        self.users = [[NSMutableDictionary alloc ] init];
        
        [self addPeerWithUser:user];
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void) addPeerWithUser:(User *)user
{
    //parse username for initials
    NSArray *usernameWords = [user.username componentsSeparatedByString:@" "];
    NSString *usernameInitials = @"";
    
    if ([usernameWords count] == 1) {
        usernameInitials = [(NSString *)usernameWords[0] substringToIndex:1];
    } else if ([usernameWords count] > 2)
    {
        NSUInteger lastIndex = [usernameWords count] - 1;
        usernameInitials = [NSString stringWithFormat:@"%@%@%@", [(NSString *)usernameWords[0] substringToIndex:1], [(NSString *)usernameWords[1] substringToIndex:1], [(NSString *)usernameWords[lastIndex] substringToIndex:1]];
        
    } else if ([usernameWords count] == 2)
    {
        usernameInitials = [NSString stringWithFormat:@"%@%@", [(NSString *)usernameWords[0] substringToIndex:1], [(NSString *)usernameWords[1] substringToIndex:1]];
    }
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    JSQMessagesAvatarImage *avatarImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:usernameInitials
                                                                                     backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                           textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                font:[UIFont systemFontOfSize:14.0f]
                                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    
    self.avatars[[user.UUID UUIDString]] = avatarImage;
    
    self.users[[user.UUID UUIDString]] = user.username;
}

@end
