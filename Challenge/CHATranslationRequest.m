//
//  CHARequestManager.m
//  Challenge
//
//  Created by Galia Kaufman on 5/18/14.
//
//

#import "CHATranslationRequest.h"
#import <UNIRest.h>

#define YODA_SERVICE_URL @"https://yoda.p.mashape.com/yoda"
#define YODA_HEADER_AUTHORIZATION_ATTRIBUTE @"X-Mashape-Authorization"
#define YODA_HEADER_AUTHORIZATION_KEY @"FF6gbWPr3vrMO5qZcupdN7XE6lQNB3wh"

NSString * const languageNames[] = {
    @"YODA",
    @"LEET"
};

// private properties
@interface CHATranslationRequest()
@property (strong, nonatomic) UNIUrlConnection* activeConnection;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *urlFormat;
@end


@implementation CHATranslationRequest

#pragma mark - initialization

- (id)initWithLanguage:(CHALanguages)language
{
    if (self = [self init]) {
        
        // setup language defaults
        
        switch (language) {
            case CHALanguageYoda:
                [self setupYoda];
                break;
                
            default:
                // the request cannot be initialized - return nil
                NSLog(@"Error: language not supported: %@", [CHATranslationRequest nameForLanguage:language]);
                self = nil;
                break;
        }
    }
    return self;
}

- (void)setupYoda
{
    self.headers = @{YODA_HEADER_AUTHORIZATION_ATTRIBUTE: YODA_HEADER_AUTHORIZATION_KEY};
    self.parameters = @{};

    // assumin only one url parameter, for now...
    self.urlFormat = [NSString stringWithFormat:@"%@?sentence=%@", YODA_SERVICE_URL, @"%@"];
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

+ (NSString *)nameForLanguage:(CHALanguages)language
{
    return languageNames[language];
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
- (NSString *)parseResponse:(UNIHTTPStringResponse *)stringResponse
{
    if (!stringResponse)
        return nil;
    
    NSError *error;
    NSDictionary *translationResult = [NSJSONSerialization JSONObjectWithData:[stringResponse rawBody] options: 0 error: &error];
    
    // if the string-response converts to a valid JSON, we can assume there was an error....
    if (translationResult)
        NSLog(@"Request Error: %@",[stringResponse body]);
    
    return translationResult ? nil : [stringResponse body];
}

@end
