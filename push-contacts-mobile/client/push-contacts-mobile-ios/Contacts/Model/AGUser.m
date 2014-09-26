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

#import "AGUser.h"

@implementation AGUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (!self)
        return nil;
    
    self.firstname = dictionary[@"firstName"];
    self.lastname = dictionary[@"lastName"];
    self.username = dictionary[@"loginName"];
    self.password = dictionary[@"password"];
    
    return (self);
}

- (NSDictionary *)asDictionary {
    NSDictionary *dictionary = @{@"firstName": self.firstname,
                                 @"lastName": self.lastname,
                                 @"userName": self.username,
                                 @"password": self.password};
    
    return dictionary;
}

@end
