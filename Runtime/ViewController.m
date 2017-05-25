//
//  ViewController.m
//  Runtime
//
//  Created by liukai on 25/05/2017.
//  Copyright © 2017 com.gavin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "MessageSendObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MessageSendObject *sendObject = [[MessageSendObject alloc] init];
    NSLog(@"name:%@", sendObject.dynamicName);
    
    void (*setter)(id, SEL, BOOL);
    int j;
    
    setter = (void (*)(id, SEL, BOOL))[sendObject
                                       methodForSelector:@selector(sendInfo)];
    for ( j = 0 ; j < 1000 ; j++ )
    {
         setter(sendObject, @selector(sendInfo), YES);
    }
    
    id LenderClass = objc_getClass("MessageSendObject");
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
//        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
        NSLog(@"%s %s\n", property_getName(property), property_getAttributes(property));
    }
    
    //[self class] 与 object_getClass(self)
    NSLog(@"description %@", [[sendObject class] description]);
    NSLog(@"description %@", [object_getClass(sendObject) description]);
    NSLog(@"description %@", [[MessageSendObject class] description]);
    
    NSString *key = [self nameWithInstance:sendObject value:@"Gavin"];
    NSLog(@"key %@", key);
}

//property name with value
-(NSString *)nameWithInstance:(id)instance value:(id)value
{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([instance class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"])
        {
            continue;
        }
        if ((object_getIvar(instance, thisIvar) == value)) {//此处若 crash 不要慌！
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}


@end
