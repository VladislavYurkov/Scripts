#Коммитит все изменения в папке проекта
#Советую называть скрипт commit
#В этом случае можно будет вызвать его из консоли написав commit "Текст коммита"

git add .
git commit -m "$1"
branchName=$(git symbolic-ref --short HEAD)
git push origin $branchName

