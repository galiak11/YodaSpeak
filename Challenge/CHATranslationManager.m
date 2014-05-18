//
//  CHATranslationManager.m
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import "CHATranslationManager.h"

NSString * const languageNames[] = {
    @"YODA",
    @"LEET"
};

@implementation CHATranslationManager

#pragma mark - initialization

- (id)init {
    if (self = [super init]) {
        
        // one time initialization
        
        self.currentLanguage = CHLLanguageYoda;
    }
    return self;
}

+ (id)sharedManager {
    
    // creating a static TranslationManager first time the class is being used
    static CHATranslationManager *sharedTranslationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTranslationManager = [[self alloc] init];
    });
    
    // returns the TranslationManager
    return sharedTranslationManager;
}

#pragma mark - translation

- (NSString *)translate:(NSString *)text {
    
    return [self translate:text to:self.currentLanguage];
}

- (NSString *)translate:(NSString *)text to:(CHLLanguages)language {
    
    return text;
}

#pragma mark - language selection

- (NSString *)currentLanguageName
{
    return languageNames[self.currentLanguage];
}

- (NSString *)nameForLanguage:(CHLLanguages)language
{
    return languageNames[language];
}

@end
