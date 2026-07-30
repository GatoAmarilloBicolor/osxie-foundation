add_osxie_static_library(nsxpc_test_launchd_service_common
	FAT
	SOURCES
		common.m
)

add_osxie_executable(nsxpc_test_launchd_service service.m)
add_osxie_executable(nsxpc_test_client client.m)

# force the classes from the static library to be loaded
target_link_options(nsxpc_test_launchd_service PRIVATE
	-Wl,-ObjC
)

target_link_options(nsxpc_test_client PRIVATE
	-Wl,-ObjC
)

target_link_libraries(nsxpc_test_launchd_service
	Foundation
	nsxpc_test_launchd_service_common
)

target_link_libraries(nsxpc_test_client
	Foundation
	nsxpc_test_launchd_service_common
)

install(
	TARGETS
		nsxpc_test_launchd_service
		nsxpc_test_client
	DESTINATION
		libexec/osxie/usr/libexec
)

install(
	FILES
		org.osxiehq.Foundation.nsxpc-test-service.plist
	DESTINATION
		libexec/osxie/System/Library/LaunchDaemons
)
