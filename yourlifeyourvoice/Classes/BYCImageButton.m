#import "BYCImageButton.h"
#import "UIImage+Custom.h"

@interface BYCImageButton()
@property (nonatomic, readwrite) UIImageView *customImage;
@property (nonatomic) UIImage *enabledImage;
@property (nonatomic) UIImage *disabledImage;
@end

@implementation BYCImageButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.customImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.customImage.contentMode = UIViewContentModeCenter;
        
        [self addSubview:self.customImage];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.customImage.frame = self.bounds;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(highlighted) {
        self.customImage.image = self.disabledImage;
    } else {
        self.customImage.image = self.enabledImage;
    }
}

-(void)setImage:(UIImage*)image {
    self.customImage.image = image;
    self.enabledImage = image;
    self.disabledImage = [image disabledImage];
    [self setNeedsLayout];
}

-(CGSize)sizeThatFits:(CGSize)size {
    return [self.customImage sizeThatFits:size];
}

-(void)setImageTransform:(CGAffineTransform)transform {
    self.customImage.transform = transform;
}

@end
