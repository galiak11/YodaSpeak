//
//  CHAViewController.m
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import "CHAViewController.h"
#import "CHATranslationManager.h"

@interface CHAViewController ()

@property (strong, nonatomic) NSString *textBeforeEdit;

@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *selectLanguageButton;

@property (weak, nonatomic) IBOutlet UITextView *userTextView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@end

@implementation CHAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup text edit controls
    [self.userTextView setDelegate:self];
    [self.translatedTextView setEditable:NO];

    // setup buttons
    NSString *title = [NSString stringWithFormat:@"Speak %@", [[CHATranslationManager sharedManager] currentLanguageName]];
    [self.speakButton setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegates

- (IBAction)speakButtonTouched:(id)sender {
    [self.view endEditing:YES];

    if ( ! [self.userTextView.text isEqualToString:self.textBeforeEdit]) {
        
        NSString *translatedText = [[CHATranslationManager sharedManager] translate:self.userTextView.text];
        
        [self.translatedTextView setText:translatedText];
        
    }
}

- (IBAction)selectButtonTouched:(id)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textBeforeEdit = [textView text];
    textView.backgroundColor = [UIColor whiteColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.000];
}

@end
