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

#import "AGAppDelegate.h"

#import "AGContactsViewController.h"

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // register with Apple Push Notification Service (APNS) to retrieve the device token.
    
    // when running under iOS 8 we will use the new API for APNS registration
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    
    return YES;
}

#pragma mark - Push Notification handling

// // Callback called after successfully registration with APNS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // convenient store the "device token" for later retrieval
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
}

// Callback called after failing to register with APNS
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Log the error for now
    NSLog(@"APNs Error: %@", error);
}

// Callback called after receiving push notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
   
    // ensure the user has logged in
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    id topViewController = navigationController.topViewController;

     // are we logged in ?
    if ([topViewController isKindOfClass:[AGContactsViewController class]]) {
        
        // if the user clicked the notification, we know that the Contact
        // has already been fetched so we just ask the controller to
        // display the details screen for this Contact.
        if (application.applicationState == UIApplicationStateInactive) {
            [(AGContactsViewController *)topViewController displayDetailsForContactWithId:
                                                            [NSNumber numberWithInteger:[userInfo[@"id"] integerValue]]];
        } else { // fetch it
            // attempt to fetch new contact
            [(AGContactsViewController *)topViewController performFetchWithUserInfo:userInfo completionHandler:completionHandler];
        }
    }
}

@end
