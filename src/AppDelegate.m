//
// AppDelegate.m
// network-watchexec
//

#import "AppDelegate.h"

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define NOT_CONNECTED @"NOT_CONNECTED"
#define RAW_PKG_ETC /usr/local/etc/network-watchexec
#define RAW_HOOKS_DIR RAW_PKG_ETC/hooks
#define POSTCONNECTION_HOOK_SCRIPT @"RAW_HOOKS_DIR/post-connection"
#define POSTDISCONNECTION_HOOK_SCRIPT @"RAW_HOOKS_DIR/post-disconnection"

void launch_script_with_args(NSString* path, NSArray* arguments);
void switch_SSID_to(NSString* SSID);
void WiFi_network_changed(SCDynamicStoreRef store, CFArrayRef changed_keys, void* context);

@interface AppDelegate()
@end

@implementation AppDelegate
  - (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    NSLog(@"Starting `network-watchexec`.  ");

    CWInterface* WiFi_interface = [CWInterface interface];
    self.current_SSID = [WiFi_interface ssid] ? [WiFi_interface ssid] : NOT_CONNECTED

    // NOTE:  Each of the following commented chunks of code could _also_ be their own separate, named functions, but, again, I'm not doing any refactoring at the moment.  (TO-DO:  Refactor these commented chunks of code out into their own separate, named functions.)  

    // Get a list of all Wi-Fi interfaces and use its contents to build an array of `SCDynamicStore` keys to monitor:  
    NSSet* WiFi_interfaces = [CWInterface interfaceNames];
    NSMutableArray* SystemConfiguration_keys = [[NSMutableArray alloc] init];
    [WiFi_interfaces enumerateObjectsUsingBlock:^(NSString* interface_name, NSUInteger index, BOOL* stop_token) {
      [SystemConfiguration_keys addObject:[NSString stringWithFormat:@"State:Network/Interface/%@/AirPort", interface_name]];
    }];

    // Connect to the dynamic store:  
    SCDynamicStoreContext context = { 0, NULL, NULL, NULL, NULL }; // NOTE:  More magic constants here... (TO-DO:  Fix that.)  
    SCDynamicStoreRef store = SCDynamicStoreCreate(kCFAllocatorDefault, CFSTR("com.github.RandomDSdevel.network_watchexec"), WiFi_network_changed, &context); // NOTE:  Yes, I _know_ that `CFSTR` I'm using is yet _another_ magic constant.  _I_ introduced it, too.  (TO-DO:  Clean up after myself here later.)  

    // Start monitoring:  
    SCDynamicStoreSetNotificationKeys(store, (__bridge CFArrayRef)SystemConfiguration_keys, NULL); // NOTE:  Another magic constant.  I didn't add this one, though.  (TO-DO:  Factor it out into a named constant.)  

    CFRunLoopSourceRef source = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, store, 0); // NOTE:  Another magic constant.  I didn't add this one, either.  (TO-DO:  Factor it out into a named constant.)  
    CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop], source, kCFRunLoopCommonModes);
  }

  - (void)applicationWillTerminate:(NSNotification*)aNotification {
    NSLog(@"Exiting `network-watchexec`.  ");
  }
@end

void launch_script_with_args(NSString* path, NSArray* arguments) {
  NSTask* script_to_run = [[NSTask alloc] init];
  [script_to_run setLaunchPath:path];
  if(arguments) {
    [script_to_run setArguments:arguments];
  }
  [script_to_run launch];
}

void switch_SSID_to(NSString* SSID) {
  AppDelegate* app_delegate = [[NSApplication sharedApplication] delegate];

  NSLog(@"Current interface:  %@", app_delegate.current_SSID);

  NSString* old_SSID = [app_delegate.current_SSID copy];
  app_delegate.current_SSID = SSID ? SSID : NOT_CONNECTED;

  NSString* program_path = nil;
  NSArray* arg_array = nil;

  if([app_delegate.current_SSID isEqualToString:NOT_CONNECTED]) {
    program_path = POSTDISCONNECT_HOOK_SCRIPT;
    arg_array = @[old_SSID];
  } else {
    program_path = POSTCONNECTION_HOOK_SCRIPT
    arg_array = @[old_SSID, app_delegate.current_SSID];
  }

  launch_script_with_args(program_path, arg_array);
  return;
}

void WiFi_network_changed(SCDynamicStoreRef store, CFArrayRef changed_keys, void* context) {
  [(__bridge NSArray*)changed_keys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger index, BOOL* stop_token) {
    // Extract the name of an interface to use from `changed_key`:  (NOTE:  Ideally, this would be a separate, named function, but I'm not refactoring it at the moment.)  (TO-DO:  Refactor this into a separate, named function.)  
    NSString* interface_name = [key componentsSeparatedByString:@"/"][3]; // (NOTE:  Also, I'd prefer if the constant we're using here wasn't a magic one.)  (TO-DO:  Factor the magic constant used here out into a named one.)  
    CWInterface* interface = [CWInterface interfaceWithName:interface_name];

    AppDelegate* app_delegate = [[NSApplication sharedApplication] delegate];

    NSString* current_SSID = [app_delegate current_SSID];

    if(!([current_SSID isEqualToString:interface.ssid] || ([current_SSID isEqualToString:NOT_CONNECTED] && !interface.ssid))) {
      switch_SSID_to(interface.ssid);
    }
  }];
}

