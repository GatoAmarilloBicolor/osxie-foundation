#import <Foundation/NSHTTPCookieStorage.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSHTTPCookie.h>

NSString * const NSHTTPCookieManagerAcceptPolicyChangedNotification = @"NSHTTPCookieManagerAcceptPolicyChangedNotification";
NSString * const NSHTTPCookieManagerCookiesChangedNotification = @"NSHTTPCookieManagerCookiesChangedNotification";

@implementation NSHTTPCookieStorage

+ (NSHTTPCookieStorage *)sharedHTTPCookieStorage {
    static NSHTTPCookieStorage *shared = nil;
    if (!shared) shared = [[self alloc] init];
    return shared;
}

- (NSArray *)cookies { return nil; }
- (void)setCookie:(NSHTTPCookie *)cookie {}
- (void)deleteCookie:(NSHTTPCookie *)cookie {}
- (NSArray *)cookiesForURL:(NSURL *)URL { return nil; }
- (void)setCookies:(NSArray *)cookies forURL:(NSURL *)URL mainDocumentURL:(NSURL *)mainDocumentURL {}
- (NSHTTPCookieAcceptPolicy)cookieAcceptPolicy { return NSHTTPCookieAcceptPolicyAlways; }
- (void)setCookieAcceptPolicy:(NSHTTPCookieAcceptPolicy)cookieAcceptPolicy {}

@end
