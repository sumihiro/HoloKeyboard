//
//  RoundRectButton.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/10.
//

#import "RoundRectButton.h"

@implementation RoundRectButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    self.cornerRadius = 4.;
    self.borderColor = self.tintColor;
    self.borderWidth = 1.;
}

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    
    [super drawRect:rect];
}
@end
