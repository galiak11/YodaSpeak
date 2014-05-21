//
//  ChallengeTests.m
//  ChallengeTests
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import <XCTest/XCTest.h>
#import "CHATranslationRequest.h"
#import "CHAYodaRequest.h"

@interface ChallengeTests : XCTestCase

@end

@implementation ChallengeTests

#pragma mark - testing TranslationRequest

- (void)testTranslationRequestShouldFailToInitializeWhenNotSubclassed
{
    XCTAssertThrows([[CHATranslationRequest alloc] init], @"TranslationRequest must be subclassed");
}

#pragma mark - testing YodaRequest

- (void)testYodaRequestShouldInitialize
{
    CHAYodaRequest *sut;
    XCTAssertNoThrow((sut = [[CHAYodaRequest alloc] init]), @"YodaRequest must override required methods");
    
    XCTAssertNotNil(sut, @"YodaRequest failed to initialize");
}

- (void)testYodaRequestShouldOverrideLanguageName
{
    CHAYodaRequest *sut = [[CHAYodaRequest alloc] init];
    
    XCTAssertNoThrow([sut languageName], @"YodaRequest must override required methods");
    XCTAssertTrue([[sut languageName] isEqualToString:@"YODA"], @"YodaRequest does not return correct language name");
    
}


@end
