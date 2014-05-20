//
//  CHAChallengeAsyncTests.m
//  Challenge
//
//  Created by Galia Kaufman on 5/20/14.
//
//

#import <XCTest/XCTest.h>
#import "CHATranslationRequest.h"
#import "CHATranslationManager.h"
#import "CHAViewController.h"
#import "XCTestCase+AsyncTesting.h"

@interface CHAChallengeServiceTests : XCTestCase

@end

// Extracting all tests which are dependent on endpoint availability

@implementation CHAChallengeServiceTests

#pragma mark - testing TranslationRequest

// Note: testing for exact translation might make this test too frgile, since we have no control over what the service returns. Instead, we only test that the restult is some string.
- (void)testTranslationRequestTranslationShouldReturnDifferentText
{
    CHATranslationRequest *sut = [[CHATranslationRequest alloc] initWithLanguage:CHALanguageYoda];
    
    NSString *textToTranslate = @"You will learn how to speak like me someday.";
    NSString *translatedText = [sut translate:textToTranslate];
    
    XCTAssertTrue([translatedText isKindOfClass:[NSString class]], @"Text translation is not a string");
    XCTAssertFalse([textToTranslate isEqualToString:translatedText], @"Text not translated");
    
}

- (void)testTranslationRequestNonBlockingTranslationShouldReturnDifferentText
{
    CHATranslationRequest *sut = [[CHATranslationRequest alloc] initWithLanguage:CHALanguageYoda];
    
    NSString *textToTranslate = @"You will learn how to speak like me someday.";
    
    [sut translate:textToTranslate result:^(NSString *string) {
        
        NSString *translatedText = string;
        
        BOOL translatedTextIsString = [translatedText isKindOfClass:[NSString class]];
        BOOL translatedTextIsDifferentString = ![textToTranslate isEqualToString:translatedText];
        
        if (translatedTextIsString && translatedTextIsDifferentString)
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        else
            [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    
    NSLog(@"Wait... YODA is translating...");
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:15.0];
    
}

#pragma mark - testing TranslationManager

- (void)testTranslationManagerNonBlockingTranslationShouldReturnDifferentText
{
    CHATranslationManager *sut = [CHATranslationManager sharedManager];
    
    NSString *textToTranslate = @"You will learn how to speak like me someday.";
    
    [sut translate:textToTranslate result:^(NSString *string) {
        
        NSString *translatedText = string;
        
        BOOL translatedTextIsString = [translatedText isKindOfClass:[NSString class]];
        BOOL translatedTextIsDifferentString = ![textToTranslate isEqualToString:translatedText];
        
        if (translatedTextIsString && translatedTextIsDifferentString)
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        else
            [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    
    NSLog(@"Wait... YODA is translating...");
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:60.0];
    
}

#pragma mark - testing Challenge View Controller

- (void)testViewControllerSpeakButtonShouldTranslateUserText
{
    // get sut;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    
    CHAViewController *sut = [storyboard instantiateInitialViewController];
    [sut view];    // access the view-conroller's view to force loading the NIB

    sut.userTextView.text = @"You will learn how to speak like me someday";
    NSString *beforeTranslation = sut.translatedTextView.text;
    
    // invoke speak action
    if ([sut respondsToSelector:@selector(speakButtonTouched:)]) {
        [sut speakButtonTouched:nil];

        [self waitForTimeout:20.0];
        
        XCTAssertFalse([sut.translatedTextView.text isEqualToString:@""] || [sut.translatedTextView.text isEqualToString:beforeTranslation], @"timeout ended while text is not translated");
    
    } else
        XCTFail(@"speakButton is not connected to speakButtonTouched: action");

}



@end
