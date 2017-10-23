//
//  YelpNetworking.m
//  Reat
//
//  Created by yujie cao on 10/15/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//


#import "YelpNetworking.h"
#import "YelpDataStore.h"
#import "YelpDataModel.h"

typedef void (^TokenPendingTask
              )(NSString *token);
static NSString const * kGrantType = @"client_credentials";
static NSString const * kClient_id = @"4ce6N-BHoTUIvry8-hVfbQ";
static NSString const * kClient_secret = @"xZPavlAlLcyeRd7wjpa0wUP8MnKRCM5fXHIEkgJk45N3a6ZNQ6uihnl1lOIDZHli";
static NSString * const kTokenEndPoint = @"https://api.yelp.com/oauth2/token";
@interface YelpNetworking ()
@property (copy) NSString *token;
@end
@implementation YelpNetworking
+ (YelpNetworking *)sharedInstance {
    static YelpNetworking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpNetworking alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]){
        [self fetchTokenWithTokenTask:nil];
    }
    return self;
}

- (void)fetchTokenWithTokenTask:(TokenPendingTask)tokenTask
{
    NSURL *url = [NSURL URLWithString:kTokenEndPoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@", kGrantType, kClient_id,kClient_secret];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        self.token = dict[@"access_token"];
        if (tokenTask) {
            tokenTask(self.token);
        }
    }];
    [postDataTask resume];
}

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock
{
    TokenPendingTask tokenTask = ^(NSString *token){
        
        NSString *string = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%.6f&longitude=%.6f",term, location.coordinate.latitude, location.coordinate.longitude];
        
        NSString* encodedUrl = [string stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSString *headerToken = [NSString stringWithFormat:@"Bearer %@",self.token];
        [request addValue:headerToken forHTTPHeaderField:@"Authorization"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dict = @{};
            if (data) {
                dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            // we update here
            if (!error) {
                NSArray<YelpDataModel *> *dataModelArray = [YelpDataModel buildDataModelArrayFromDictionaryArray:dict[@"businesses"]];
                [YelpDataStore sharedInstance].dataModels = dataModelArray;
                
                completionBlock(dataModelArray);
            }
        }];
        

        [dataTask resume];
    };
    if (self.token) {
        tokenTask(self.token);
    } else {
        [self fetchTokenWithTokenTask:tokenTask];
    }
}
@end

