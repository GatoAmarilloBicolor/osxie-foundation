project(filecoordinationd)

include_directories(
	../../internal_include
)

add_osxie_executable(filecoordinationd
	daemon.m
	XPCObject.m
	FileAccessRequest.m
	logging.m
)

target_link_libraries(filecoordinationd
	Foundation
)

install(TARGETS filecoordinationd DESTINATION libexec/osxie/usr/sbin)
install(FILES com.apple.FileCoordination.plist DESTINATION libexec/osxie/System/Library/LaunchDaemons)
