#import <Foundation/NSURLSession.h>
#import <Foundation/NSURLResponse.h>
#import <Foundation/NSURLProtocol.h>
#import <Foundation/NSOperation.h>
#import <Foundation/NSURLCache.h>
#import <Foundation/NSURLCredentialStorage.h>
#import <Foundation/NSHTTPCookieStorage.h>
#import <Foundation/NSError.h>

const int64_t NSURLSessionTransferSizeUnknown = -1;
NSString * const NSURLSessionDownloadTaskResumeData = @"NSURLSessionDownloadTaskResumeData";

@implementation NSURLSessionTask

- (NSUInteger)taskIdentifier { return 0; }
- (NSURLRequest *)originalRequest { return nil; }
- (NSURLRequest *)currentRequest { return nil; }
- (NSURLResponse *)response { return nil; }
- (int64_t)countOfBytesReceived { return 0; }
- (int64_t)countOfBytesSent { return 0; }
- (int64_t)countOfBytesExpectedToSend { return 0; }
- (int64_t)countOfBytesExpectedToReceive { return 0; }
- (NSString *)taskDescription { return nil; }
- (void)setTaskDescription:(NSString *)d {}
- (NSURLSessionTaskState)state { return NSURLSessionTaskStateCompleted; }
- (NSError *)error { return nil; }
- (void)cancel {}
- (void)suspend {}
- (void)resume {}
- (id)copyWithZone:(NSZone *)zone { return [self retain]; }
@end

@implementation NSURLSessionDataTask
@end

@implementation NSURLSessionUploadTask
@end

@implementation NSURLSessionDownloadTask
- (void)cancelByProducingResumeData:(void (^)(NSData *resumeData))completionHandler {
    if (completionHandler) completionHandler(nil);
}
@end

@implementation NSURLSessionConfiguration

- (NSString *)identifier { return nil; }
- (NSURLRequestCachePolicy)requestCachePolicy { return NSURLRequestUseProtocolCachePolicy; }
- (void)setRequestCachePolicy:(NSURLRequestCachePolicy)p {}
- (NSTimeInterval)timeoutIntervalForRequest { return 60; }
- (void)setTimeoutIntervalForRequest:(NSTimeInterval)t {}
- (NSTimeInterval)timeoutIntervalForResource { return 7 * 24 * 60 * 60; }
- (void)setTimeoutIntervalForResource:(NSTimeInterval)t {}
- (BOOL)allowsCellularAccess { return YES; }
- (void)setAllowsCellularAccess:(BOOL)a {}
- (BOOL)isDiscretionary { return NO; }
- (void)setDiscretionary:(BOOL)d {}
- (BOOL)sessionSendsLaunchEvents { return YES; }
- (void)setSessionSendsLaunchEvents:(BOOL)s {}
- (NSDictionary *)connectionProxyDictionary { return nil; }
- (void)setConnectionProxyDictionary:(NSDictionary *)d {}
- (BOOL)HTTPShouldUsePipelining { return NO; }
- (void)setHTTPShouldUsePipelining:(BOOL)p {}
- (BOOL)HTTPShouldSetCookies { return YES; }
- (void)setHTTPShouldSetCookies:(BOOL)s {}
- (NSHTTPCookieAcceptPolicy)HTTPCookieAcceptPolicy { return NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain; }
- (void)setHTTPCookieAcceptPolicy:(NSHTTPCookieAcceptPolicy)p {}
- (NSDictionary *)HTTPAdditionalHeaders { return nil; }
- (void)setHTTPAdditionalHeaders:(NSDictionary *)h {}
- (NSInteger)HTTPMaximumConnectionsPerHost { return 4; }
- (void)setHTTPMaximumConnectionsPerHost:(NSInteger)m {}
- (NSHTTPCookieStorage *)HTTPCookieStorage { return nil; }
- (void)setHTTPCookieStorage:(NSHTTPCookieStorage *)s {}
- (NSURLCredentialStorage *)URLCredentialStorage { return nil; }
- (void)setURLCredentialStorage:(NSURLCredentialStorage *)s {}
- (NSURLCache *)URLCache { return nil; }
- (void)setURLCache:(NSURLCache *)c {}
- (NSArray *)protocolClasses { return nil; }
- (void)setProtocolClasses:(NSArray *)c {}
- (id)copyWithZone:(NSZone *)zone { return [self retain]; }
- (void)dealloc { [super dealloc]; }

+ (NSURLSessionConfiguration *)defaultSessionConfiguration {
    return [[[self alloc] init] autorelease];
}
+ (NSURLSessionConfiguration *)ephemeralSessionConfiguration {
    return [self defaultSessionConfiguration];
}
+ (NSURLSessionConfiguration *)backgroundSessionConfiguration:(NSString *)identifier {
    return [self defaultSessionConfiguration];
}

@end

@implementation NSURLSession

+ (NSURLSession *)sharedSession {
    static NSURLSession *shared = nil;
    if (!shared) {
        shared = [[NSURLSession alloc] init];
    }
    return shared;
}
+ (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
}
+ (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    return [[[self alloc] init] autorelease];
}
- (NSOperationQueue *)delegateQueue { return nil; }
- (id<NSURLSessionDelegate>)delegate { return nil; }
- (NSURLSessionConfiguration *)configuration { return nil; }
- (NSString *)sessionDescription { return nil; }
- (void)setSessionDescription:(NSString *)d {}
- (void)finishTasksAndInvalidate {}
- (void)invalidateAndCancel {}
- (void)resetWithCompletionHandler:(void (^)(void))completionHandler { if (completionHandler) completionHandler(); }
- (void)flushWithCompletionHandler:(void (^)(void))completionHandler { if (completionHandler) completionHandler(); }
- (void)getTasksWithCompletionHandler:(void (^)(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks))completionHandler { if (completionHandler) completionHandler(nil, nil, nil); }
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL { return [[[NSURLSessionUploadTask alloc] init] autorelease]; }
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData { return [[[NSURLSessionUploadTask alloc] init] autorelease]; }
- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request { return [[[NSURLSessionUploadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionUploadTask alloc] init] autorelease]; }
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionUploadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDownloadTask alloc] init] autorelease]; }
- (NSURLSessionDataTask *)dataTaskWithHTTPGetRequest:(NSURL *)url { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (NSURLSessionDataTask *)dataTaskWithHTTPGetRequest:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler { return [[[NSURLSessionDataTask alloc] init] autorelease]; }
- (void)dealloc { [super dealloc]; }
@end
