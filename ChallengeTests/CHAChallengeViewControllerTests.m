//
//  CHAChallengeViewControllerTests.m
//  Challenge
//
//  Created by Galia Kaufman on 5/20/14.
//
//

#import <XCTest/XCTest.h>
#import "CHAChallengeViewControllerTests.m"
#import "CHAViewController.h"

@interface CHAChallengeViewControllerTests : XCTestCase

@end

@implementation CHAChallengeViewControllerTests

- (CHAViewController *)getSut
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    
    CHAViewController *sut = [storyboard instantiateInitialViewController];
    [sut view];    // access the view-conroller's view to force loading the NIB
    
    return sut;
}

- (void)testStoryBoardShouldBeLoaded
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    
    XCTAssertNotNil(storyboard, @"Main storyboard is not loaded");
}

- (void)testViewControllerShouldBeCreated
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    CHAViewController *sut = [storyboard instantiateInitialViewController];
    XCTAssertNotNil(sut, @"CHAViewController is not created");
}

- (void)testViewControllerOutletsShouldBeConnected
{
    CHAViewController *sut = [self getSut];
    
    XCTAssertNotNil([sut speakButton], @"CHAViewController's speakButton outlet is not connected");
    XCTAssertNotNil([sut userTextView], @"CHAViewController's userTextView outlet is not connected");
    XCTAssertNotNil([sut translatedTextView], @"CHAViewController's translatedTextView outlet is not connected");
}

- (void)testViewControllerSpeakButtonShouldHaveAction
{
    CHAViewController *sut = [self getSut];
    
    NSArray *actions = [[sut speakButton] actionsForTarget:sut forControlEvent:UIControlEventTouchUpInside];
    
    XCTAssertTrue([actions count] > 0, @"Speak Button is not connected to an action");
    XCTAssertTrue([actions containsObject:@"speakButtonTouched:"], @"Speak Button is not connected to the action speakButtonTouched:");

    XCTAssertTrue([sut respondsToSelector:@selector(speakButtonTouched:)], @"view controller does not have an action for speakButton");
}

@end
