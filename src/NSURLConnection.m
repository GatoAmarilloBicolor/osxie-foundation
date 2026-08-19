#import <Foundation/NSURLConnection.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <Foundation/NSRunLoop.h>
#import <Foundation/NSOperation.h>

@implementation NSURLConnectionInternal
@end

@implementation NSURLConnection

+ (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    return [[[self alloc] initWithRequest:request delegate:delegate startImmediately:YES] autorelease];
}
+ (BOOL)canHandleRequest:(NSURLRequest *)request { return NO; }
- (id)initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate startImmediately:(BOOL)startImmediately {
    self = [super init];
    if (self) {
        _internal = [[NSURLConnectionInternal alloc] init];
    }
    return self;
}
- (id)initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}
- (NSURLRequest *)originalRequest { return nil; }
- (NSURLRequest *)currentRequest { return nil; }
- (void)start {}
- (void)cancel {}
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {}
- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {}
- (void)setDelegateQueue:(NSOperationQueue *)queue {}
- (void)dealloc {
    [_internal release];
    [super dealloc];
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    if (error) *error = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1000 userInfo:nil];
    return nil;
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler {
    if (handler) {
        NSError *error = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1000 userInfo:nil];
        handler(nil, nil, error);
    }
}

@end
