#import <Foundation/NSURLDownload.h>

@implementation NSURLDownload

+ (BOOL)canResumeDownloadDecodedWithEncodingMIMEType:(NSString *)MIMEType {
    return NO;
}

- (void)cancel {
}

- (BOOL)deletesFileUponFailure {
    return YES;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    self = [super init];
    return self;
}

- (id)initWithResumeData:(NSData *)resumeData
                delegate:(id)delegate
                    path:(NSString *)path {
    self = [super init];
    return self;
}

- (NSURLRequest *)request {
    return nil;
}

- (NSData *)resumeData {
    return nil;
}

- (void)setDeletesFileUponFailure:(BOOL)deletesFileUponFailure {
}

- (void)setDestination:(NSString *)path allowOverwrite:(BOOL)allowOverwrite {
}

@end
