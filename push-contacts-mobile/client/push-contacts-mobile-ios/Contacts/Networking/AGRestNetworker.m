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

#import "AGRestNetworker.h"

NSString * const AGRestNetworkerErrorDomain = @"AGRestNetworkerErrorDomain";
NSString * const AGNetworkOperationFailingURLRequestErrorKey = @"AGNetworkingOperationFailingURLRequestErrorKey";
NSString * const AGNetworkOperationFailingURLResponseErrorKey = @"AGNetworkingOperationFailingURLResponseErrorKey";


@interface AGRestNetworker ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@end

@implementation AGRestNetworker

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    
    if (!self)
        return nil;
    
    self.baseURL = url;
    
    // initialize session
    NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // set session default headers
    sessionConfig.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json",
                                            @"Accept": @"application/json"};
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    return (self);
}

- (NSURLSessionDataTask *)GET:(NSString *)resource
                   parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    // set up our request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:resource]];
    [request setHTTPMethod:@"GET"];
    
    // serialize request
    if (parameters) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
    }

    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)resource
                    parameters:(id)parameters
             completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    // set up our request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[_baseURL URLByAppendingPathComponent:resource]];
    [request setHTTPMethod:@"POST"];
    
    // serialize request
    if (parameters) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)resource
                   parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    // set up our request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[_baseURL URLByAppendingPathComponent:resource]];
    [request setHTTPMethod:@"PUT"];
    
    // serialize request
    if (parameters) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)resource
                      parameters:(id)parameters
               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    // set up our request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[_baseURL URLByAppendingPathComponent:resource]];
    [request setHTTPMethod:@"DELETE"];
    
    // serialize request
    if (parameters) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
    
    return task;
}

#pragma mark - util methods

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
            if (httpResp.statusCode == 200 || httpResp.statusCode == 204 /* No content */) { // if success

                id result;
                
                if (data && data.length > 0) {  // if there is actual response, try to deserialize from json
                    result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                }
                
                if (completionHandler) {
                    completionHandler(response, result, error);
                }
                
            } else { // bad response
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:[NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode] forKey:NSLocalizedDescriptionKey];
                [userInfo setValue:request forKey:AGNetworkOperationFailingURLRequestErrorKey];
                [userInfo setValue:response forKey:AGNetworkOperationFailingURLResponseErrorKey];
                
                error = [[NSError alloc] initWithDomain:AGRestNetworkerErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
                
                if (completionHandler) {
                    completionHandler(response, nil, error);
                }
            }
            
        } else { // an error has occured
            if (completionHandler) {
                completionHandler(response, nil, error);
            }
        }
    }];

    return task;
}

@end
