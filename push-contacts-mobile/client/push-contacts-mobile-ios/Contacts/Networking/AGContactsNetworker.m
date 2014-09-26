/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGContactsNetworker.h"

static NSString * const kAPIBaseURLString = @"<# URL of the Contacts application backend #>";

@interface AGContactsNetworker ()

@property (nonatomic, copy, readwrite) NSString *username;

@end

@implementation AGContactsNetworker

+ (instancetype)shared {
    static AGContactsNetworker *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // construct base URL
        NSURL *baseURL = [[NSURL URLWithString:kAPIBaseURLString] URLByAppendingPathComponent:@"rest"];
        
        _sharedInstance = [[[self class] alloc] initWithBaseURL:baseURL];
        
    });
    
    return _sharedInstance;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    self.username = username;
    
    // set up our request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"/security/user/info"]];
    [request setHTTPMethod:@"GET"];
    
    // apply HTTP Basic:
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    [request setValue:[NSString stringWithFormat:@"Basic %@",
                       [[basicAuthCredentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]]
             forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:completionHandler];
    
    [task resume];
}

- (void)logout:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    // simply do an empty POST on the logout endpoint which will result any
    // cookies held on this session to be wiped out.
    [self POST:@"/security/logout" parameters:nil completionHandler:completionHandler];
}

@end
