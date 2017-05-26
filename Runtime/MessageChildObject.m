//
//  MessageChildObject.m
//  Runtime
//
//  Created by liukai on 26/05/2017.
//  Copyright © 2017 com.gavin. All rights reserved.
//

#import "MessageChildObject.h"

@interface MessageChildObject ()

//-(void)goHome:(NSString *) name;

@end

@implementation MessageChildObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"child super description:%@", [super description]);
    }
    return self;
}

- (void)goHome:(NSString *) name
{
    NSLog(@"I'm go home -- %@", name);
}

- (void)negotiate:(NSString *)name
{
     NSLog(@"negoitate -- %@", name);
}

@end
