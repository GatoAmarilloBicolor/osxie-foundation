#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSStream.h>
#import <CoreFoundation/CFArray.h>
#import <Foundation/NSCoder.h>


extern void *CFURLRequestCreate(void *alloc, void *url, unsigned long policy, double timeout);
extern void *CFURLRequestCreateMutableCopy(void *alloc, void *req);
extern void *CFURLRequestGetURL(void *req);
extern unsigned long CFURLRequestGetCachePolicy(void *req);
extern double CFURLRequestGetTimeout(void *req);
extern void *CFURLRequestCopyMainDocumentURL(void *req);
extern unsigned long CFURLRequestGetServiceType(void *req);
extern int CFURLRequestAllowsCellularAccess(void *req);
extern void *CFURLRequestCopyDebugDescription(void *req);
extern void *CFURLRequestCopyHTTPMethod(void *req);
extern void *CFURLRequestCopyHTTPFields(void *req);
extern void *CFURLRequestCopyValueForHTTPField(void *req, void *field);
extern void *CFURLRequestCopyHTTPValues(void *req);
extern void *CFURLRequestGetHTTPBody(void *req);
extern void *CFURLRequestGetHTTPBodyStream(void *req);
extern int CFURLRequestShouldHandleCookes(void *req);
extern int CFURLRequestShouldUseHTTPPipelining(void *req);
extern void CFURLRequestSetHTTPBody(void *req, const void *data);
extern void CFURLRequestSetHTTPBodyStream(void *req, const void *stream);
extern void CFURLRequestSetHTTPMethod(void *req, void *method);
extern void CFURLRequestSetHTTPFields(void *req, void *keys, void *values);
extern void CFURLRequestSetURL(void *req, void *url);
extern void CFURLRequestSetCachePolicy(void *req, unsigned long policy);
extern void CFURLRequestSetTimeout(void *req, double timeout);
extern void CFURLRequestSetMainDocumentURL(void *req, void *url);
extern void CFURLRequestSetNetworkServiceType(void *req, unsigned long type);
extern void CFURLRequestSetAllowsCellularAccess(void *req, int allow);
extern void CFURLRequestReplaceHTTPField(void *req, long idx, void *value);
extern void CFURLRequestAddValueForHTTPField(void *req, void *field, void *value);
extern void CFURLRequestHandleCookies(void *req, int handle);
extern void CFURLRequestUseHTTPPipelining(void *req, int use);
extern long CFURLRequestFirstFieldIndex(void *req, void *field, long start);

@interface NSURLRequestInternal : NSObject {
@public
    void *request;
}
@end

@implementation NSURLRequestInternal
- (void)dealloc {
    CFRelease(request);
    [super dealloc];
}
@end

@implementation NSURLRequest

static NSTimeInterval defaultTimeout = 60.0;

+ (NSTimeInterval)defaultTimeoutInterval { return defaultTimeout; }
+ (void)setDefaultTimeoutInterval:(NSTimeInterval)ti { defaultTimeout = ti; }

+ (id)requestWithURL:(NSURL *)URL {
    return [[[self alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[NSURLRequest defaultTimeoutInterval]] autorelease];
}

+ (id)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    return [[[self alloc] initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval] autorelease];
}

- (id)init { return [self initWithURL:nil]; }

- (id)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[NSURLRequest defaultTimeoutInterval]];
}

