//
//  CHAViewController.m
//  Challenge
//
//  Created by Galia Kaufman on 5/17/14.
//
//

#import "CHAViewController.h"

@interface CHAViewController ()

@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *selectLanguageButton;

@property (weak, nonatomic) IBOutlet UITextView *userTextView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@end

@implementation CHAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegates

- (IBAction)speakButtonTouched:(id)sender {
}

- (IBAction)selectButtonTouched:(id)sender {
}

@end
