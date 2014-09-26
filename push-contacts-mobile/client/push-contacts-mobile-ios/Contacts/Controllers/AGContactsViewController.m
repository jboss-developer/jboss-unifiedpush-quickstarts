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

#import "AGContactsViewController.h"
#import "AGContactsNetworker.h"
#import "AGContact.h"

@interface AGContactsViewController ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *contacts;
@property (readwrite, nonatomic, strong) NSMutableArray *filteredContacts;

@property (readwrite, nonatomic, strong) NSMutableArray *contactsSectionTitles;

@property (weak, nonatomic) IBOutlet UISearchBar *contactsSearchBar;

- (IBAction)logoutPressed:(id)sender;

@end

@implementation AGContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup "pull to refresh" control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // hide the back button, logout button is used instead
    self.navigationItem.hidesBackButton = YES;
    
     // load initial data
    [self refresh];
}

#pragma mark - Remote Notification handler methods

- (void)performFetchWithUserInfo:(NSDictionary *)userinfo completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // extract the id from the notification
    NSNumber *recId = [NSNumber numberWithInteger:[userinfo[@"id"] integerValue]];
    
    // Note: in case the user created the contact locally, a notification will still be received by the server
    //       Since we have already added, no need to fetch it again so simple return
    if ([self contactWithId:recId] != nil)  // if exists
        return;
    
    [[AGContactsNetworker shared] GET:[NSString stringWithFormat:@"/contacts/%@", recId] parameters:nil
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        
                        if (error) { // if an error occured
                            NSLog(@"%@", error);
                            
                            // IMPORTANT:
                            // always let the system know we are done so 'UI snapshot' can be taken
                            completionHandler(UIBackgroundFetchResultFailed);
                            
                        } else { // success
                            
                            AGContact *contact = [[AGContact alloc] initWithDictionary:responseObject];
                            
                            // add to model
                            [self addContact:contact];
                            
                            // refresh tableview
                            [self.tableView reloadData];
                            
                            // IMPORTANT:
                            // always let the system know we are done so 'UI snapshot' can be taken
                            completionHandler(UIBackgroundFetchResultNewData);
                        }
                    }];
}

- (void)displayDetailsForContactWithId:(NSNumber *)recId {
    // determine the Contact given the id
    AGContact *contact = [self contactWithId:recId];
    
    if (contact) { // if found
        // display details screen
        [self performSegueWithIdentifier:@"EditContactSegue" sender:contact];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.contactsSectionTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return self.contactsSectionTitles[section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredContacts count];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[section];
        
        return [self.contacts[sectionTitle] count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        // user-locale alphabet list
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.contactsSectionTitles indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];

    AGContact *contact;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = self.filteredContacts[indexPath.row];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section];
        contact = self.contacts[sectionTitle][indexPath.row];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
    cell.detailTextLabel.text = contact.email;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"EditContactSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - Table delete

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AGContact *contact;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = self.filteredContacts[indexPath.row];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section] ;
        contact = self.contacts[sectionTitle][indexPath.row];
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // attempt to delete
        [[AGContactsNetworker shared] DELETE:[NSString stringWithFormat:@"/contacts/%@", contact.recId] // append contact id
                                  parameters:[contact asDictionary] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

            if (error) { // if an error occured
                NSLog(@"%@", error);

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Bummer"
                                                      otherButtonTitles:nil];
                [alert show];

            } else { // success

                // the section that this contact resides
                NSString *section = self.contactsSectionTitles[indexPath.section];
                // the contacts in that section
                NSMutableArray *contacts = self.contacts[section];

                // the path to the contact
                NSArray *path = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];

                // time to delete
                
                // we need to determine the index of the contact in the model
                __block NSInteger index;

                // if delete was performed under search mode
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    // remove from filtered local model
                    [self.filteredContacts removeObjectAtIndex:indexPath.row];

                    // determine the row of local model using the contact id
                    [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        AGContact *current = (AGContact *)obj;

                        if ([contact.recId isEqualToNumber:current.recId]) {
                            index = idx;
                            *stop = YES; // no need to continue
                        }
                    }];

                } else {
                    // the row in the local model that this contact resides
                    index = indexPath.row;
                }

                // time to delete it from local model
                [contacts removeObjectAtIndex:index];

                // remove it from the appropriate tableview
                [tableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationTop];

                // if it was the last contact in the section, delete the section too
                if (contacts.count == 0) {
                    [self.contactsSectionTitles removeObject:section];
                    [self.contacts removeObjectForKey:section];
                }
                
                [tableView reloadData];
            }
        }];
    }
}

#pragma mark - AGContactDetailsViewControllerDelegate methods

