//
//  ToolBarButton.m
//  linphone
//
//  Created by Alexander van der Werff on 25/05/15.
//
//

#import "ToolBarButton.h"
#import "UIButton+ContentLayout.h"

@interface ToolBarButton()
@property (nonatomic, strong) UIColor *baseColor;
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation ToolBarButton

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)dealloc
{
    [_baseColor release];
    [_selectedColor release];
    [super dealloc];
}

-(void)setup
{
    [self.titleLabel setTextAlignment: NSTextAlignmentCenter];
    [self centerVerticallyWithPadding:4];
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    self.baseColor = UIColorFromRGB(0x1E1D22);
    self.selectedColor = UIColorFromRGB(0xCF4C29);
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected == YES) {
        self.tintColor = self.selectedColor;
    }
    else {
        self.tintColor = self.baseColor;
    }
}

@end
