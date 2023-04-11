//
//  YTImageTool.h
//  AvoidCrash
//
//  Created by jianglinshan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageSaveTool : NSObject

/// 以PNG格式保存一个image
/// @param image 目标image
/// @param imagePath 目标路径（包括文件名）
+ (BOOL)saveImagePNG:(UIImage*)image imagePath:(NSString*)imagePath;

/// 以JPEG格式保存一个image
/// @param image 目标image
/// @param quality 保存质量0～1
/// @param imagePath 目标路径（包括文件名）
+ (BOOL)saveImageJPEG:(UIImage*)image quality:(CGFloat)quality imagePath:(NSString*)imagePath;

@end

NS_ASSUME_NONNULL_END
