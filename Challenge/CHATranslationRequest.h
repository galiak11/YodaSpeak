//
//  CHARequestManager.h
//  Challenge
//
//  Created by Galia Kaufman on 5/18/14.
//
//

#import <Foundation/Foundation.h>


// translation result block for non-blocking requests.
// note: we only handle string results, for now...
typedef void (^CHAStringResultBlock)(NSString* string);


@interface CHATranslationRequest : NSObject

// a string representation of current language
@property (strong, nonatomic, readonly) NSString *languageName;

// synchronous request to translate text (result is returned as a method return value)
- (NSString *)translate:(NSString *)text;

// asyncronous request to translate text (result is returned as a block parameter)
// note: we only handle string results, for now...
- (void)translate:(NSString *)text result:(CHAStringResultBlock)resultBlock;

@end


// protected properties - available to subclasses only:

#ifdef BaseClass_protected

@interface CHATranslationRequest ()

@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *urlFormat;


@end

#endif