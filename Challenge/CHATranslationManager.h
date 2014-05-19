//
//  CHATranslationManager.h
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import <Foundation/Foundation.h>
#import "CHATranslationRequest.h"

@interface CHATranslationManager : CHATranslationRequest

@property (nonatomic) CHALanguages currentLanguage;
@property (strong, nonatomic, readonly) NSString *currentLanguageName;

// returns a TranslationManager singleton
+ (id)sharedManager;

// synchronous translation requests
- (NSString *)translate:(NSString *)text;       // using current language

// asynchronous translation requests
- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock;

@end
