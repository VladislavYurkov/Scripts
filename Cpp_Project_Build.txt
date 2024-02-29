#Создаёт базовый проект состоящий из main.cpp и файла тестов
#Также запускает сборку этого проекта в режиме Bazel Debug
#ОСТОРОЖНО! Скрипт удаляет все файлы в папке проекта

echo "To continue print 'yes'"

read yes

if [[ "$yes" == "yes" ]]; then



rm -rf *
rm -rf .*


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

touch WORKSPACE

mkdir src

mkdir src/main

cat << 'end' >> src/main/BUILD
## src/main/BUILD

cc_binary(
    name = "cpp_app",
    srcs = ["main.cpp"],
    deps = [

    ],
)
end

cat << end >> src/main/main.cpp
int main()
{
	return 0;
}
end

mkdir .vscode

cd .vscode

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

cd ../src

mkdir tests

cd tests

cat << end >> Tests.cpp
#include <stdexcept>
#include <gtest/gtest.h>


TEST(testCase, testName) 
{
    EXPECT_EQ(1, 1);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
end

cat << end >> BUILD
## src/tests/BUILD

cc_test(
    name = "tests",
    srcs = ["Tests.cpp"],
    deps = [
        "@googletest//:gtest_main",
    ]
)
end

cd ../..

bazel build //src/main:cpp_app

echo Done!

fi

