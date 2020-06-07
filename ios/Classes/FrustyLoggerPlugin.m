#import "FrustyLoggerPlugin.h"
#if __has_include(<frusty_logger/frusty_logger-Swift.h>)
#import <frusty_logger/frusty_logger-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "frusty_logger-Swift.h"
#endif

@implementation FrustyLoggerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFrustyLoggerPlugin registerWithRegistrar:registrar];
}
@end
