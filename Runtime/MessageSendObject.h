//
//  MessageSendObject.h
//  Runtime
//
//  Created by liukai on 25/05/2017.
//  Copyright © 2017 com.gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageSendObject : NSObject

@property (strong, nonatomic) NSString *girlName;

@property (strong, nonatomic) NSString *dynamicName;

- (NSString *)sendInfo;

@end
