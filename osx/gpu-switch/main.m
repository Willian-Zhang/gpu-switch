//
//  main.m
//  gpu-switch
//
//  Created by malte on 09/05/16.
//  Copyright © 2016 Malte Bargholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMux.h"
#import "GSGPU.h"

static void printUsage(void);

int main(int argc, const char * argv[]) {
    [GSMux switcherOpen];
    @autoreleasepool {
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        if(arguments.count > 2 || arguments.count == 1 || ([arguments[1] isEqualToString:@"-h"] || [arguments[1] isEqualToString:@"--help"])){
            printUsage();
            [GSMux switcherClose];
            return -1;
        }
        else{
            NSString *mod = arguments[1];
            if([mod isEqualToString:@"-i"]){
                [GSMux setMode:GSSwitcherModeForceIntegrated];
            }
            else if([mod isEqualToString:@"-d"]){
                [GSMux setMode:GSSwitcherModeForceDiscrete];
            }
            else if([mod isEqualToString:@"-a"]){
                [GSMux setMode:GSSwitcherModeDynamicSwitching];
            }
            else{
                printUsage();
                [GSMux switcherClose];
                return -1;
            }
        }
        
    }
    [GSMux switcherClose];
    return 0;
}

static void printUsage(void){
    NSArray *gpuNames = [GSGPU getGPUNames];
    int i = 0;
    for (NSString *name in gpuNames) {
        printf("%i: %s\n", i, [name UTF8String]);
        i++;
    }
    int64_t which = [GSMux whichGraphicCard];
    printf("Using: %lld (This is not `%s`)\n", which, [[gpuNames objectAtIndex:which] UTF8String]);
    
    
    printf("GPU switch usage:\n\
      \t-i\t\t switch to integrated\n\
      \t-d\t\t switch to discrete\n\
      \t-a\t\t enable auto switching\n\
      \t-h/--help\t display this usage information.\n");
}
