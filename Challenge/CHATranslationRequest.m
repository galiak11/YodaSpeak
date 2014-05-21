//
//  CHARequestManager.m
//  Challenge
//
//  Created by Galia Kaufman on 5/18/14.
//
//

#define BaseClass_protected
#import "CHATranslationRequest.h"
#import <UNIRest.h>

// private properties
@interface CHATranslationRequest()

@property (strong, nonatomic) UNIUrlConnection* activeConnection;

@end

//
// This class must be subclassed with a specific language implementations.
//
// Subclasses must override the following methods:
//
//        - (id)initRequest
//
//              initializes the request for a specific language and returns self (or nil if invalid)
//              The specific implementation must initialize the protected request properties (headers, parameters, urlFormat, ...)
//
//        - (NSString *)languageName
//
//              returns a string representation of subclass' language
//
//

@implementation CHATranslationRequest

#pragma mark - initialization

- (id)init
{
    if (self = [super init])
    {
        // setup language defaults
        self = [self initRequest];
    }
    return self;
}

// initializes the request for a specific language and returns self (or nil if invalid)
- (id)initRequest
{
    // must be overriden by subclass!
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - translation

// synchronous translation request
- (NSString *)translate:(NSString *)text
{
    
    if ([text isEqualToString:@""])
        return text;
    
    NSString *encodedText = [self urlEncodeUTF8String:text];
    NSString *url = [NSString stringWithFormat:self.urlFormat, encodedText];
    
    return [self makeRequestWithUrl:url];
}
    
// asynchronous translation request
- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock
{
    if ([text isEqualToString:@""])
        resultBlock(text);
    
    NSString *encodedText = [self urlEncodeUTF8String:text];
    NSString *url = [NSString stringWithFormat:self.urlFormat, encodedText];
    
    return [self makeRequestWithUrl:url result:resultBlock];
}

// returns a string representation of current language
- (NSString *)languageName
{
    // must be overriden by subclass!
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


#pragma mark - UniRest HTTP requests

// synchronous HTTP request
- (NSString *)makeRequestWithUrl:(NSString *)urlstring  {
    
    UNIHTTPStringResponse* stringResponse = [[UNIRest get:^(UNISimpleRequest* request) {
        
        [request setUrl:urlstring];
        [request setHeaders:self.headers];
        [request setParameters:self.parameters];
        
    }] asString];
    
    return [self parseResponse:stringResponse];
}

// asynchronous HTTP request
- (void)makeRequestWithUrl:(NSString *)urlstring result:(CHAStringResultBlock)resultBlock {
    
    // stop an on-going request if one is already in progress
    [self.activeConnection cancel];
    
    // start an async request
    self.activeConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        
        // setup the request (using current language defaults)
        [request setUrl:urlstring];
        [request setHeaders:self.headers];
        [request setParameters:self.parameters];
        
    }] asStringAsync:^(UNIHTTPStringResponse *stringResponse, NSError *error) {
        
        // return a string result - as a block argument. Result is nil when an error occurs.
        NSString *result = nil;
        
        if (error)
            NSLog(@"Request Error: %@",[error localizedDescription]);
        else
            result = [self parseResponse:stringResponse];

        // ensure caller operations (specifically UI operations) are done on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock (result);
        });
        
        self.activeConnection = nil;
        
    }];
    
}

// returns URL encoded string
- (NSString *)urlEncodeUTF8String:(NSString *)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"!*'();@&+$,/?%#[]~=_-.:", kCFStringEncodingUTF8)) ;
}

// responses from yoda.p.mashape.com are typically strings. Errors are sent as JSONs.
// returns the response "as is" if it's a plain string, or nil if there's an error.
- (NSString *)parseResponse:(UNIHTTPStringResponse *)response
{
    if (!response)
        return nil;
    
    NSError *error;
    NSDictionary *translationResult = [NSJSONSerialization JSONObjectWithData:[response rawBody] options: 0 error: &error];
    
    // if the string-response converts to a valid JSON, we can assume there was an error....
    if (translationResult)
        NSLog(@"Request Error: %@",[response body]);
    
    NSString *stringResponse = [response body];
    NSRange range = [stringResponse rangeOfString:@"html"];
    if (range.location != NSNotFound)
    {
        NSLog(@"HTML RESPONSE!!!");
        NSLog(@"%@", stringResponse);
    }
    
    return translationResult ? nil : stringResponse;
}

@end
