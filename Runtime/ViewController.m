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
#import "MessageChildObject.h"

@interface ViewController ()

+ (void)learnClass:(NSString *) string;
- (void)goToSchool:(NSString *) name;

-(void)goHome:(NSString *) name;

-(void)negotiate:(NSString *) name;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MessageSendObject *sendObject = [[MessageSendObject alloc] init];
    NSLog(@"name:%@", sendObject.dynamicName);
    
    MessageChildObject *childeObject = [[MessageChildObject alloc]init];
    NSLog(@"child description:%@", [childeObject description]);
    
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
    
    //dynamic method
    [ViewController learnClass:@"gavinClass"];
    [self goToSchool:@"norma"];
    [self goHome:@"wind"];
    [self negotiate:@"negotiate"];
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
        if ((object_getIvar(instance, thisIvar) == value))
        {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(learnClass:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
        return YES;
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(goToSchool:))
    {
        class_addMethod([self class], aSEL, class_getMethodImplementation([self class], @selector(myInstanceMethod:)), "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

+ (void)myClassMethod:(NSString *)string
{
    NSLog(@"myClassMethod = %@", string);
}

- (void)myInstanceMethod:(NSString *)string
{
    NSLog(@"myInstanceMethod = %@", string);
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector == @selector(goHome:))
    {
        MessageChildObject *childeObject = [[MessageChildObject alloc]init];
        return childeObject;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    MessageChildObject *childeObject = [[MessageChildObject alloc]init];
    if ([childeObject respondsToSelector:
         [anInvocation selector]])
        [anInvocation invokeWithTarget:childeObject];
    else
        [super forwardInvocation:anInvocation];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        MessageChildObject *childeObject = [[MessageChildObject alloc]init];
        signature = [childeObject methodSignatureForSelector:selector];
    }
    return signature;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class aClass = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(aClass, originalSelector);
        // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated]; 
    NSLog(@"viewWillAppear: %@", self); 
}

@end
