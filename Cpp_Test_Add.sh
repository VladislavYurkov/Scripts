#Добавляет файл для тестирования отдельного модуля(cpp и hpp файл)

echo "Введите имя тестируемого модуля"

read testingModuleName

if [ -e src/$testingModuleName/ ]
then
    if [ -e src/$testingModuleName/$testingModuleName.cpp ]
    then
        if [ -e src/$testingModuleName/$testingModuleName.hpp ]
        then
            if [ -e src/tests/${testingModuleName}Tests ]
            then
            echo "Тесты для этого модуля уже существуют"
            else
cd src

if [ -e "tests/" ]
then
cd "tests"

sed -i '$d' BUILD
sed -i '$d' BUILD

cat << end >> BUILD
        "//src/tests/${testingModuleName}Tests:${testingModuleName}Tests",
    ],
)
end

else
mkdir "tests"
cd "tests"

cat << end >> BUILD
## src/tests/BUILD

cc_test(
    name = "tests",
    srcs = ["tests.cpp"],
    deps = [
        "@googletest//:gtest_main",
        "//src/tests/${testingModuleName}Tests:${testingModuleName}Tests",
    ]
)
end

cat << end >> tests.cpp
#include <stdexcept>
#include <gtest/gtest.h>

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

end

fi

mkdir ${testingModuleName}Tests

cd ${testingModuleName}Tests

cat << end >> ${testingModuleName}Tests.cpp
#include <stdexcept>
#include <gtest/gtest.h>
#include "src/$testingModuleName/$testingModuleName.hpp"

end

cat << end >> BUILD
## src/tests/${testingModuleName}Tests/BUILD

cc_library(
    name = "${testingModuleName}Tests",
    srcs = ["${testingModuleName}Tests.cpp"],
    visibility = ["//visibility:public"],
    deps = [
        "@googletest//:gtest_main",
        "//src/$testingModuleName:$testingModuleName",
    ]
)
end

cd ../../..
            fi
        else
        echo "Модуля с таким именем не существует"
        fi
    else
    echo "Модуля с таким именем не существует"
    fi
else
echo "Модуля с таким именем не существует"
fi
