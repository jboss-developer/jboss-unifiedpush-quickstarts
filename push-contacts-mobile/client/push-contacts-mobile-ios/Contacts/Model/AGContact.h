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

@interface AGContact : NSObject

@property (nonatomic, copy, readwrite) NSNumber *recId;
@property (nonatomic, copy, readwrite) NSString *firstname;
@property (nonatomic, copy, readwrite) NSString *lastname;
@property (nonatomic, copy, readwrite) NSString *phoneNumber;
@property (nonatomic, copy, readwrite) NSString *email;
@property (nonatomic, copy, readwrite) NSString *birthdate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)asDictionary;
    
@end
