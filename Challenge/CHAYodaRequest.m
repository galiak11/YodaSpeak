//
//  CHAYodaRequest.m
//  Challenge
//
//  Created by Galia Kaufman on 5/21/14.
//
//

#define BaseClass_protected
#import "CHATranslationRequest.h"
#import "CHAYodaRequest.h"

#define YODA_SERVICE_URL @"https://yoda.p.mashape.com/yoda"
#define YODA_HEADER_AUTHORIZATION_ATTRIBUTE @"X-Mashape-Authorization"
#define YODA_HEADER_AUTHORIZATION_KEY @"FF6gbWPr3vrMO5qZcupdN7XE6lQNB3wh"

#define LANGUAGE_NAME @"YODA"


@implementation CHAYodaRequest

// setting up request parameters
// subclass must override and return self (or nil if invalid)
- (id)initRequest
{
    
    self.headers = @{YODA_HEADER_AUTHORIZATION_ATTRIBUTE: YODA_HEADER_AUTHORIZATION_KEY};
    self.parameters = @{};
    
    // assumin only one url parameter, for now...
    self.urlFormat = [NSString stringWithFormat:@"%@?sentence=%@", YODA_SERVICE_URL, @"%@"];
    
    return self;
}

- (NSString *)languageName
{
    return LANGUAGE_NAME;
}

@end
