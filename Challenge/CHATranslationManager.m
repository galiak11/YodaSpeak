//
//  CHATranslationManager.m
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import "CHATranslationManager.h"

@interface CHATranslationManager()
@property (strong, nonatomic) CHATranslationRequest *httpRequest;

@end

@implementation CHATranslationManager

#pragma mark - initialization

- (id)init {
    if (self = [super init]) {
        self.currentLanguage = CHALanguageYoda;
        self.httpRequest = [[CHATranslationRequest alloc] initWithLanguage:self.currentLanguage];
    }
    return self;
}

+ (id)sharedManager {
    
    // creating a static translationManager once - first time the class is being used
    static CHATranslationManager *sharedTranslationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTranslationManager = [[self alloc] init];
    });
    
    // returns the shared translationManager
    return sharedTranslationManager;
}

#pragma mark - translation (synchronous requests)

- (NSString *)translate:(NSString *)text {
    
    return [self translate:text to:self.currentLanguage];
}

- (NSString *)translate:(NSString *)text to:(CHALanguages)language {
    
    if (!self.httpRequest)
        return @"Language not supported";
    else
        return [self.httpRequest translate:text];
}

#pragma mark - translation (asynchronous requests)

- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock {
    
    [self translate:text to:self.currentLanguage result:resultBlock];
}

- (void)translate:(NSString *)text to:(CHALanguages)language result:(CHAStringResultBlock)resultBlock {
    
    if (!self.httpRequest)
        resultBlock(@"Language not supported");
    else
        [self.httpRequest translate:text result:resultBlock];
}

#pragma mark - language selection

- (NSString *)currentLanguageName
{
    return [CHATranslationRequest nameForLanguage:self.currentLanguage];
}

@end
