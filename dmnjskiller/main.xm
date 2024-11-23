#import "../common_headers.h"
#import <CoreFoundation/CoreFoundation.h>

extern "C" int memorystatus_control(uint32_t command, pid_t pid, uint32_t flags, void *buffer, size_t buffersize);
static __attribute__ ((constructor(101), visibility("hidden")))

pid_t getMDNSResponderPID() {
    pid_t mDNSResponderPID = 0;
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t size;

    if (sysctl(mib, 4, NULL, &size, NULL, 0) != -1) {
        struct kinfo_proc *processes = (struct kinfo_proc *)malloc(size);
        if (processes) {
            if (sysctl(mib, 4, processes, &size, NULL, 0) != -1) {
                for (unsigned long i = 0; i < size / sizeof(struct kinfo_proc); ++i) {
                    if (strcmp(processes[i].kp_proc.p_comm, "mDNSResponder") == 0) {
                        mDNSResponderPID = processes[i].kp_proc.p_pid;
                        break;
                    }
                }
            }
            free(processes);
        }
    }

    return mDNSResponderPID;
}

pid_t getMDNSResponderHelperPID() {
    pid_t mDNSResponderHelperPID = 0;
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t size;

    if (sysctl(mib, 4, NULL, &size, NULL, 0) != -1) {
        struct kinfo_proc *processes = (struct kinfo_proc *)malloc(size);
        if (processes) {
            if (sysctl(mib, 4, processes, &size, NULL, 0) != -1) {
                for (unsigned long i = 0; i < size / sizeof(struct kinfo_proc); ++i) {
                    if (strcmp(processes[i].kp_proc.p_comm, "mDNSResponderHelper") == 0) {
                        mDNSResponderHelperPID = processes[i].kp_proc.p_pid;
                        break;
                    }
                }
            }
            free(processes);
        }
    }

    return mDNSResponderHelperPID;
}

void BypassJetsam(void) {
    pid_t me = getMDNSResponderPID();
    int rc; memorystatus_priority_properties_t props = {JETSAM_PRIORITY_CRITICAL, 0};
    rc = memorystatus_control(MEMORYSTATUS_CMD_SET_PRIORITY_PROPERTIES, me, 0, &props, sizeof(props));
    if (rc < 0) { perror ("memorystatus_control"); exit(rc);}
    rc = memorystatus_control(MEMORYSTATUS_CMD_SET_JETSAM_HIGH_WATER_MARK, me, -1, NULL, 0);
    if (rc < 0) { perror ("memorystatus_control"); exit(rc);}
    rc = memorystatus_control(MEMORYSTATUS_CMD_SET_PROCESS_IS_MANAGED, me, 0, NULL, 0);
    if (rc < 0) { perror ("memorystatus_control"); exit(rc);}
    rc = memorystatus_control(MEMORYSTATUS_CMD_SET_PROCESS_IS_FREEZABLE, me, 0, NULL, 0);
    if (rc < 0) { perror ("memorystatus_control"); exit(rc); }
    rc = proc_track_dirty(me, 0);
    if (rc != 0) { perror("proc_track_dirty"); exit(rc); }
}


#pragma mark -

int main(int argc, char *argv[])
{
    // https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
    CFRunLoopRun();
    return 0;
}