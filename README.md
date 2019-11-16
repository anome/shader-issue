# Shader issue on macOS Catalina

While majority of shaders will work on Catalina, a few shaders may cause a problem.
This is a very strange issue, because the workaround found is just about replacing a simple "else" by a "else if".

The problem has been reproduced on macOS 10.15.0, 10.15.1 and 10.15.2 beta 2 (of course, previous macOS version such as 10.14.6 do not have this problem) and on several computers. Also the problem only happens with AMD gpus, not Nvidia or Intel ones.
Simply run the project to reproduce the issue.