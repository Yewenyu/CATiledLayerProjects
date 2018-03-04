//
//  YeFileManager.m
//  3D_Product_Display
//
//  Created by 小点草 on 16/11/1.
//  Copyright © 2016年 小点草. All rights reserved.
//

#import "YeFileManager.h"




@implementation YeFileManager



+(NSString *)createFileWithName:(NSString *)fileName fileType:(NSString *)fileType atPath:(PathDirectory)pathDir reCreate:(BOOL)reCreate{
    
    if(!fileName||[@"" isEqualToString:fileName]){
        NSLog(@"文件名不能为空");
        return nil;
    }
    NSString *path = [self gethPath:pathDir];
    NSString *newPath = nil;
    
    
    if([@"" isEqualToString:fileType]||!fileType){
        newPath = [path stringByAppendingPathComponent:fileName];
    }else{
        newPath = [path stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:fileType]];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExist = [fileManager fileExistsAtPath:newPath];
    
    if(fileExist&&!reCreate){
        
        NSLog(@"文件已存在...返回路径");
        return newPath;
    }
    if(fileExist){
        NSLog(@"文件已存在，删除后重新创建...");
        [self deleteFileAtPath:newPath];
    }
    
    NSLog(@"开始创建文件");
    
    if([@"" isEqualToString:fileType]||!fileType){
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        
        fileName = [newPath stringByDeletingLastPathComponent];
        fileExist = [fileManager fileExistsAtPath:fileName];
        if(!fileExist){
           
            [self createFileWithName:fileName fileType:nil atPath:UserDefinedDirectory reCreate:NO];
        }
        [fileManager createFileAtPath:newPath contents:nil attributes:nil];
    }

    
    return newPath;
}

+(BOOL)deleteFileAtPath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:path]){
        NSLog(@"目标文件不存在");
        return YES;
    }
    
    
    if([[NSFileManager defaultManager]removeItemAtPath:path error:nil]){
        NSLog(@"删除成功");
        return YES;
    }else{
        NSLog(@"删除失败");
        return NO;
    }

}

+(BOOL)deleteFilesAtPath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:path]){
        NSLog(@"目标文件不存在");
        return YES;
    }
    
    __block NSArray *fullPaths = nil;
    __block NSArray *relativePaths = nil;
    [self getFullSubPathTo:^(NSArray* arr1, NSArray* arr2){
        fullPaths = arr1;
        relativePaths = arr2;
    } AtPath:path];
    
    for(int i = (int)fullPaths.count - 1;i>=0&&fullPaths;i--){
        
        NSString *path = fullPaths[i];
        if(![self deleteFileAtPath:path]){
            NSLog(@"删除失败");
        }
    }
    if(path)
        [self deleteFileAtPath:path];
    return YES;
    
}

+(NSString*)writeData:(NSString*)dataString toPath:(PathDirectory)pathDir fileName:(NSString*)fileName fileType:(NSString*)filetype{
    
    
    
    NSString *filePath = [self createFileWithName:fileName fileType:filetype atPath:pathDir reCreate:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        NSLog(@"不存在该源文件，请检查路径是否正确或文件是否存在");
        return nil;
    }
    
    
    if(filePath){
        
        NSFileHandle *toFile = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [toFile seekToEndOfFile];
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        
        [toFile writeData:data];
        
        [toFile closeFile];
    }

    return filePath;
}
+(NSString*)writeNSData:(NSData*)data toPath:(PathDirectory)pathDir fileName:(NSString*)fileName fileType:(NSString*)filetype{
    
    
    
    NSString *filePath = [self createFileWithName:fileName fileType:filetype atPath:pathDir reCreate:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        NSLog(@"不存在该源文件，请检查路径是否正确或文件是否存在");
        return nil;
    }
    
    
    if(filePath){
        
        NSFileHandle *toFile = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [toFile seekToEndOfFile];
        
        [toFile writeData:data];
        
        [toFile closeFile];
    }
    
    return filePath;
}

