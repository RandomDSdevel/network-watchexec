cmake_minimum_required(VERSION 3.13.3) # TO-DO:  Update this when I have a newer version installed locally!  
project(network-watchexec DESCRIPTION "A simple, makeshift, scriptable OS X/macOS '`launchd(8)`' network-connection change notification watchdog daemon.  " 
                          HOMEPAGE_URL "https://github.com/RandomDSdevel/network-watchexec" LANGUAGES OBJC)

add_executable(network-watchexec AppDelegate.h AppDelegate.m main.m)
find_library(AppKit AppKit)
target_link_libraries(network-watchexec AppKit)
