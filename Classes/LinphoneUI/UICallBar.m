/* UICallBar.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU Library General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */ 

#import "UICallBar.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "Utils.h"
#import "CAAnimation+Blocks.h"

#include "linphone/linphonecore.h"

@implementation UICallBar

@synthesize pauseButton;
@synthesize conferenceButton;
@synthesize videoButton;
@synthesize microButton;
@synthesize speakerButton;
@synthesize routesButton;
@synthesize optionsButton;
@synthesize hangupButton;
@synthesize routesBluetoothButton;
@synthesize routesReceiverButton;
@synthesize routesSpeakerButton;
@synthesize optionsAddButton;
@synthesize optionsTransferButton;
@synthesize dialerButton;

@synthesize padView;
@synthesize routesView;
@synthesize optionsView;

@synthesize oneButton;
@synthesize twoButton;
@synthesize threeButton;
@synthesize fourButton;
@synthesize fiveButton;
@synthesize sixButton;
@synthesize sevenButton;
@synthesize eightButton;
@synthesize nineButton;
@synthesize starButton;
@synthesize zeroButton;
@synthesize sharpButton;


#pragma mark - Lifecycle Functions

- (id)init {
    return [super initWithNibName:@"UICallBar" bundle:[NSBundle mainBundle]];
}

- (void)dealloc {
    [pauseButton release];
    [conferenceButton release];
    [videoButton release];
    [microButton release];
    [speakerButton release];
    [routesButton release];
    [optionsButton release];
    [routesBluetoothButton release];
    [routesReceiverButton release];
    [routesSpeakerButton release];
    [optionsAddButton release];
    [optionsTransferButton release];
    [dialerButton release];
    
    [oneButton release];
	[twoButton release];
	[threeButton release];
	[fourButton release];
	[fiveButton release];
	[sixButton release];
	[sevenButton release];
	[eightButton release];
	[nineButton release];
	[starButton release];
	[zeroButton release];
	[sharpButton release];
    
    [padView release];
    [routesView release];
    [optionsView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


#pragma mark - ViewController Functions

- (void)viewDidLoad {
    
    optionsView.clipsToBounds = YES;
    
    [pauseButton setType:UIPauseButtonType_CurrentCall call:nil];
    
    [zeroButton setDigit:'0'];
    [zeroButton setDtmf:true];
    
	[oneButton    setDigit:'1'];
    [oneButton setDtmf:true];
    
	[twoButton    setDigit:'2'];
    [twoButton setDtmf:true];
    
    [threeButton  setDigit:'3'];
    [threeButton setDtmf:true];
	
    [fourButton   setDigit:'4'];
    [fourButton setDtmf:true];
	
    [fiveButton   setDigit:'5'];
    [fiveButton setDtmf:true];
	
    [sixButton    setDigit:'6'];
    [sixButton setDtmf:true];
	
    [sevenButton  setDigit:'7'];
    [sevenButton setDtmf:true];
	
    [eightButton  setDigit:'8'];
    [eightButton setDtmf:true];
	
    [nineButton   setDigit:'9'];
    [nineButton setDtmf:true];
	
    [starButton   setDigit:'*'];
    [starButton setDtmf:true];
	
    [sharpButton  setDigit:'#'];
    [sharpButton setDtmf:true];

    
    self.hangupButton.backgroundColor = UIColorFromRGB(0xFB2025);
    self.dialerButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.pauseButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.videoButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.microButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.speakerButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.routesButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.routesBluetoothButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.routesReceiverButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.routesSpeakerButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.optionsButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.optionsAddButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);
    self.optionsTransferButton.backgroundColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.5);

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(callUpdateEvent:) 
                                                 name:kLinphoneCallUpdate
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothAvailabilityUpdateEvent:)
                                                 name:kLinphoneBluetoothAvailabilityUpdate
                                               object:nil];
    // Update on show
    LinphoneCall* call = linphone_core_get_current_call([LinphoneManager getLc]);
    LinphoneCallState state = (call != NULL)?linphone_call_get_state(call): 0;
    [self callUpdate:call state:state];
    [self hideRoutes:FALSE];
    [self hideOptions:FALSE];
    [self hidePad:FALSE];
    [self showSpeaker];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
	if (linphone_core_get_calls_nb([LinphoneManager getLc]) == 0) {
		//reseting speaker button because no more call
		speakerButton.selected=FALSE; 
	}
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    [self callUpdate:call state:state];
}