+(NSString*)copyFileFrom:(NSString*)fromPath toPath:(PathDirectory)pathDir newRelativePath:(NSString*)newRelativePath reCreate:(BOOL)reCreate{
    
    if(!fromPath||[@""isEqualToString:fromPath]){
        NSLog(@"路径不能为空");
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:fromPath]){
        NSLog(@"不存在该源文件，请检查路径是否正确或文件是否存在");
        return nil;
    }
    NSString *path = [self gethPath:pathDir];
    NSString *newPath = nil;
    if(!newRelativePath||[@""isEqualToString:newRelativePath]){
        NSLog(@"新的文件名使用源文件的文件名");
        newPath = [path stringByAppendingPathComponent:[fromPath lastPathComponent]];
    }else{
        
        newPath = [path stringByAppendingPathComponent:[newRelativePath stringByAppendingPathComponent:[fromPath lastPathComponent]]];
    }
    BOOL fileExist = [fileManager contentsEqualAtPath:fromPath andPath:newPath];
    
    if(fileExist&&!reCreate){
        NSLog(@"文件已存在");
        return newPath;
    }
    
    if(fileExist||[fileManager fileExistsAtPath:newPath]){
        NSLog(@"文件已存在，开始删除文件");
        [self deleteFileAtPath:newPath];
    }
    
    
    //判断复制的文件是否是文件夹，如果是则直接创建路径然后返回
    if([@""isEqualToString:[newPath pathExtension]]){
        [fileManager createDirectoryAtPath:newPath  withIntermediateDirectories:YES attributes:nil error:nil];
        return newPath;
    }
    
    //创建新文件的路径判断路径是否存在，不存在则创建该路径
    BOOL createFile = [fileManager createFileAtPath:newPath contents:nil attributes:nil];
    if(!createFile){
        NSString *path = [newPath stringByDeletingLastPathComponent];
        
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
        createFile = [fileManager createFileAtPath:newPath contents:nil attributes:nil];
    }
    if(createFile){
        
        NSLog(@"文件创建成功，开始写入数据");
        
        NSFileHandle *inFile = [NSFileHandle fileHandleForReadingAtPath:fromPath];
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:newPath];
        
        NSDictionary *fileattu = [fileManager attributesOfItemAtPath:fromPath error:nil];
        NSNumber *fileSizeNum = [fileattu objectForKey:NSFileSize];
        
        BOOL isEnd =YES;
        NSInteger readSize = 0;//已经读取的数量
        NSInteger fileSize = [fileSizeNum longValue];//文件的总长度
        while(isEnd){
            
            NSInteger subLength = fileSize - readSize;
            NSData *data = nil;
            if(subLength<5000){
                isEnd = NO;
                data = [inFile readDataToEndOfFile];
            }else{
                data = [inFile readDataOfLength:5000];
                readSize+=5000;
                [inFile seekToFileOffset:readSize];
            }
            [outFile writeData:data];
        }
        [inFile closeFile];
        [outFile closeFile];
    }else{
        
        NSLog(@"文件创建失败");
    }
    
    return newPath;
}

+(NSString*)copyFilesFrom:(NSString*)fromPath toPath:(PathDirectory)pathDir newRelativePath:(NSString *)newRelativePath reCreate:(BOOL)reCreate{
    
    if(!fromPath||[@""isEqualToString:fromPath]){
        NSLog(@"路径不能为空");
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:fromPath]){
        NSLog(@"不存在该源文件，请检查路径是否正确或文件是否存在");
        return nil;
    }
    
    __block NSArray *fullPaths = nil;
    __block NSArray *relativePaths = nil;
    [self getFullSubPathTo:^(NSArray* arr1, NSArray* arr2){
        fullPaths = arr1;
        relativePaths = arr2;
    } AtPath:fromPath];
    
    NSMutableArray *newFiles = [NSMutableArray array];
    
    if(!newRelativePath){
        newRelativePath = @"";
    }
    
    for(NSUInteger i = 0;fullPaths&&i<fullPaths.count;i++){
        NSString *path = fullPaths[i];
        NSString *relativePath = [[newRelativePath stringByAppendingPathComponent:[[fromPath lastPathComponent]stringByAppendingPathComponent:relativePaths[i]]] stringByDeletingLastPathComponent];
        

        
        [newFiles addObject:[self copyFileFrom:path toPath:pathDir newRelativePath:relativePath reCreate:reCreate]];
    }
    
    if(newFiles){
        
        return newFiles[0];
    }
    
    
    return nil;
}

+(NSString*)searchFileWithName:(NSString*)fileName atPath:(PathDirectory)pathDir andrelative:(NSString*)relativePath{
    
    if(!fileName
       //||[@"" isEqualToString:fileName]
       ){
        NSLog(@"文件名不能为空");
        return nil;
    }
    
    NSString* path = [self gethPath:pathDir];
    NSString *documentPath = [path stringByAppendingPathComponent:relativePath];
    
    //准备枚举子路径
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:documentPath];
    NSString *file;
    NSString *result = nil;
    //创建NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"lastPathComponent", fileName];
    //筛选并加入结果
    while(file = [enumerator nextObject]){
        
        NSString *fileDeleteExtern = [file stringByDeletingPathExtension];
        //使用NSPredicate的evaluateWithObject
        if([predicate evaluateWithObject:file]||[predicate evaluateWithObject:fileDeleteExtern]){
            result = [documentPath stringByAppendingPathComponent:file];
            return result;
        }
    }
    return result;
    
}
+(NSString*)searchImageWithName:(NSString*)fileName atPath:(PathDirectory)pathDir andrelative:(NSString*)relativePath{
    
    NSString *imageFile = [fileName stringByAppendingPathExtension:@"jpg"];
    imageFile = [self searchFileWithName:imageFile atPath:pathDir andrelative:relativePath];
    if(!imageFile){
        imageFile = [fileName stringByAppendingPathExtension:@"png"];
        imageFile = [self searchFileWithName:imageFile atPath:pathDir andrelative:relativePath];
    }
    return imageFile;
}

