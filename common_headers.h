#import <libSandy.h>
#import <version.h>
#import <rootless.h>
#import <sys/proc.h>
#import <dlfcn.h>
#import <Foundation/Foundation.h>

#include <sys/sysctl.h>
#include "xpc.h"
#import "libproc.h"
#import "kern_memorystatus.h"
#define MEMORYSTATUS_CMD_SET_JETSAM_TASK_LIMIT 6
#define JETSAM_MEMORY_LIMIT 512
#define DEFAULT_HOSTS_PATH "/etc/hosts"
#define NEW_HOSTS_PATH ROOT_PATH("/etc/hosts.lmb")
#define ROOTLESS_NEW_HOSTS_PATH "/var/jb/etc/hosts"

extern "C" int memorystatus_control(uint32_t command, pid_t pid, uint32_t flags, void *buffer, size_t buffersize);

static FILE *etcHosts;