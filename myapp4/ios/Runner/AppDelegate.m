#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
    FlutterViewController* ctrlr = (FlutterViewController*)self.window.rootViewController;
    [self registFlutterMethodChannel:ctrlr];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)registFlutterMethodChannel:(FlutterViewController*)ctrlr
{
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"samples.flutter.io/battery"
                                            binaryMessenger:ctrlr];
    
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"getBatteryLevel" isEqualToString:call.method]) {
            int batteryLevel = [self getBatteryLevel];
            
            if (batteryLevel == -1) {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                           message:@"Battery info unavailable"
                                           details:nil]);
            } else {
                result(@(batteryLevel));
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
        
    }];
    
    NSLog(@"will Call Flutter");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"start Call Flutter");
        [batteryChannel invokeMethod:@"getName" arguments:nil result:^(id  _Nullable result) {
            NSLog(@"result from Flutter: %@", result);
        }];
        
    });
}

- (int)getBatteryLevel {
    UIDevice* device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;
    NSLog(@"current battery state : %d", (int)device.batteryState);
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return -1;
    } else {
        return (int)(device.batteryLevel * 100);
    }
}


@end
