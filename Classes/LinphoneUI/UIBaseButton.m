//
//  UIBaseButton.m
//  linphone
//
//  Created by Alexander van der Werff on 25/05/15.
//
//

#import "UIBaseButton.h"

@interface UIBaseButton()
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation UIBaseButton

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)dealloc {
    [_selectedColor release];
    [_selectedView release];
    [super dealloc];
}

-(void)setup {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.5f;
    self.selectedColor = [UIColor whiteColor];
    self.selectedView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.alpha = 0.0f;
        view.backgroundColor = self.selectedColor;
        view;
    });
    [self insertSubview:self.selectedView belowSubview:self.imageView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.selectedView.frame = self.bounds;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if(highlighted) {
        self.tintColor = UIColorFromRGB(0x1E1D22);
    }
    else {
        self.tintColor = UIColorFromRGB(0xFFFFFF);
    }
}

#pragma mark -
#pragma mark - Button Overides

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    __block UIBaseButton *weakSelf = self;
    [UIView animateWithDuration:0.15 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.selectedView.alpha = 1.0f;
        [weakSelf setHighlighted:YES];
    } completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self fadeOut];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut];
}

- (void)fadeOut
{
    __block UIBaseButton *weakSelf = self;
    [UIView animateWithDuration:0.15
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         weakSelf.selectedView.alpha = 0.0f;
                         [weakSelf setHighlighted:NO];
                     } completion:nil];
}

@end
