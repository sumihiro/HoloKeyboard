//
//  KeyboaedAccessoryView.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/10.
//

#import "KeyboaedAccessoryView.h"

@implementation KeyboaedAccessoryView

- (IBAction)pushBackSpace:(id)sender {
    self.backSpace();
}
- (IBAction)pushReverseTab:(id)sender {
    self.reverseTab();
}
- (IBAction)pushTab:(id)sender {
    self.tab();
}
- (IBAction)pushUp:(id)sender {
    self.up();
}
- (IBAction)pushLeft:(id)sender {
    self.left();
}
- (IBAction)pushDown:(id)sender {
    self.down();
}
- (IBAction)pushRight:(id)sender {
    self.right();
}
- (IBAction)pushSpace:(id)sender {
    self.space();
}
- (IBAction)pushEnter:(id)sender {
    self.enter();
}

@end