+(NSString*)searchFileWithName:(NSString*)fileName atPath:(PathDirectory)pathDir{
    
    if(!fileName
       //||[@"" isEqualToString:fileName]
       ){
        NSLog(@"文件名不能为空");
        return nil;
    }
    
    NSString* path = [self gethPath:pathDir];
    
    NSString *result = nil;
    
    //筛选并加入结果
    @autoreleasepool{
        //准备枚举子路径
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
        NSString *file;
        
        //创建NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"lastPathComponent", fileName];
        while(file = [enumerator nextObject]){
            //使用NSPredicate的evaluateWithObject
            if([predicate evaluateWithObject:file]){
                result = [path stringByAppendingPathComponent:file];
                return result;
            }
        }
    }
    
    return result;
    
}

+(NSString*)searchFileWithExtension:(NSString*)fileExtension atPath:(NSString*)pathDir{
    
    if(!fileExtension
       //||[@"" isEqualToString:fileName]
       ){
        NSLog(@"文件名不能为空");
        return nil;
    }
    NSString* path = pathDir;
    
    //准备枚举子路径
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
    NSString *file;
    NSString *result = nil;
    //创建NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"pathExtension", fileExtension];
    
    //筛选并加入结果
    while(file = [enumerator nextObject]){
        //使用NSPredicate的evaluateWithObject
        if([predicate evaluateWithObject:file]){
            result = [path stringByAppendingPathComponent:file];
            return result;
        }
    }
    return result;
    
}
+(NSArray*)searchFilesWithExtension:(NSString*)fileExtension atPath:(NSString*)pathDir{
    
    if(!fileExtension
       //||[@"" isEqualToString:fileName]
       ){
        NSLog(@"文件名不能为空");
        return nil;
    }
    NSString* path = pathDir;
    
    //准备枚举子路径
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
    NSString *file;
    NSString *result = nil;
    //创建NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"pathExtension", fileExtension];
    
    NSMutableArray *array = [NSMutableArray array];
    //筛选并加入结果
    while(file = [enumerator nextObject]){
        //使用NSPredicate的evaluateWithObject
        if([predicate evaluateWithObject:file]){
            result = [path stringByAppendingPathComponent:file];
            [array addObject:result];
        }
    }
    return array;
    
}

+(NSArray*)searchSubPaths:(NSString*)path forKey:(NSString*)key{
    
    if(!path||[@"" isEqualToString:path]){
        NSLog(@"路径不能为空");
        return nil;
    }
    if(!key||[@"" isEqualToString:key]){
        NSLog(@"关键字为空不执行搜索,直接返回该目录所有子目录");
        
        NSArray *paths = nil;
        
        paths = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:path error:nil];
        
        return paths;
    }
    
    //准备枚举子路径
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
    NSString *file;
    NSMutableArray *result = [NSMutableArray array];
    //创建NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%k LIKE %@", @"lastPathComponent", key];
    
    //筛选并加入结果
    while(file = [enumerator nextObject]){
        //使用NSPredicate的evaluateWithObject
        if([predicate evaluateWithObject:file]){
            [result addObject:[path stringByAppendingPathComponent:file]];
        }
    }
    return result;
}


+(BOOL)getTheDocumentFullSubPathTo:(void(^)(NSArray* fullPath, NSArray* relativePath))block AtPath:(NSString *)path{
    
    
    if(!path||[@"" isEqualToString:path]){
        NSLog(@"路径不能为空");
        return NO;
    }
    NSArray *fileList = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    NSString *file;
    NSMutableArray *fullResult = [NSMutableArray array];
    NSMutableArray *relaResult = [NSMutableArray array];
    for(file in fileList){
        //使用NSPredicate的evaluateWithObject
        [fullResult addObject:[path stringByAppendingPathComponent:file]];
        [relaResult addObject:[@"" stringByAppendingPathComponent:file]];
    }
    
    if(fullResult.count>0){
        block(fullResult,relaResult);
        return YES;
    }
    return NO;
}

