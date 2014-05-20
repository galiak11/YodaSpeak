//
//  CHAViewController.h
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import <UIKit/UIKit.h>

@interface CHAViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UITextView *userTextView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

- (IBAction)speakButtonTouched:(id)sender;

@end