- (id)_initWithCFURLRequest:(void *)req {
    self = [super init];
    if (self) {
        _internal = [[NSURLRequestInternal alloc] init];
        _internal->request = CFRetain(req);
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    void *request = CFURLRequestCreate(NULL, (void *)URL, (unsigned long)cachePolicy, (double)timeoutInterval);
    self = [self _initWithCFURLRequest:request];
    CFRelease(request);
    return self;
}

- (void)dealloc { [_internal release]; [super dealloc]; }
- (NSURL *)URL { return (NSURL *)CFURLRequestGetURL(_internal->request); }
- (NSURLRequestCachePolicy)cachePolicy { return (NSURLRequestCachePolicy)CFURLRequestGetCachePolicy(_internal->request); }
- (NSTimeInterval)timeoutInterval { return (NSTimeInterval)CFURLRequestGetTimeout(_internal->request); }
- (NSURL *)mainDocumentURL { return [(NSURL *)CFURLRequestCopyMainDocumentURL(_internal->request) autorelease]; }
- (NSURLRequestNetworkServiceType)networkServiceType { return (NSURLRequestNetworkServiceType)CFURLRequestGetServiceType(_internal->request); }
- (BOOL)allowsCellularAccess { return (BOOL)CFURLRequestAllowsCellularAccess(_internal->request); }
- (void *)_CFURLRequest { return _internal->request; }

- (id)copyWithZone:(NSZone *)zone {
    void *req = CFURLRequestCreateMutableCopy(NULL, _internal->request);
    NSURLRequest *copy = [[NSURLRequest alloc] _initWithCFURLRequest:req];
    CFRelease(req);
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    void *req = CFURLRequestCreateMutableCopy(NULL, _internal->request);
    NSMutableURLRequest *copy = [[NSMutableURLRequest alloc] _initWithCFURLRequest:req];
    CFRelease(req);
    return copy;
}

- (NSString *)debugDescription {
    void *reqDesc = CFURLRequestCopyDebugDescription(_internal->request);
    NSString *desc = [NSString stringWithFormat:@"<NSURLRequest %p %@>", self, reqDesc];
    CFRelease(reqDesc);
    return desc;
}

- (void)encodeWithCoder:(NSCoder *)coder {}
- (id)initWithCoder:(NSCoder *)coder { return [self init]; }

@end

@implementation NSURLRequest (NSHTTPURLRequest)

- (NSString *)HTTPMethod {
    void *method = CFURLRequestCopyHTTPMethod([self _CFURLRequest]);
    return [(NSString *)method autorelease];
}
- (NSDictionary *)allHTTPHeaderFields {
    void *req = [self _CFURLRequest];
    void *keys = CFURLRequestCopyHTTPFields(req);
    void *values = CFURLRequestCopyHTTPValues(req);
    long count = CFArrayGetCount(keys);
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(id *)values forKeys:(id *)keys count:count];
    CFRelease(keys);
    CFRelease(values);
    return dict;
}
- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    void *val = CFURLRequestCopyValueForHTTPField([self _CFURLRequest], (void *)field);
    return [(NSString *)val autorelease];
}
- (NSData *)HTTPBody { return (NSData *)CFURLRequestGetHTTPBody([self _CFURLRequest]); }
- (NSInputStream *)HTTPBodyStream { return (NSInputStream *)CFURLRequestGetHTTPBodyStream([self _CFURLRequest]); }
- (BOOL)HTTPShouldHandleCookies { return (BOOL)CFURLRequestShouldHandleCookes([self _CFURLRequest]); }
- (BOOL)HTTPShouldUsePipelining { return (BOOL)CFURLRequestShouldUseHTTPPipelining([self _CFURLRequest]); }

@end

@implementation NSMutableURLRequest

- (id)_initWithCFURLRequest:(void *)req {
    void *request = CFURLRequestCreateMutableCopy(NULL, req);
    self = [super _initWithCFURLRequest:request];
    CFRelease(request);
    return self;
}

- (void)setURL:(NSURL *)URL {
    CFURLRequestSetURL([self _CFURLRequest], (void *)URL);
}
- (void)setCachePolicy:(NSURLRequestCachePolicy)policy {
    CFURLRequestSetCachePolicy([self _CFURLRequest], (unsigned long)policy);
}
- (void)setTimeoutInterval:(NSTimeInterval)seconds {
    CFURLRequestSetTimeout([self _CFURLRequest], (double)seconds);
}
- (void)setMainDocumentURL:(NSURL *)URL {
    CFURLRequestSetMainDocumentURL([self _CFURLRequest], (void *)URL);
}
- (void)setNetworkServiceType:(NSURLRequestNetworkServiceType)networkServiceType {
    CFURLRequestSetNetworkServiceType([self _CFURLRequest], (unsigned long)networkServiceType);
}
- (void)setAllowsCellularAccess:(BOOL)allow {
    CFURLRequestSetAllowsCellularAccess([self _CFURLRequest], (int)allow);
}

@end

@implementation NSMutableURLRequest (NSMutableHTTPURLRequest)

- (void)setHTTPMethod:(NSString *)method {
    CFURLRequestSetHTTPMethod([self _CFURLRequest], (void *)method);
}
- (void)setAllHTTPHeaderFields:(NSDictionary *)headerFields {
    void *req = [self _CFURLRequest];
    void *keys = (void *)[headerFields allKeys];
    void *values = (void *)[headerFields allValues];
    CFURLRequestSetHTTPFields(req, keys, values);
}
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    void *req = [self _CFURLRequest];
    long idx = CFURLRequestFirstFieldIndex(req, (void *)field, -1);
    if (idx != -1) {
        CFURLRequestReplaceHTTPField(req, idx, (void *)value);
    } else {
        CFURLRequestAddValueForHTTPField(req, (void *)field, (void *)value);
    }
}
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    CFURLRequestAddValueForHTTPField([self _CFURLRequest], (void *)field, (void *)value);
}
- (void)setHTTPBody:(NSData *)data {
    CFURLRequestSetHTTPBody([self _CFURLRequest], (const void *)data);
}
- (void)setHTTPBodyStream:(NSInputStream *)inputStream {
    CFURLRequestSetHTTPBodyStream([self _CFURLRequest], (const void *)inputStream);
}
- (void)setHTTPShouldHandleCookies:(BOOL)should {
    CFURLRequestHandleCookies([self _CFURLRequest], (int)should);
}
- (void)setHTTPShouldUsePipelining:(BOOL)shouldUsePipelining {
    CFURLRequestUseHTTPPipelining([self _CFURLRequest], (int)shouldUsePipelining);
}

@end
