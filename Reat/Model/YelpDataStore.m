//
//  YelpDataStore.m
//  Reat
//
//  Created by yujie cao on 10/21/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import "YelpDataStore.h"
#import "YelpDataModel.h"


@implementation YelpDataStore

+ (YelpDataStore *)sharedInstance {
    static YelpDataStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpDataStore alloc] init];
    });
    return _sharedInstance;
}

@end
