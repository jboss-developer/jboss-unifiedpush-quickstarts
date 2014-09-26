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

#import <Foundation/Foundation.h>

extern NSString * const AGRestNetworkerErrorDomain;
extern NSString * const AGNetworkOperationFailingURLRequestErrorKey;
extern NSString * const AGNetworkOperationFailingURLResponseErrorKey;

@interface AGRestNetworker : NSObject

@property (readonly, nonatomic, strong) NSURL *baseURL;
@property (readonly, nonatomic, strong) NSURLSession *session;

- (instancetype)initWithBaseURL:(NSURL *)url;

// convienient RESTful access to resources
- (NSURLSessionDataTask *)GET:(NSString *)resource
                   parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

- (NSURLSessionDataTask *)POST:(NSString *)resource
                    parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

- (NSURLSessionDataTask *)PUT:(NSString *)resource
                   parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

- (NSURLSessionDataTask *)DELETE:(NSString *)resource
                      parameters:(id)parameters
            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;


// utility methods
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
