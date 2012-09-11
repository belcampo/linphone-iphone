/* BuschJaegerWelcomeView.m
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "BuschJaegerWelcomeView.h"
#import "BuschJaegerMainView.h"

@implementation BuschJaegerWelcomeView

@synthesize settingsButton;
@synthesize historyButton;
@synthesize tableController;

#pragma mark - Lifecycle Functions

- (void)dealloc {
    [settingsButton release];
    [historyButton release];
    [tableController release];
    
    // Remove all observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


#pragma mark - ViewController Functions

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateConfiguration:[LinphoneManager instance].configuration];
    [tableController.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configurationUpdateEvent:)
                                                 name:kLinphoneConfigurationUpdate
                                               object:nil];
}

- (void)vieWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneConfigurationUpdate
                                                  object:nil];
}


#pragma mark - Event Functions

- (void)configurationUpdateEvent: (NSNotification*) notif {
    BuschJaegerConfiguration *configuration = [notif.userInfo objectForKey:@"configuration"];
    [self updateConfiguration:configuration];
}

- (void)updateConfiguration:(BuschJaegerConfiguration *)configuration {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [tableController setStations:[configuration.outdoorStations sortedArrayUsingDescriptors:sortDescriptors]];
    [historyButton setEnabled: configuration.network.localAddress != nil];
}


#pragma mark - 

- (IBAction)settingsClick:(id)sender {
    [[BuschJaegerMainView instance].navigationController  pushViewController:[BuschJaegerMainView instance].settingsView animated:FALSE];
}

- (IBAction)historyClick:(id)sender {
    [[BuschJaegerMainView instance].historyView reload];
    [[BuschJaegerMainView instance].navigationController  pushViewController:[BuschJaegerMainView instance].historyView animated:FALSE];
}

@end