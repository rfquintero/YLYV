#import "BYCEntriesCell.h"
#import "BYCMoodView.h"
#import "BYCUI.h"
#import "NSDate+Custom.h"

#define kFaceSize 50.0f

@interface BYCEntriesCell()
@property (nonatomic) BYCMoodView *moodView;
@property (nonatomic) UILabel *mood;
@property (nonatomic) UILabel *note;
@property (nonatomic) UILabel *date;
@end

@implementation BYCEntriesCell

-(id)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        
        self.moodView = [[BYCMoodView alloc] initWithFrame:CGRectZero type:BYCMood_Angry small:YES];
        self.moodView.faceSize = kFaceSize;
        [self.moodView setTextHidden:YES animated:NO];
        
        self.mood = [BYCUI labelWithFontSize:16.0f];
        self.note = [BYCUI labelWithFont:[UIFont boldSystemFontOfSize:14.0f]];
        self.date = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        
        [self.contentView addSubview:self.moodView];
        [self.contentView addSubview:self.mood];
        [self.contentView addSubview:self.note];
        [self.contentView addSubview:self.date];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10.0f;
    CGRect bounds = self.contentView.bounds;
    
    [self.moodView centerVerticallyAtX:padding inBounds:bounds withSize:CGSizeMake(kFaceSize,kFaceSize)];
    
    CGFloat offsetX = CGRectGetMaxX(self.moodView.frame)+padding;
    CGSize textSize = CGSizeMake(bounds.size.width-offsetX-padding, CGFLOAT_MAX);
    CGSize noteSize = [self.note sizeThatFits:textSize];
    [self.note centerVerticallyAtX:offsetX inBounds:bounds withSize:CGSizeMake(textSize.width, noteSize.height)];
    
    CGSize moodSize = [self.mood sizeThatFits:textSize];
    CGSize dateSize = [self.date sizeThatFits:textSize];
    CGFloat moodBaseline = self.note.hidden ? self.moodView.center.y : self.note.frame.origin.y;
    CGFloat dateBaseline = self.note.hidden ? self.moodView.center.y : CGRectGetMaxY(self.note.frame);

    self.mood.frame = CGRectMake(offsetX, moodBaseline-moodSize.height, textSize.width, moodSize.height);
    self.date.frame = CGRectMake(offsetX, dateBaseline, textSize.width, dateSize.height);
}

-(void)setEntry:(BYCEntry*)entry {
    [self.moodView setType:entry.type];
    self.mood.text = [BYCMood moodString:entry.type];
    self.note.text = entry.note;
    self.note.hidden = entry.note.length == 0;
    self.date.text = [entry.createdAt timeAgo];
    [self setNeedsLayout];
}

@end
