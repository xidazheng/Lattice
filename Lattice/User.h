//
//  User.h
//  Lattice
//
//  Created by Xida Zheng on 11/23/14.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSUUID *UUID;
-(instancetype)initWithUsername:(NSString *)username;


@end
