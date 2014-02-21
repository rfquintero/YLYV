#import "BYCSideViewCell.h"
#import "BYCUI.h"

#define kFont [BYCUI roundFontOfSize:20.0f]
#define kPadding 15.0f

@interface BYCSideViewCell()
@property (nonatomic) UILabel *title;
@property (nonatomic) UIView *separator;
@end

@implementation BYCSideViewCell

-(id)initWithReuseIdentifier:(NSString*)identifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.title = [BYCUI labelWithFont:kFont];
        self.title.textColor = [UIColor whiteColor];
        self.title.numberOfLines = 0;
        self.title.textAlignment = NSTextAlignmentCenter;
        
        self.separator = [[UIView alloc] initWithFrame:CGRectZero];
        self.separator.backgroundColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.separator];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.contentView.bounds.size.width;
    [self.title centerInBounds:self.contentView.bounds offsetX:0 offsetY:0 thatFits:CGSizeMake(width-2*kPadding, CGFLOAT_MAX)];
    self.separator.frame = CGRectMake(0, self.contentView.bounds.size.height-1, width, 1);
}

-(void)setTitleText:(NSString*)text {
    self.title.text = text;
    [self setNeedsLayout];
}

-(void)setCellSelected:(BOOL)selected {
    self.title.textColor = selected ? [UIColor orangeColor] : [UIColor whiteColor];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = highlighted ? [[UIColor whiteColor] colorWithAlphaComponent:0.2f] : [UIColor clearColor];
}

+(CGFloat)heightForCellWithWidth:(CGFloat)width text:(NSString*)text {
    UILabel *label = [BYCUI labelWithFont:kFont];
    label.numberOfLines = 0;
    label.text = text;
    return [label sizeThatFits:CGSizeMake(width-2*kPadding, CGFLOAT_MAX)].height + 30;
}

@end
