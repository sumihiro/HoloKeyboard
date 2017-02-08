//
//  KeyboardViewController.h
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import <UIKit/UIKit.h>
#import "HoloDeviceClient.h"

@interface KeyboardViewController : UIViewController

@property (nonatomic,strong) HoloDeviceClient *client;

@end

