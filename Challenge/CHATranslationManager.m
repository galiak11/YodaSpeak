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
        // for now we support a single language - so we can initialize it here with a constant
        self.httpRequest = [[CHATranslationRequest alloc] initWithLanguage:CHALanguageYoda];
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

#pragma mark - translation

- (NSString *)translate:(NSString *)text {
    
    if (!self.httpRequest)
        return @"Language not supported";
    else
        return [self.httpRequest translate:text];
}

- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock {
    
    if (!self.httpRequest)
        resultBlock(@"Language not supported");
    else
        [self.httpRequest translate:text result:resultBlock];
}

- (NSString *)currentLanguageName
{
    return [self.httpRequest languageName];
}

@end
