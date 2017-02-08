//
//  HoloDeviceClient.h
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import <Foundation/Foundation.h>

typedef void(^HoloDeviceClientLoginSuccess)();
typedef void(^HoloDeviceClientLoginFailure)(NSError *error);

@interface HoloDeviceClient : NSObject

- (instancetype)initWithHost:(NSString*)host username:(NSString*)username password:(NSString*)password;
- (void)login:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;
- (void)sendText:(NSString*)text success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure;

@end
