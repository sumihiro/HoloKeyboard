//
//  HoloDeviceClient.m
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/08.
//

#import "HoloDeviceClient.h"

@interface HoloDeviceClient () <NSURLSessionDelegate>

@property (nonatomic,copy) NSString *host;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@property (nonatomic,strong) NSURL *baseUrl;
@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,copy) NSString *token;

@end

@implementation HoloDeviceClient


- (instancetype)initWithHost:(NSString*)host username:(NSString*)username password:(NSString*)password {
    self = [super init];
    if (self) {
        self.host = host;
        self.username = username;
        self.password = password;
        
        self.baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@",self.host]];

        NSString *authString = [NSString stringWithFormat:@"%@:%@",
                                self.username,
                                self.password];
        NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authHeader = [NSString stringWithFormat: @"Basic %@",
                                [authData base64EncodedStringWithOptions:0]];
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:@{
                                                  @"Authorization": authHeader
                                                  }
         ];
        self.session =
        [NSURLSession sessionWithConfiguration:sessionConfig delegate:self
                                 delegateQueue:nil];

    }
    return self;
}

- (void)login:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure {
    __weak typeof(self) this = self;
    
    NSURL *url = self.baseUrl;
    [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response) {
            NSDictionary *fields = [(NSHTTPURLResponse*)response allHeaderFields];
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:response.URL];
            
            for (NSHTTPCookie *cookie in cookies) {
                if ([cookie.name isEqualToString:@"CSRF-Token"]) {
                    NSString *token = cookie.value;
                    self.token = token;
                    
                }
            }
        }

        [this  handleResponseError:(NSHTTPURLResponse*)response error:error success:success failure:failure];
    }] resume];
}

- (void)sendText:(NSString*)text success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure {
    __weak typeof(self) this = self;
    
    NSString *encoded = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *dataText = [NSString stringWithFormat:@"api/holographic/input/keyboard/text?text=%@",encoded];

    NSURL *url = [NSURL URLWithString:dataText relativeToURL:self.baseUrl];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self appendCSRFFieldToRequest:request];
    [request setHTTPMethod:@"POST"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [this  handleResponseError:(NSHTTPURLResponse*)response error:error success:success failure:failure];
    }] resume];
}

- (void)appendCSRFFieldToRequest:(NSMutableURLRequest*)request {
    NSAssert(self.token != nil, @"CSRF token not found.");

    NSDictionary *headers = self.session.configuration.HTTPAdditionalHeaders;
    NSMutableDictionary *mdic = [headers mutableCopy];
    mdic[@"X-CSRF-Token"] = self.token;
    request.allHTTPHeaderFields = mdic;
}


- (void)handleResponseError:(NSHTTPURLResponse*)response error:(NSError*)error success:(HoloDeviceClientLoginSuccess)success failure:(HoloDeviceClientLoginFailure)failure {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    } else if(response.statusCode != 200) {
        NSError *error = [NSError errorWithDomain:@"error" code:response.statusCode userInfo:@{@"response":response}];
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    }
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    NSLog(@"challenge");
    
    if (challenge.previousFailureCount > 1) {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }else {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username
                                                                 password:self.password
                                                              persistence:NSURLCredentialPersistenceForSession];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

@end
