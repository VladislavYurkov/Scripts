echo "Введите название файла со скриптом(без .sh):"
read fileName
if [ -e ~/Scripts/$fileName.sh ]
then
echo "Назовите команду для вызова из консоли(без пробелов)"
read commandName
echo "$commandName () {" >> ~/.bashrc
cat ~/Scripts/$fileName.sh >> ~/.bashrc
echo "
}" >> ~/.bashrc
else
if [ -e ~/Scripts ]
then
echo "Скрипта с таким именем не существует"
else
echo "Папка со скриптами склонирована не в корневой каталог"
fi
fi
