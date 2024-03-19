#Создаёт базовый проект состоящий из main.cpp
#Также запускает сборку этого проекта в режиме Bazel Debug

if [ ! -e MODULE.bazel ]; then
cat << 'end' >> MODULE.bazel
## MODULE.bazel

module(
    name = "cpp_app",
    repo_name = "cpp_app",
    version = "1.0",
    compatibility_level = 1
)
bazel_dep(name = "googletest", version = "1.14.0")
end
fi

if [ ! -e .bazelrc ]; then
cat << 'end' >> .bazelrc
# Enable Bzlmod for every Bazel command

build --action_env=CC=clang
build --action_env=CXX=clang++

build --cxxopt='-std=c++20'
test --cxxopt='-std=c++20'

# debug config
build:debug --compilation_mode=dbg

# release config 
build:release --compilation_mode=opt


build --copt="--language=c++"
test --copt="--language=c++"

build --copt="-fdiagnostics-color=always"

# Use colors to highlight output on the screen. Set to `no` if your CI does not display colors.
# Docs: https://bazel.build/docs/user-manual#color
build --color=yes
test --color=yes

# Promote unused result and variable warnings to errors.
# build --cxxopt='-Werror=unused-result'
# test --cxxopt='-Werror=unused-result'
# build --cxxopt='-Werror=unused-variable'
# test --cxxopt='-Werror=unused-variable'
end
fi

if [ ! -e WORKSPACE ]; then
touch WORKSPACE
fi

if [ ! -e src/ ]; then
mkdir src
fi

if [ ! -e src/main ]; then
mkdir src/main
fi

if [ ! -e src/main/BUILD ]; then
cat << 'end' >> src/main/BUILD
## src/main/BUILD

cc_binary(
    name = "cpp_app",
    srcs = ["main.cpp"],
    deps = [
        
    ],
)
end
fi

if [ ! -e src/main/main.cpp ]; then
cat << end >> src/main/main.cpp
int main()
{
	return 0;
}
end
fi

if [ ! -e .vscode ]; then
mkdir .vscode
fi

cd .vscode

if [ ! -e c_cpp_properties.json ]; then
cat << 'end' >> c_cpp_properties.json
{
  "configurations": [
      {
          "name": "Linux",
          "includePath": [
              "${workspaceFolder}/bazel-bin/**",
              "${workspaceFolder}/bazel-out/**",
              "${workspaceFolder}/bazel-${workspaceFolderBasename}/**"
          ],
          "intelliSenseMode": "${default}",
          "cppStandard": "c++20"
      }
  ],
  "version": 4
}
end
fi

if [ ! -e launch.json ]; then
cat << 'end' >> launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Bazel Debug",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bazel-bin/src/main/cpp_app",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "externalConsole": false,  
            "MIMode": "gdb",
            "miDebuggerArgs": "-q -ex quit; wait() { fg >/dev/null; }; /bin/gdb -q --interpreter=mi",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": false
                }
            ],
            "preLaunchTask": "bazel-build-debug"
        },
        {
            "name": "Bazel Release",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bazel-bin/src/main/cpp_app",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerArgs": "-q -ex quit; wait() { fg >/dev/null; }; /bin/gdb -q --interpreter=mi",
            "preLaunchTask": "bazel-build-release" 
        },
        {
            "name": "Bazel Test",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bazel-bin/src/tests/tests",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerArgs": "-q -ex quit; wait() { fg >/dev/null; }; /bin/gdb -q --interpreter=mi",
            "preLaunchTask": "bazel-test"
        }
    ]
}
end
fi

if [ ! -e tasks.json ]; then
cat << 'end' >> tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "bazel-build-debug",
            "type": "shell",
            "command": "bazel build //src/main:cpp_app --config=debug ",
            "group": "build"
        },
        {
            "label": "bazel-build-release",
            "type": "shell",
            "command": "bazel build //src/main:cpp_app --config=release ",
            "group": "build"
        },
        {
            "label": "bazel-test",
            "type": "shell",
            "command": "bazel test //src/tests:all --test_output=all --nocache_test_results || [ $? -eq 3 ] && exit 0", 
            "group": "test"
        }
    ]
}
end
fi

cd ..

bazel build //src/main:cpp_app
