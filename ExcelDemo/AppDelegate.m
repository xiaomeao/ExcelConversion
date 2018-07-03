//
//  AppDelegate.m
//  ExcelDemo
//
//  Created by 杜 on 2018/3/27.
//  Copyright © 2018年 杜. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self creatExcelFile];
//    [self createLocalizable];
    
    return YES;
}

#pragma mark - localizable 转 xls
- (void)creatExcelFile {

    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"localizable" ofType:@""] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    textFileContents = [NSString stringWithFormat:@"key\t简体中文\n%@", textFileContents];
    NSString *newText = [[[textFileContents stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@" = " withString:@"\t"] stringByReplacingOccurrencesOfString:@";" withString:@""];
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *fileData = [newText dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/export.xls"];
    NSLog(@"文件路径：\n%@",filePath);
#warning 手动复制出来
    // 生成xls文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
}

#pragma mark - xls 转 localizable
- (void)createLocalizable
{
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"exporty" ofType:@"xls"] encoding:NSUTF16StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    NSArray *textArray = [textFileContents componentsSeparatedByString:@"\n"];
    NSLog(@"%@",textArray);
    NSMutableArray *newAry = [NSMutableArray arrayWithCapacity:0];
    for (NSString *text in textArray) {
        NSString *newtxt = @"";
        newtxt = [NSString stringWithFormat:@"\"%@",text];
        newtxt = [newtxt stringByReplacingOccurrencesOfString:@"\t" withString:@"\" = \""];
        newtxt = [NSString stringWithFormat:@"%@\";",newtxt];
        [newAry addObject:newtxt];
    }
    NSLog(@"%@",newAry);
    
    NSString *newText = [newAry componentsJoinedByString:@"\n"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSData *fileData = [newText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/localizable"];
    NSLog(@"文件路径：\n%@",filePath);
    // 生成localizable文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
}

@end
