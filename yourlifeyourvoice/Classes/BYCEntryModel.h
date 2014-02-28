#import <Foundation/Foundation.h>

@interface BYCEntryModel : NSObject
@property (nonatomic) NSString *note;
@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) NSArray *reasons;

-(void)addReason:(NSString*)reason;
-(void)removeReason:(NSString*)reason;
@end
