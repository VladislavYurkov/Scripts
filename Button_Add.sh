echo "Введите название файла со скриптом(без .sh):"
read fileName
if [ -e ~/Scripts/$fileName.sh ]
then
echo "Назовите кнопку:"
read buttonName
echo "Напишите желаемый цвет кнопки(на английском языке)"
read buttonColor
echo "$fileName () {" >> ~/.bashrc
cat ~/Scripts/$fileName.sh >> ~/.bashrc
echo "
}" >> ~/.bashrc

settings="/home/$USER/.config/Code/User/settings.json"
if grep -q "actionButtons" $settings
then
echo ""
else
sed -i '$d' $settings
cat << end >> $settings
	,
    "actionButtons": {
        "commands": [
        ],
        "defaultColor": "white",
        "reloadButton": "↻",
        "loadNpmCommands": false
    },
}
end
fi

search="\"commands\": \["

replace="\"commands\": [\n\t\t{\n\t\t\t\"name\": \"$buttonName\",\n\t\t\t\"color\": \"$buttonColor\",\n\t\t\t\"useVsCodeApi\": false,\n\t\t\t\"command\": \"$fileName \"\n\t\t},"

sed -i "s/$search/$replace/" $settings

else
if [ -e ~/Scripts ]
then
echo "Скрипта с таким именем не существует"
else
echo "Папка со скриптами склонирована не в корневой каталог"
fi
fi
