//
//  HoloDeviceClient.h
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import <Foundation/Foundation.h>

typedef void(^HoloDeviceClientLoginSuccess)();
typedef void(^HoloDeviceClientLoginFailure)(NSError *error);

typedef enum : int {
    HoloDeviceClientSpecialCharBackSpace = 0x08,
    HoloDeviceClientSpecialCharTab = 0x09,
    HoloDeviceClientSpecialCharLineFeed = 0x0A,
    HoloDeviceClientSpecialCharCarriageReturn = 0x0D,
    HoloDeviceClientSpecialCharUnitSeparator = 0x1F,
    HoloDeviceClientSpecialCharUnitSpace = 0x20,
} HoloDeviceClientSpecialChar;

typedef int HoloDeviceClientKeyCode;

@interface HoloDeviceClient : NSObject

- (instancetype)initWithHost:(NSString*)host username:(NSString*)username password:(NSString*)password;
- (void)login:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendText:(NSString*)text success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendSpecialChar:(HoloDeviceClientSpecialChar)specialChar success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendUpDownKeyCode:(HoloDeviceClientKeyCode)keyCode success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendUpKeyCode:(HoloDeviceClientKeyCode)keyCode success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendDownKeyCode:(HoloDeviceClientKeyCode)keyCode success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;

@end
