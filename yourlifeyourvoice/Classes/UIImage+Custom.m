#import "UIImage+Custom.h"

@implementation UIImage (Custom)
-(UIImage*)imageWithColor:(UIColor*)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    
    [color set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

-(UIImage*)disabledImage {
    return [self imageWithColor:[UIColor grayColor]];
}

-(CGFloat)scaledHeightForWidth:(CGFloat)width {
    CGFloat ratio = self.size.height/self.size.width;
    return width*ratio;
}

@end
