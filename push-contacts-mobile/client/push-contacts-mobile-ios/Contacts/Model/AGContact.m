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

#import "AGContact.h"

@implementation AGContact

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (!self)
        return nil;
    
    self.recId = dictionary[@"id"];
    self.firstname = dictionary[@"firstName"];
    self.lastname = dictionary[@"lastName"];
    self.email = dictionary[@"email"];
    self.phoneNumber = dictionary[@"phoneNumber"];
    self.birthdate = dictionary[@"birthDate"];
    
    return (self);
}

- (NSMutableDictionary *)asDictionary {
    
    NSMutableDictionary *dictionary = [@{@"firstName": self.firstname,
                                         @"lastName": self.lastname,
                                         @"email": self.email,
                                         @"phoneNumber": self.phoneNumber,
                                         @"birthDate": self.birthdate} mutableCopy];
    
    if (self.recId) {
        dictionary[@"id"] = self.recId;
    }
    
    return dictionary;
}

- (NSComparisonResult)compare:(AGContact *)other {
    // compare by first name
    return [self.firstname compare:other.firstname];
}

@end
