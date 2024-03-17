echo "Please, enter parent class name:"

read parentClassName

if [ -e src/$parentClassName/ ]
then
    if [ -e src/$parentClassName/$parentClassName.cpp ]
    then
        if [ -e src/$parentClassName/$parentClassName.hpp ]
        then
cd src
echo "Enter class name: "
read className
mkdir "$className"
cd "$className"

cat << end >> $className.cpp
#include "$className.hpp"
end

upperName="${className^^}"

cat << end >> $className.hpp
#ifndef ${upperName}_HPP
#define ${upperName}_HPP

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

sed -i '$d' BUILD
sed -i '$d' BUILD

cat << end >> BUILD
        "//src/$className:$className",
    ],
)
end

cat <<<"#include \"src/$className/$className.hpp\"
$(<main.cpp)" >main.cpp



        else
        echo "There is no class with that name"
        fi
    else
    echo "There is no class with that name"
    fi
else
echo "There is no class with that name"
fi