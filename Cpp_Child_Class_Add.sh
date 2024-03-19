#Добавляет в проект класс-потомок
#Родительким классом для него может быть только один класс

echo "Введите имя родительского класса: "

read parentClassName

if [ -e src/$parentClassName/ ]
then
    if [ -e src/$parentClassName/$parentClassName.cpp ]
    then
        if [ -e src/$parentClassName/$parentClassName.hpp ]
        then
cd src
echo "Введите имя класса: "
read className

if [ -e $className/ ]
then
echo "Класс с таким именем уже существует"
cd ..
else

mkdir "$className"
cd "$className"

cat << end >> $className.cpp
#include "$className.hpp"
end

upperName="${className^^}"

cat << end >> $className.hpp
#ifndef ${upperName}_HPP
#define ${upperName}_HPP
#include "src/$parentClassName/$parentClassName.hpp"


#endif
end

cat << end >> BUILD
## src/$className/BUILD

cc_library(
    name = "$className",
    srcs = ["$className.cpp"],
    hdrs = ["$className.hpp"],
    visibility = ["//visibility:public"],
    deps = [
        "//src/$parentClassName:$parentClassName",
    ],
)
end

cd ../main

sed -i '$d' BUILD
sed -i '$d' BUILD

cat << end >> BUILD
        "//src/$className:$className",
    ],
)
end

cat <<<"#include \"src/$className/$className.hpp\"
$(<main.cpp)" >main.cpp


fi
        else
        echo "Класса с таким именем не существует"
        fi
    else
    echo "Класса с таким именем не существует"
    fi
else
echo "Класса с таким именем не существует"
fi
