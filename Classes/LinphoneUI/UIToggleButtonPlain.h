//
//  UIToggleButtonPlain.h
//  linphone
//
//  Created by Alexander van der Werff on 17/08/15.
//
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"

@interface UIToggleButtonPlain : UIButton <UIToggleButtonDelegate> {
    
}

- (bool)update;
- (void)setOn;
- (void)setOff;
- (bool)toggle;
@end
