//
//  KeyboardViewController.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import "KeyboardViewController.h"
#import "KeyboaedAccessoryView.h"
#import <SVProgressHUD.h>

@interface KeyboardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    KeyboaedAccessoryView *view = [[[NSBundle mainBundle] loadNibNamed:@"KeyboaedAccessoryView" owner:nil options:0] firstObject];
    __weak typeof(self) this = self;
    view.up = ^(){
        [this sendKeyCode:38];
    };
    view.down = ^(){
        [this sendKeyCode:40];
    };
    view.left = ^(){
        [this sendKeyCode:37];
    };
    view.right = ^(){
        [this sendKeyCode:39];
    };
    view.tab = ^(){
        [this sendKeyCode:9];
    };
    view.reverseTab = ^(){
        // 16 -> 9
        [SVProgressHUD showWithStatus:@"Sending..."];
        
        [this.client sendDownKeyCode:16 success:^{
            [this.client sendUpDownKeyCode:9 success:^{
                [this.client sendUpKeyCode:16 success:^{
                    [SVProgressHUD dismiss];
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    };
    view.space = ^(){
        [self sendSpecialChar:HoloDeviceClientSpecialCharUnitSpace];
    };
    view.enter = ^(){
        [this sendKeyCode:13];
    };
    view.backSpace = ^(){
        [this sendKeyCode:8];
    };
    self.textField.inputAccessoryView = view;
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
    [self sendSpecialChar:HoloDeviceClientSpecialCharUnitSpace];
}

- (void)sendSpecialChar:(HoloDeviceClientSpecialChar)specialChar {
    [SVProgressHUD showWithStatus:@"Sending..."];
    
    [self.client sendSpecialChar:specialChar success:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)sendKeyCode:(HoloDeviceClientKeyCode)keyCode {
    [SVProgressHUD showWithStatus:@"Sending..."];
    
    [self.client sendUpDownKeyCode:keyCode success:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end