- (void)contactDetailsViewControllerDidCancel:(AGContactDetailsViewController *)controller {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactDetailsViewController:(AGContactDetailsViewController *)controller didSave:(AGContact *)contact {
    // since completionhandler logic is common, define upfront
    id completionHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {

        if (error) { // if an error occured
            
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // dismiss modal dialog
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // add to our local modal
            if (!contact.recId) {
                contact.recId = responseObject[@"id"];
                
                [self addContact:contact];
            }
            
            // ask table to refresh
            if (self.searchDisplayController.active) {
                [self.searchDisplayController.searchResultsTableView reloadData];
            } else {
                [self.tableView reloadData];
            }
        }
    };

    if (contact.recId) { // update existing
        [[AGContactsNetworker shared] PUT:[NSString stringWithFormat:@"/contacts/%@", contact.recId] // append contact id
                               parameters:[contact asDictionary] completionHandler:completionHandler];
        
    } else { // create new
        [[AGContactsNetworker shared] POST:@"/contacts" parameters:[contact asDictionary] completionHandler:completionHandler];
    }
}

# pragma mark - Actions

- (void)refresh {
    [[AGContactsNetworker shared] GET:@"/contacts" parameters:nil
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

            [self.refreshControl endRefreshing];
                        
            if (error) { // if an error occured
                
                NSLog(@"%@", error);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Bummer"
                                                      otherButtonTitles:nil];
                [alert show];
                
            } else { // success

                self.contacts = [[NSMutableDictionary alloc] init];
                
                [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AGContact *contact = [[AGContact alloc] initWithDictionary:obj];
                    
                    [self addContact:contact];
                    
                }];
                            
                // refresh section alphabet
                self.contactsSectionTitles = [[self.contacts allKeys] mutableCopy];
                [self.contactsSectionTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                            
                [self.tableView reloadData];
            }
        }];
}

- (IBAction)logoutPressed:(id)sender {
    [[AGContactsNetworker shared] logout:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) { // if an error occured
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // back to login screen
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredContacts removeAllObjects];
    
    // will store the filtered results
    NSMutableArray *results;
    
    // the predicate to search
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname CONTAINS[c] $name OR lastname CONTAINS[c] $name"];
    
    // apply predicate
    NSArray *collapsedContacts = [[self.contacts allValues] valueForKeyPath:@"@unionOfArrays.self"];
    results = [[collapsedContacts filteredArrayUsingPredicate:
                [predicate predicateWithSubstitutionVariables:@{@"name": searchText}]] mutableCopy];
    
    self.filteredContacts = results;
}

#pragma mark - UISearchBarDelegate Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.tableView reloadData];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

#pragma mark - Seque methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddContactSegue"] || [segue.identifier isEqualToString:@"EditContactSegue"]) {
        // for both "Add" and "Edit" mode, attach delegate to self
        UINavigationController *navigationController = segue.destinationViewController;
        AGContactDetailsViewController *contactDetailsViewController = [navigationController viewControllers][0];
        contactDetailsViewController.delegate = self;
        
        // for "Edit", pass the Contact to the controller
        if ([segue.identifier isEqualToString:@"EditContactSegue"]) {
            
            // determine the 'sender'
            AGContact *contact;

            // if instance is a cell (which means it was clicked) determine AGContact from cell
            if ([sender isKindOfClass:[UITableViewCell class]])
                contact = [self activeContactFromCell:sender];
            else // // otherwise a straight AGContact instance was passed (manually asked to display a contact)
                contact = (AGContact *)sender;
            
            // assign it
            contactDetailsViewController.contact = contact;
        }
    }
}

#pragma mark - utility method

- (AGContact *)activeContactFromCell:(UITableViewCell *)cell {
    AGContact *contact;
    
    if (self.searchDisplayController.active) { // if we are in 'search' mode
        // retrieve active contact from search tableview
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
        contact = self.filteredContacts[indexPath.row];
    } else {
        // just normal tableview
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section];
        contact = self.contacts[sectionTitle][indexPath.row];
    }

    return contact;
}

- (void)addContact:(AGContact *)contact {
    // determine section by first letter of "first name"
    NSString *letter = [[contact.firstname substringToIndex:1] uppercaseString];
    NSMutableArray *contactsInSection = self.contacts[letter];
    
    // if the section doesn't exist
    if (!contactsInSection) {
        // create it
        [self.contactsSectionTitles addObject:letter];
        // sort newly inserted section name
        [self.contactsSectionTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // create arr to hold contacts in section
        contactsInSection = [[NSMutableArray alloc] init];
        
        // assign
        self.contacts[letter] = contactsInSection;
    }
    
    /// add it
    [contactsInSection addObject:contact];
    // sort contacts "section" by "first name" (see :compare on AGContact)
    [contactsInSection sortUsingSelector:@selector(compare:)];
}

- (AGContact *)contactWithId:(NSNumber *)recId {
    // collapse all contacts
    NSArray *collapsedContacts = [[self.contacts allValues] valueForKeyPath:@"@unionOfArrays.self"];
    // search for given id
    NSArray *results = [collapsedContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"recId == %@", recId]];
    
    // if found
    if (results.count == 1)
        return results[0];
    
    return nil;
}

@end
