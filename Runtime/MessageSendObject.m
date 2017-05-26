//
//  MessageSendObject.m
//  Runtime
//
//  Created by liukai on 25/05/2017.
//  Copyright © 2017 com.gavin. All rights reserved.
//

#import "MessageSendObject.h"

@interface MessageSendObject ()
{
    NSString *_realName;
}

@property (strong, nonatomic) NSString *boyName;

@end

@implementation MessageSendObject
@dynamic dynamicName;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.girlName = @"Norma";
        self.boyName = @"Gavin";
        _realName = @"Kai";
    }
    return self;
}
- (NSString *)sendInfo
{
    NSString *name = [MessageSendObject nickname];
//    NSLog(@"Norma");
    return [NSString stringWithFormat:@"%@ love %@", name, self.girlName];
}

- (NSString *)dynamicName
{
    return @"Love";
}

+ (NSString *)nickname
{
    return @"gavin";
}
@end
