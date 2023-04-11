//
//  YTImageTool.m
//  AvoidCrash
//
//  Created by jianglinshan on 2021/8/30.
//

#import "ImageSaveTool.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation ImageSaveTool
+ (BOOL)saveImagePNG:(UIImage*)image imagePath:(NSString*)imagePath
{
    return [self _saveImage:image isJPEG:NO quality:1 imagePath:imagePath];
}

+ (BOOL)saveImageJPEG:(UIImage *)image quality:(CGFloat)quality imagePath:(NSString *)imagePath
{
    return [self _saveImage:image isJPEG:YES quality:quality imagePath:imagePath];
}

+ (BOOL)_saveImage:(UIImage *)image isJPEG:(BOOL)isJPEG quality:(CGFloat)jpegQuality imagePath:(NSString *)imagePath
{
    if (!image || !imagePath) return NO;
    /// 构造一个自动释放池，及时释放内存，无需等待当前runloop循环结束。
    @autoreleasepool {
        /// 构造保存URL
        NSURL* fileUrl = [NSURL fileURLWithPath:imagePath];
        CFURLRef url = (__bridge CFURLRef)fileUrl;
        
        /// 构造保存参数
        CFStringRef type = kUTTypePNG;
        CFDictionaryRef params = nil;
        if (isJPEG) {
            type = kUTTypeJPEG;
            jpegQuality = MAX(MIN(1, jpegQuality), 0);
            NSDictionary* mutableDict = @{(__bridge NSString*)kCGImageDestinationLossyCompressionQuality:@(jpegQuality)};
            params = (__bridge CFDictionaryRef)mutableDict;
        }

        /// 检查是否是文件路径
        if (!fileUrl.isFileURL) {
            [imagePath stringByDeletingPathExtension];
            return NO;
        }
        
        /// 检查路径，如果路径不存在，先创建路径
        NSString* path = imagePath.stringByDeletingLastPathComponent;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        /// 构造destination
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, type, jpegQuality, NULL);
        if (!destination) {
            return NO;
        }
        
        /// 保存
        BOOL saveSuccess = YES;
        CGImageDestinationAddImage(destination, image.CGImage, params);
        if (!CGImageDestinationFinalize(destination)) {
            saveSuccess = NO;
        }
        CFRelease(destination);
        return saveSuccess;
    }
    
}



@end
