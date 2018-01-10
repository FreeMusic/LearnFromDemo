#import "AFAppDotNetAPIClient.h"

static NSString *SERVER_URL = Localhost;

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", nil];
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"token"]];
        [_sharedClient.requestSerializer setValue:str forHTTPHeaderField:@"x-access-token"];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        //网络请求超时时间
        _sharedClient.requestSerializer.timeoutInterval = 60;
//        NSLog(@"78999----->%@",str);
    });
    
    return _sharedClient;
}
//+ (void) cancleTask {
//    static AFAppDotNetAPIClient *_sharedClient;
//    [_sharedClient invalidateSessionCancelingTasks:YES];
//}
@end







