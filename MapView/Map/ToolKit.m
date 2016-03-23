//
//  ToolKit.m
//  MapView
//
//  Created by imobile-xzy on 16/3/23.
//
//

#import "ToolKit.h"

@implementation ToolKit


+(BOOL)createFileDirectories:(NSString*)path
{
    NSString* DOCUMENTS_FOLDER_AUDIO = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:DOCUMENTS_FOLDER_AUDIO isDirectory:&isDir];
    
    
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER_AUDIO withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(!bCreateDir){
            
            NSLog(@"Create Directory Failed.");
            return NO;
        }else
        {
            NSLog(@"%@",DOCUMENTS_FOLDER_AUDIO);
            return YES;
        }
    }
    
    return YES;
}

@end
