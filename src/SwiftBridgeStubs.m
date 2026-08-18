#import <Foundation/Foundation.h>

// Swift ABI: Foundation.CocoaError._nsError.getter : NSError
// Called by Swift code to bridge CocoaError to NSError
__attribute__((visibility("default")))
id _$s10Foundation10CocoaErrorV03_nsC0So7NSErrorCvg(void) {
    return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
}

// Swift ABI: Foundation._NSRange.__unconditionallyBridgingFromObjectiveCore(_:) 
__attribute__((visibility("default")))
NSRange _$s10Foundation8_NSRangeV36_unconditionallyBridgingFromObjectiveCSo6NSRangeVSo0aB6_Rangess011ClosedRangeVyIntG_tF(void) {
    return NSMakeRange(0, 0);
}