- (void)bluetoothAvailabilityUpdateEvent:(NSNotification*)notif {
    bool available = [[notif.userInfo objectForKey:@"available"] intValue];
    [self bluetoothAvailabilityUpdate:available];
}


#pragma mark - 

- (void)callUpdate:(LinphoneCall*)call state:(LinphoneCallState)state {  
    LinphoneCore* lc = [LinphoneManager getLc]; 

    [speakerButton update];
    [microButton update];
    [pauseButton update];
    [videoButton update];
    [hangupButton update];
    
    
    // Show Pause/Conference button following call count
    if(linphone_core_get_calls_nb(lc) > 1) {
        if(![pauseButton isHidden]) {
            [pauseButton setHidden:true];
            [conferenceButton setHidden:false];
        }
        bool enabled = true;
        const MSList *list = linphone_core_get_calls(lc);
        while(list != NULL) {
            LinphoneCall *call = (LinphoneCall*) list->data;
            LinphoneCallState state = linphone_call_get_state(call);
            if(state == LinphoneCallIncomingReceived ||
               state == LinphoneCallOutgoingInit ||
               state == LinphoneCallOutgoingProgress ||
               state == LinphoneCallOutgoingRinging ||
               state == LinphoneCallOutgoingEarlyMedia ||
               state == LinphoneCallConnected) {
                enabled = false;
            }
            list = list->next;
        }
        [conferenceButton setEnabled:enabled];
    } else {
        if([pauseButton isHidden]) {
            [pauseButton setHidden:false];
            [conferenceButton setHidden:true];
        }
    }

    // Disable transfert in conference
    if(linphone_core_get_current_call(lc) == NULL) {
        [optionsTransferButton setEnabled:FALSE];
    } else {
        [optionsTransferButton setEnabled:TRUE];
    }
    
    switch(state) {
        case LinphoneCallEnd:
        case LinphoneCallError:
        case LinphoneCallIncoming:
        case LinphoneCallOutgoing:
            [self hidePad:TRUE];
            [self hideOptions:TRUE];
            [self hideRoutes:TRUE];
        default:
            break;
    }
}

- (void)bluetoothAvailabilityUpdate:(bool)available {
    if (available) {
        [self hideSpeaker];
    } else {
        [self showSpeaker];
    }
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}



#pragma mark -

- (void)showAnimation:(NSString*)animationID target:(UIView*)target completion:(void (^)(BOOL finished))completion {
    CGRect frame = [target frame];
    int original_y = frame.origin.y;
    frame.origin.y = [[self view] frame].size.height;
    [target setFrame:frame];
    [target setHidden:FALSE];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setFrame:frame];
                         completion(finished);
                     }];
}

- (void)hideAnimation:(NSString*)animationID target:(UIView*)target completion:(void (^)(BOOL finished))completion {
    CGRect frame = [target frame];
    int original_y = frame.origin.y;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = [target frame];
                         frame.origin.y = [[self view] frame].size.height;
                         [target setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setHidden:TRUE];
                         [target setFrame:frame];
                         completion(finished);
                     }];
}

- (void)showPad:(BOOL)animated {
    [dialerButton setOn];
    
    if([padView isHidden]) {
        
        [self hideOptions:YES];
        
        if(animated) {
            padView.alpha = 0;
            padView.hidden = NO;
            CGRect frame = padView.frame;
            padView.frame = CGRectInset(frame, 20, 20);
            [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                padView.alpha = 1;
                padView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [padView setHidden:FALSE];
        }
    }
}

- (void)hidePad:(BOOL)animated {
    [dialerButton setOff];
    if(![padView isHidden]) {
        
        if(animated) {
            CGRect frame = padView.frame;
            padView.frame = CGRectInset(frame, -20, -20);
            [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                padView.alpha = 0;
                padView.frame = frame;
            } completion:^(BOOL finished) {
                padView.hidden = YES;
            }];
        } else {
            [padView setHidden:TRUE];
        }
    }
}

