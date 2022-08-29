#pragma once

#include <sstream>
#include <iostream>
#include <functional>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

#include <filesystem>


struct System
{
    static void profile(const std::string& name, const std::string& events, std::function<void()> body) {
        std::string filename = name.find(".data") == std::string::npos ? (name + ".data") : name;

        // Launch profiler
        pid_t pid;
        std::stringstream s;
        s << getpid();
        pid = fork();
        if (pid == 0) {
            auto fd=open("/dev/null",O_RDWR);
            dup2(fd,1);
            dup2(fd,2);
            exit(execl("/usr/bin/perf","perf", "stat", "-x,","-e", events.c_str(), "-o", filename.c_str(),"-p",s.str().c_str(),nullptr));
        }

        // Run body
        body();
        
        // For some reasons if perf killed too early, no output is shown, this is just a workaround
        sleep(1);
        kill(pid,SIGINT);
        waitpid(pid,nullptr,0);
        
        
    }

    static void profile(std::function<void()> body) {
        profile("perf.data", "cycles", body);
    }
};
