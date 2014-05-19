//
//  CHARequestManager.h
//  Challenge
//
//  Created by Galia Kaufman on 5/18/14.
//
//

#import <Foundation/Foundation.h>


// list of supported languages
typedef enum CHALanguages : NSUInteger {
    CHALanguageYoda,
    CHALanguageLeet
} CHALanguages;

extern NSString * const languageNames[];

typedef void (^CHAStringResultBlock)(NSString* string);


@interface CHATranslationRequest : NSObject

// initialize the request with a specific language
- (id)initWithLanguage:(CHALanguages)language;

// synchronous request to translate text (results is returned as a method return value)
- (NSString *)translate:(NSString *)text;

// asyncronous request to translate text (result is returned as a block parameter)
// note: we only handle string results, for now...
- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock;

// returns given language as a string
+ (NSString *)nameForLanguage:(CHALanguages)language;

@end