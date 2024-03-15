#Добавляет класс с выбранным названием и добавляет все зависимости для Bazel

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

cd ../tests

sed -i '$d' BUILD
sed -i '$d' BUILD

cat << end >> BUILD
        "//src/$className:$className",
    ],
)
end

cat <<<"#include \"src/$className/$className.hpp\"
$(<Tests.cpp)" >Tests.cpp

cd ../..
