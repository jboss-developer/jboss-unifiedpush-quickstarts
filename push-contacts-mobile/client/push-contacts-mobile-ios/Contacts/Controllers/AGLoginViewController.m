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

#import "AGLoginViewController.h"
#import "AGContactsNetworker.h"
#import "AGUser.h"

#import <AeroGearPush/AeroGearPush.h>

@interface AGLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (nonatomic) IBOutlet UIBarButtonItem *loginButtonBarItem;

@property (nonatomic) UIBarButtonItem *activityIndicatorBarItem;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

- (IBAction)login:(id)sender;

@end

@implementation AGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup progress view
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityIndicatorBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];

}

#pragma mark - Action methods

- (IBAction)login:(id)sender {
    NSString *username = self.usernameTxtField.text;
    NSString *password = self.passwordTxtField.text;
    
    // check if the fields are empty
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Required fields missing!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // show progress view
    [self startProgressAnimation];
    
    // attempt to login to backend
    [[AGContactsNetworker shared] loginWithUsername:username password:password
                                  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        if (!error) { // success
            
            // time to register user with the "AeroGear UnifiedPush Server"
            
            // initialize "Registration helper" object using the
            // base URL where the "AeroGear Unified Push Server" is running.
            AGDeviceRegistration *registration = [[AGDeviceRegistration alloc]
                                                  initWithServerURL:[NSURL URLWithString:@"<# URL of the running AeroGear UnifiedPush Server #>"]];
            
            // perform registration of this device
            [registration registerWithClientInfo:^(id<AGClientDeviceInformation> clientInfo) {
                // set up configuration parameters
                
                // retrieve the deviceToken
                NSData *deviceToken = [[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"];
                // set it
                [clientInfo setDeviceToken:deviceToken];
                
                // You need to fill the 'Variant Id' together with the 'Variant Secret'
                // both received when performing the variant registration with the server.
                // See section "Register an iOS Variant" in the guide:
                // http://aerogear.org/docs/guides/aerogear-push-ios/unified-push-server/
                [clientInfo setVariantID:@"<# Variant Id #>"];
                [clientInfo setVariantSecret:@"<# Variant Secret #>"];
                
                // --optional config--
                // set some 'useful' hardware information params
                UIDevice *currentDevice = [UIDevice currentDevice];
                
                [clientInfo setOperatingSystem:[currentDevice systemName]];
                [clientInfo setOsVersion:[currentDevice systemVersion]];
                [clientInfo setDeviceType: [currentDevice model]];
                
            } success:^() {
                // successfully registered!
                NSLog(@"successfully registered with UPS!");
                
                // if we reach here, time to move to the main Contacts view
                [self performSegueWithIdentifier:@"ContactsViewSegue" sender:self];
                
                [self stopProgressAnimation];
                
            } failure:^(NSError *error) {
                // An error occurred during registration.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"Failed to register with UPS!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Bummer"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
                [self stopProgressAnimation];
            }];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self stopProgressAnimation];
        }
    }];
}

#pragma mark - Utility methods to display progress view

- (void)startProgressAnimation {
    // assign the progress view to the navigator controller
    self.navigationItem.rightBarButtonItem = self.activityIndicatorBarItem;
    
    [self.activityIndicator startAnimating];
}

- (void)stopProgressAnimation {
    [self.activityIndicator stopAnimating];

    // replace with login button upon stop
    self.navigationItem.rightBarButtonItem = self.loginButtonBarItem;
}

@end
