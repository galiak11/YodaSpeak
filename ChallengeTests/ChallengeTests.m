//
//  ChallengeTests.m
//  ChallengeTests
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import <XCTest/XCTest.h>
#import "CHATranslationRequest.h"
#import "CHATranslationManager.h"

@interface ChallengeTests : XCTestCase

@end

@implementation ChallengeTests

#pragma mark - testing TranslationRequest

- (void)testTranslationRequestInitializedWithUnsupportedLanguageShouldBeNull
{
    CHATranslationRequest *sut = [[CHATranslationRequest alloc] initWithLanguage:CHALanguageLeet];
    
    XCTAssertNil(sut, @"TranslationRequest initialized with nnsupported language does not return nil");
}

- (void)testTranslationRequestInitializedWithSupportedLanguageShouldHaveCorrectLanguageName
{
    CHATranslationRequest *sut = [[CHATranslationRequest alloc] initWithLanguage:CHALanguageYoda];
    
    XCTAssertTrue([[sut languageName] isEqualToString:@"YODA"], @"TranslationRequest does not return correct language name");
    
}


#pragma mark - testing TranslationManager

- (void)testTranslationManagerIsASinglton
{
    CHATranslationManager *sut = [CHATranslationManager sharedManager];
    
    XCTAssertEqualObjects(sut, [CHATranslationManager sharedManager], @"TranslationManager is not a singlton: different objects are returned each call to sharedManager.");
}

- (void)testTranslationManagerShouldReturnCurrentLanguageName
{

    NSString *languageName = [[CHATranslationManager sharedManager] currentLanguageName];
    
    XCTAssertTrue([languageName isEqualToString:@"YODA"], @"TranslationManager does not return correct languag name");
}


@end