+(BOOL)getFullSubPathTo:(void(^)(NSArray* fullPath, NSArray* relativePath))block AtPath:(NSString *)path{
    
    
    if(!path||[@"" isEqualToString:path]){
        NSLog(@"路径不能为空");
        return NO;
    }
    //准备枚举子路径
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
    NSString *file;
    NSMutableArray *fullResult = [NSMutableArray array];
    NSMutableArray *relaResult = [NSMutableArray array];
    while(file = [enumerator nextObject]){
        //使用NSPredicate的evaluateWithObject
        [fullResult addObject:[path stringByAppendingPathComponent:file]];
        [relaResult addObject:[@"" stringByAppendingPathComponent:file]];
    }
    
    if(fullResult.count>0){
        block(fullResult,relaResult);
        return YES;
    }
    return NO;
}

+(NSString*)moveFilesFrom:(NSString *)fromPath ToRelativePath:(NSString *)relativePath ReName:(NSString*)reName  atPath:(PathDirectory)pathDir IsCover:(BOOL)isCover{
    
    if(!fromPath||[@"" isEqualToString:fromPath]){
        NSLog(@"路径不能为空");
        return nil;
    }
    if(!relativePath)
        relativePath = @"";
    if([@""isEqualToString:relativePath]){
        NSLog(@"移动或重命名失败，relativePath不能同时为空");
        return nil;
    }
    
    __block NSArray *fullPaths = nil;
    __block NSArray *relativePaths = nil;
    [self getFullSubPathTo:^(NSArray* arr1, NSArray* arr2){
        fullPaths = arr1;
        relativePaths = arr2;
    } AtPath:fromPath];
    
    NSMutableArray *newFiles = [NSMutableArray array];
    
    for(NSInteger i = fullPaths.count-1;fullPaths&&i>=0;i--){
        
        NSString *path = fullPaths[i];
        NSString *newPath = [relativePath stringByAppendingPathComponent:[relativePaths[i] stringByDeletingLastPathComponent]];
        
        NSString *result = [self moveFileFrom:path ToRelativePath:newPath ReName:reName atPath:pathDir IsCover:isCover];
        
        if(result)
            [newFiles addObject:result];
    }
    
    [self deleteFileAtPath:fromPath];
    if(newFiles.count>0){
        return [newFiles[newFiles.count-1]stringByDeletingLastPathComponent];
    }else{
        NSLog(@"已存在相同名称的文件");
        return nil;
    }
    

    
}

+(NSString*)moveFileFrom:(NSString *)fromPath ToRelativePath:(NSString *)relativePath ReName:(NSString *)reName atPath:(PathDirectory)pathDir IsCover:(BOOL)isCover{
    
    if(!fromPath||[@"" isEqualToString:fromPath]){
        NSLog(@"路径不能为空");
        return nil;
    }
    if(!relativePath)
        relativePath = @"";
    if(!reName)
        reName = @"";
    if([@""isEqualToString:relativePath]&&[@""isEqualToString:reName]){
        NSLog(@"移动或重命名失败，relativePath和reName不能同时为空");
        return nil;
    }
    
    NSString *newToPath = nil;
    
    if(pathDir==UserDefinedDirectory){
        newToPath = [[fromPath stringByDeletingLastPathComponent]stringByDeletingLastPathComponent];
    }else{
        newToPath = [self gethPath:pathDir];
    }
    
    if(![@""isEqualToString:relativePath]){
        newToPath = [newToPath stringByAppendingPathComponent:relativePath];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:newToPath]){
        [fileManager createDirectoryAtPath:newToPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![@""isEqualToString:reName]) {
        newToPath = [[newToPath stringByAppendingPathComponent:reName]stringByAppendingPathExtension:[fromPath pathExtension]];
    }else{
        newToPath = [newToPath stringByAppendingPathComponent:[fromPath lastPathComponent]];
    }
    NSError *error = nil;
    
    if(isCover&&[fileManager fileExistsAtPath:newToPath]){
        [self deleteFileAtPath:newToPath];
    }
    
    if([fileManager moveItemAtPath:fromPath toPath:newToPath error:&error]){
        NSLog(@"移动或重命名成功:%@",error);
        return newToPath;
    }else{
        NSLog(@"移动或重命名失败:%@",error);
        return nil;
    }
}



+(BOOL)isfileExistsAtPath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        return YES;
    }
    return NO;
}

+(NSString *)gethPath:(PathDirectory)pathDir{
    
    
    NSString *path = nil;
    NSArray *paths = nil;
    
    switch (pathDir) {
        case HomeDirectory:
            path = NSHomeDirectory();
            break;
        case DocumentsDirectory:
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [paths objectAtIndex:0];
            
            break;
        case CachesDirectory:
            paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            path = [paths objectAtIndex:0];
            break;
        case TmpDirectory:
            path = NSTemporaryDirectory();
            break;
        case UserDefinedDirectory:
            path = @"";
            break;
        default:
            NSLog(@"不存在该路径");
            break;
    }
    
    return path;
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
@end
