//
//  UIButton+ContentLayout.m
//  linphone
//
//  Created by Alexander van der Werff on 25/05/15.
//
//

#import "UIButton+ContentLayout.h"



@implementation UIButton (VerticalLayout)

- (void)centerVerticallyWithPadding:(float)padding
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);
    
}


- (void)centerVertically
{
    const CGFloat kDefaultPadding = 6.0f;
    
    [self centerVerticallyWithPadding:kDefaultPadding];
}  


@end