- (void)showRoutes:(BOOL)animated {
    if (![LinphoneManager runningOnIpad]) {
        [routesButton setOn];
        [routesBluetoothButton setSelected:[[LinphoneManager instance] bluetoothEnabled]];
        [routesSpeakerButton setSelected:[[LinphoneManager instance] speakerEnabled]];
        [routesReceiverButton setSelected:!([[LinphoneManager instance] bluetoothEnabled] || [[LinphoneManager instance] speakerEnabled])];
        if([routesView isHidden]) {
            
            [self hidePad:YES];
            
            if(animated) {

                CGRect frameFrom = self.routesButton.frame;
                CGRect frameTo = self.routesView.frame;
                routesView.alpha = 0;
                routesView.hidden = NO;
                optionsView.frame = frameFrom;
                [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    routesView.alpha = 1;
                    routesView.frame = frameTo;
                } completion:^(BOOL finished) {
                    
                }];
                
            } else {
                [routesView setHidden:FALSE];
            }
        }
    }
}

- (void)hideRoutes:(BOOL)animated {
    if (![LinphoneManager runningOnIpad]) {
        [routesButton setOff];
        if(![routesView isHidden]) {
            if(animated) {

                CGRect frameFrom = self.routesView.frame;
                CGRect frameTo = self.routesButton.frame;
                routesView.hidden = NO;
                routesView.frame = frameFrom;
                [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    routesView.alpha = 0;
                    routesView.frame = frameTo;
                } completion:^(BOOL finished) {
                    routesView.hidden = YES;
                    routesView.frame = frameFrom;
                }];
                
            } else {
                [routesView setHidden:TRUE];
            }
        }
    }
}

- (void)showOptions:(BOOL)animated {
    [optionsButton setOn];
    
    if([optionsView isHidden]) {
        
        [self hidePad:YES];
        
        if(animated) {
            CGRect frameFrom = self.optionsButton.frame;
            CGRect frameTo = self.optionsView.frame;
            optionsView.alpha = 0;
            optionsView.hidden = NO;
            optionsView.frame = frameFrom;
            [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                optionsView.alpha = 1;
                optionsView.frame = frameTo;
            } completion:^(BOOL finished) {
                
            }];

        } else {
            [optionsView setHidden:FALSE];
        }
    }
}

- (void)hideOptions:(BOOL)animated {
    [optionsButton setOff];
    if(![optionsView isHidden]) {
        if(animated) {
            CGRect frameFrom = self.optionsView.frame;
            CGRect frameTo = self.optionsButton.frame;
            optionsView.hidden = NO;
            optionsView.frame = frameFrom;
            [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                optionsView.alpha = 0;
                optionsView.frame = frameTo;
            } completion:^(BOOL finished) {
                optionsView.hidden = YES;
                optionsView.frame = frameFrom;
            }];
        } else {
            [optionsView setHidden:TRUE];
        }
    }
}

- (void)showSpeaker {
    if (![LinphoneManager runningOnIpad]) {
        [speakerButton setHidden:FALSE];
        [routesButton setHidden:TRUE];
    }
}

- (void)hideSpeaker {
    if (![LinphoneManager runningOnIpad]) {
        [speakerButton setHidden:TRUE];
        [routesButton setHidden:FALSE];
    }
}


#pragma mark - Action Functions

- (IBAction)onPadClick:(id)sender {
    if([padView isHidden]) {
        [self showPad:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hidePad:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onRoutesBluetoothClick:(id)sender {
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setBluetoothEnabled:TRUE];
}

- (IBAction)onRoutesReceiverClick:(id)sender {
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setSpeakerEnabled:FALSE];
    [[LinphoneManager instance] setBluetoothEnabled:FALSE];
}

- (IBAction)onRoutesSpeakerClick:(id)sender {
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setSpeakerEnabled:TRUE];
}

- (IBAction)onRoutesClick:(id)sender {
    if([routesView isHidden]) {
        [self showRoutes:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hideRoutes:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onOptionsTransferClick:(id)sender {
    [self hideOptions:TRUE];
    // Go to dialer view   
    DialerViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[DialerViewController compositeViewDescription]], DialerViewController);
    if(controller != nil) {
        [controller setAddress:@""];
        [controller setTransferMode:TRUE];
    }
}

- (IBAction)onOptionsAddClick:(id)sender {
    [self hideOptions:TRUE];
    // Go to dialer view   
    DialerViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[DialerViewController compositeViewDescription]], DialerViewController);
    if(controller != nil) {
        [controller setAddress:@""];
        [controller setTransferMode:FALSE];
    }
}

- (IBAction)onOptionsClick:(id)sender {
    if([optionsView isHidden]) {
        [self showOptions:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hideOptions:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onConferenceClick:(id)sender {
    linphone_core_add_all_to_conference([LinphoneManager getLc]);
}


@end
