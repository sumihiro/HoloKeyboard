//
//  RoundRectButton.h
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/10.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface RoundRectButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@end
