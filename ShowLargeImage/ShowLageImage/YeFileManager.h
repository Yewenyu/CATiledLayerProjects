//
//  YeFileManager.h
//
//
//  Created by xx on 16/11/1.
//  Copyright © 2016年 aa. All rights reserved.
//

#define GB_18030_2000 CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


#import <UIKit/UIKit.h>


/**沙盒路径枚举类型
    HomeDirectory:沙盒根路径
    DocumentsDirectory:Documents目录，您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息
    CachesDirectory:Caches目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
    TmpDirectory:tmp 目录这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
    UserDefinedDirectory:不使用沙盒路径
 */
typedef NS_ENUM(NSUInteger, PathDirectory) {
    
    HomeDirectory = 1,
    DocumentsDirectory,
    CachesDirectory,
    TmpDirectory,
    UserDefinedDirectory
    
};



@interface YeFileManager : NSObject


/**创建文件并返回文件路径
 
 fileName:创建的文件名
 fileType:创建的文件类型
 pathDir:在该路径下创建文件
 reCreate:文件存在时是否重新创建
 */
+(NSString*)createFileWithName:(NSString*)fileName fileType:(NSString*)fileType atPath:(PathDirectory)pathDir reCreate:(BOOL)reCreate;

/**删除文件
    deleteFileAtPath删除该路径的一个文件
    deleteFilesAtPath删除pathDir路径下的名字为fileName的文件夹
 */
+(BOOL)deleteFileAtPath:(NSString*)path;

+(BOOL)deleteFilesAtPath:(NSString*)path;

+(NSString*)writeData:(NSString*)dataString toPath:(PathDirectory)pathDir fileName:(NSString*)fileName fileType:(NSString*)filetype;
+(NSString*)writeNSData:(NSData*)data toPath:(PathDirectory)pathDir fileName:(NSString*)fileName fileType:(NSString*)filetype;
/**复制文件
    fromPath:为源文件绝对路径，不能为空
    pathDir:为沙盒路径
    newRelativePath:必须是相对路径格式为aa、aa/bb，可以为空
    reCreate:如果文件已经存在是否覆盖
 
 */
+(NSString*)copyFileFrom:(NSString*)fromPath toPath:(PathDirectory)pathDir newRelativePath:(NSString*)newRelativePath reCreate:(BOOL)reCreate;

+(NSString*)copyFilesFrom:(NSString*)fromPath toPath:(PathDirectory)pathDir newRelativePath:(NSString*)newRelativePath reCreate:(BOOL)reCreate;
/**搜索文件
 */
+(NSString*)searchFileWithName:(NSString*)fileName atPath:(PathDirectory)pathDir;

+(NSString*)searchFileWithExtension:(NSString*)fileExtension atPath:(NSString*)pathDir;
+(NSArray*)searchFilesWithExtension:(NSString*)fileExtension atPath:(NSString*)pathDir;

+(NSString*)searchFileWithName:(NSString*)fileName atPath:(PathDirectory)pathDir andrelative:(NSString*)relativePath;
+(NSString*)searchImageWithName:(NSString*)fileName atPath:(PathDirectory)pathDir andrelative:(NSString*)relativePath;
/**获取文件所有子目录路径
    获取的路径需要通过block进行赋值返回
 */
+(BOOL)getFullSubPathTo:(void(^)(NSArray* fullPath, NSArray* relativePath))block AtPath:(NSString*)path;

/**只获取路径下的目录不包含其目录的子目录**/
+(BOOL)getTheDocumentFullSubPathTo:(void(^)(NSArray* fullPath, NSArray* relativePath))block AtPath:(NSString *)path;

/**移动文件和重命名文件
 */
+(NSString*)moveFileFrom:(NSString*)fromPath ToRelativePath:(NSString*)relativePath ReName:(NSString*)reName atPath:(PathDirectory)pathDir IsCover:(BOOL)isCover;

+(NSString*)moveFilesFrom:(NSString *)fromPath ToRelativePath:(NSString *)relativePath ReName:(NSString*)reName  atPath:(PathDirectory)pathDir IsCover:(BOOL)isCover;

/**获取沙盒目录
 */
+(NSString *)gethPath:(PathDirectory)pathDir;

+(BOOL)isfileExistsAtPath:(NSString*)path;
+(NSString*)getCurrentTimes;
@end



