//
//  KeyboardViewController.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import "KeyboardViewController.h"
#import <SVProgressHUD.h>

@interface KeyboardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    __weak typeof(self) this = self;
    
    [SVProgressHUD showWithStatus:@"Sending..."];

    NSString *text = textField.text;
    [self.client sendText:text success:^{
        [SVProgressHUD dismiss];
        this.textField.text = nil;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    return NO;
}

@end
