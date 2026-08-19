#import <Foundation/NSURLResponse.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSURLRequest.h>

@interface NSURLResponseInternal : NSObject {
@public
    NSURL *_url;
    NSString *_mimeType;
    long long _expectedContentLength;
    NSString *_textEncodingName;
    NSString *_suggestedFilename;
}
@end

@implementation NSURLResponseInternal
- (void)dealloc {
    [_url release];
    [_mimeType release];
    [_textEncodingName release];
    [_suggestedFilename release];
    [super dealloc];
}
@end

@interface NSHTTPURLResponseInternal : NSObject {
@public
    NSInteger _statusCode;
    NSDictionary *_allHeaderFields;
}
@end

@implementation NSHTTPURLResponseInternal
- (void)dealloc {
    [_allHeaderFields release];
    [super dealloc];
}
@end

@implementation NSURLResponse

- (id)initWithURL:(NSURL *)URL MIMEType:(NSString *)MIMEType expectedContentLength:(NSInteger)length textEncodingName:(NSString *)name {
    self = [super init];
    if (self) {
        _internal = [[NSURLResponseInternal alloc] init];
        _internal->_url = [URL copy];
        _internal->_mimeType = [MIMEType copy];
        _internal->_expectedContentLength = length;
        _internal->_textEncodingName = [name copy];
    }
    return self;
}

- (NSURL *)URL { return _internal->_url; }
- (NSString *)MIMEType { return _internal->_mimeType; }
- (long long)expectedContentLength { return _internal->_expectedContentLength; }
- (NSString *)textEncodingName { return _internal->_textEncodingName; }
- (NSString *)suggestedFilename {
    NSString *name = [[_internal->_url path] lastPathComponent];
    return name ? name : @"Unknown";
}

- (id)initWithCoder:(NSCoder *)coder { return [self init]; }
- (void)encodeWithCoder:(NSCoder *)coder {}
- (id)copyWithZone:(NSZone *)zone { return [self retain]; }

- (void)dealloc {
    [_internal release];
    [super dealloc];
}

@end

@implementation NSHTTPURLResponse

- (id)initWithURL:(NSURL *)URL statusCode:(NSInteger)statusCode HTTPVersion:(NSString *)HTTPVersion headerFields:(NSDictionary *)headerFields {
    self = [super initWithURL:URL MIMEType:nil expectedContentLength:0 textEncodingName:nil];
    if (self) {
        _httpInternal = [[NSHTTPURLResponseInternal alloc] init];
        _httpInternal->_statusCode = statusCode;
        _httpInternal->_allHeaderFields = [headerFields copy];
    }
    return self;
}

- (NSInteger)statusCode { return _httpInternal->_statusCode; }
- (NSDictionary *)allHeaderFields { return _httpInternal->_allHeaderFields; }

+ (NSString *)localizedStringForStatusCode:(NSInteger)statusCode {
    switch (statusCode) {
        case 200: return @"OK";
        case 201: return @"Created";
        case 204: return @"No Content";
        case 301: return @"Moved Permanently";
        case 302: return @"Found";
        case 304: return @"Not Modified";
        case 400: return @"Bad Request";
        case 401: return @"Unauthorized";
        case 403: return @"Forbidden";
        case 404: return @"Not Found";
        case 408: return @"Request Timeout";
        case 500: return @"Internal Server Error";
        case 502: return @"Bad Gateway";
        case 503: return @"Service Unavailable";
        default: return @"Unknown";
    }
}

+ (BOOL)isErrorStatusCode:(NSInteger)statusCode {
    return statusCode >= 400;
}

- (void)dealloc {
    [_httpInternal release];
    [super dealloc];
}

@end
