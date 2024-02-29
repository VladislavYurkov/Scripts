# Гайд по скриптам
## Для добавления скриптов:
1. Откройте файл .bashrc введя в консоль:
```
code .bashrc
```

2. Пролистайте его в конец
3. Напишите в конце файла комманду по шаблону:
```
name_of_command()
{

}
```
4. Внутрь фигурных скобок скопируйте файл с нужным для вас скриптом
5. Сохраните файл .bashrc и перезагрузите Linux


## Добавление кнопок для вызова скриптов в VSCode:
1. Запустите VSCode
2. Зайдите в расширения 
![Расширения](https://github.com/VladislavYurkov/Scripts/assets/104719530/5ed0e1b2-2846-4cd9-9c9d-86d5b32cebf8)
3. Скачайте расширение VSCode Action Buttons Ext
![изображение](https://github.com/VladislavYurkov/Scripts/assets/104719530/b3964903-42bf-46a4-8d10-71ce1ad98fd5)
4. Зайдите в настройки
![Настройки](https://github.com/VladislavYurkov/Scripts/assets/104719530/242370c1-5f74-4b98-905f-ac40d6e4faf0)
5. Нажмите VSCode Action Buttons
![Кнопки](https://github.com/VladislavYurkov/Scripts/assets/104719530/bfd49ddb-7525-47b9-ae04-d9d8e4e0caa0)
6. Перейдите в файл settings.json
![JSON](https://github.com/VladislavYurkov/Scripts/assets/104719530/0c03c5ae-1c8f-4028-adb2-19e0d6e0b6c0)
7. Вставляем следующий текст в commands, как на скриншоте:
![InJSON](https://github.com/VladislavYurkov/Scripts/assets/104719530/9ca02d58-7ab2-4d50-9042-17d08946c100)
```
{
  "name": "new class",
  "color": "#2d58f7",
  "useVsCodeApi": false,
  "command": "create_class "
}
```

  <b>Изменяя поле "name" изменяется название кнопки</b>

  <b>Поле "color" меняет цвет кнопки</b>

  <b>В поле "command" нужно вписать название вызываемой комманды (тот самый name_of_command)</b>

8. Сохраняяем файл settings.json и нажимаем на кнопку перезагруки в нижней панели
![Перезагрузка](https://github.com/VladislavYurkov/Scripts/assets/104719530/02ac0163-00ea-4f19-a2b5-2ce5f933c932)


<h3>Пишите мне, если заметили ошибку в работе скрипта или хотите чтобы я написал новый</h3>
