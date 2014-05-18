//
//  CHATranslationManager.h
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import <Foundation/Foundation.h>

typedef enum CHLLanguages : NSUInteger {
    CHLLanguageYoda,
    CHLLanguageLeet
} CHLLanguages;

@interface CHATranslationManager : NSObject

@property (nonatomic) CHLLanguages currentLanguage;
@property (strong, nonatomic, readonly) NSString *currentLanguageName;

// returns a TranslationManager singleton
+ (id)sharedManager;

// translates given text with the given language
- (NSString *)translate:(NSString *)text to:(CHLLanguages)language;
- (NSString *)translate:(NSString *)text;       // using current language

- (NSString *)nameForLanguage:(CHLLanguages)language;

@end
