//
//  CHAViewController.m
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import "CHAViewController.h"
#import "CHATranslationManager.h"

#define STANDARD_FONT_COLOR [UIColor colorWithRed:0.153 green:0.190 blue:0.331 alpha:1.000]
#define LIGHT_FONT_COLOR [UIColor colorWithRed:0.549 green:0.549 blue:0.654 alpha:1.000]


@interface CHAViewController ()

@property (strong, nonatomic) NSString *textBeforeEdit;

@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UITextView *userTextView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@end

@implementation CHAViewController

#pragma mark - initialization

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup text edit controls
    [self.userTextView setDelegate:self];
    [self.translatedTextView setEditable:NO];

    // setup buttons
    NSString *title = [NSString stringWithFormat:@"%@ Speak", [[CHATranslationManager sharedManager] currentLanguageName]];
    [self.speakButton setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.textBeforeEdit = nil;
}

#pragma mark - translation

- (void)translateUserText
{
    // check if the text has changed since last time it was translated
    if ( ! [self.userTextView.text isEqualToString:self.textBeforeEdit]) {
        
        self.textBeforeEdit = self.userTextView.text;
        
        [self.translatedTextView setTextColor:LIGHT_FONT_COLOR];
        [self.translatedTextView setText:@" thinking..."];
        
        // hit the translation endpoint and update the restul when it arrives asynchronously
        [[CHATranslationManager sharedManager] translate:self.userTextView.text result:^(NSString *string) {
            
            [self.translatedTextView setText:string ? string : @"Cannot translate"];
            [self.translatedTextView setTextColor:STANDARD_FONT_COLOR];
            
        }];
        
    }
}

#pragma mark - delegates

- (IBAction)speakButtonTouched:(id)sender {
    [self.view endEditing:YES];
    [self translateUserText];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self translateUserText];
    [super touchesBegan:touches withEvent:event];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor whiteColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.000];
}

@end
