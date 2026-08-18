#import <Foundation/NSAppleEventManager.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSNumber.h>
#import <Foundation/NSValue.h>

static NSAppleEventManager* instance = nil;

@implementation NSAppleEventManager

+ (NSAppleEventManager *)sharedAppleEventManager
{
    @synchronized(self)
    {
        if (instance == nil)
            instance = [[NSAppleEventManager alloc] init];
    }
    return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes: "v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"Stub called: %@ in %@", NSStringFromSelector([anInvocation selector]), [self class]);
}

- (void) setEventHandler: (id) handler
             andSelector: (SEL) selector
           forEventClass: (AEEventClass) eventClass
              andEventID: (AEEventID) eventID
{
    static NSMutableDictionary *handlers = nil;

    // Osxie does not generate Apple events, so this is effectively a
    // registration point: store the handler/selector so the app's own
    // dispatch (e.g. re-emitting an event it got through other means) can
    // find it. Keyed by (eventClass, eventID).
    if (handlers == nil) {
        handlers = [[NSMutableDictionary alloc] init];
    }

    NSNumber *key = [NSNumber numberWithUnsignedLongLong:
        (((unsigned long long)eventClass << 32) | (unsigned long long)eventID)];

    if (handler == nil || selector == NULL) {
        [handlers removeObjectForKey: key];
        return;
    }

    NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys:
        handler, @"handler",
        [NSValue valueWithPointer: selector], @"selector",
        nil];
    [handlers setObject: entry forKey: key];
}

@end
