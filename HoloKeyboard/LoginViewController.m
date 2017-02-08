//
//  LoginViewController.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import "LoginViewController.h"
#import "HoloDeviceClient.h"
#import "KeyboardViewController.h"

#import <SVProgressHUD.h>

@interface LoginViewController () <UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *loginCell;

@property (nonatomic,strong) HoloDeviceClient *client;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self load];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.ipAddressTextField becomeFirstResponder];
}

- (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.ipAddressTextField.text = [defaults objectForKey:@"ipaddress"];
    self.usernameTextField.text = [defaults objectForKey:@"username"];
    self.passwordTextField.text = [defaults objectForKey:@"password"];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.ipAddressTextField.text forKey:@"ipaddress"];
    [defaults setObject:self.usernameTextField.text forKey:@"username"];
    [defaults setObject:self.passwordTextField.text forKey:@"password"];
    [defaults synchronize];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.loginCell) {
        [self login];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma maek --

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.ipAddressTextField) {
        [self.usernameTextField becomeFirstResponder];
    } else if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self login];
    }
    
    return false;
}

#pragma mark --

- (void)login {
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"Login..."];
    
    HoloDeviceClient *client = [[HoloDeviceClient alloc] initWithHost:self.ipAddressTextField.text
                                                             username:self.usernameTextField.text
                                                             password:self.passwordTextField.text];
    [client login:^{
        [SVProgressHUD dismiss];
        [self save];
        [self performSegueWithIdentifier:@"keyboard" sender:nil];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    self.client = client;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"keyboard"]) {
        KeyboardViewController *vc = (KeyboardViewController*)segue.destinationViewController;
        vc.client = self.client;
    }
}

@end
