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

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacer2.width = 10.;

    UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacer3.width = 10.;

    UIBarButtonItem *tab = [[UIBarButtonItem alloc] initWithTitle:@"TAB" style:UIBarButtonItemStylePlain target:self action:@selector(pushTab:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithTitle:@"SPACE" style:UIBarButtonItemStylePlain target:self action:@selector(pushSpace:)];
    UIBarButtonItem *bs = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backspace"] style:UIBarButtonItemStylePlain target:self action:@selector(pushBS:)];
    UIBarButtonItem *enter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"enter"] style:UIBarButtonItemStylePlain target:self action:@selector(pushEnter:)];

    NSArray *items = [NSArray arrayWithObjects:spacer, tab, space, spacer2, bs, spacer3, enter, nil];
    [toolBar setItems:items animated:NO];
    
    // ToolbarをUITextFieldのinputAccessoryViewに設定
    self.textField.inputAccessoryView = toolBar;
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

- (void)pushEnter:(id)sender {
    [self sendSpecialChar:HoloDeviceClientSpecialCharCarriageReturn];
}

- (void)pushBS:(id)sender {
    [self sendSpecialChar:HoloDeviceClientSpecialCharBackSpace];
}

- (void)pushTab:(id)sender {
    [self sendSpecialChar:HoloDeviceClientSpecialCharTab];
}

- (void)pushSpace:(id)sender {
    [self sendSpecialChar:HoloDeviceClientSpecialCharBackSpace];
}

- (void)sendSpecialChar:(HoloDeviceClientSpecialChar)specialChar {
    [SVProgressHUD showWithStatus:@"Sending..."];
    
    [self.client sendSpecialChar:specialChar success:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end
