#Настраивает github
#В конце процесса вам нужно будет войти в свой github аккаунт
#Когда вы войдёте появится страница добавления ssh ключа
#Ваш новосозданный ключ уже находится в буфере(его можно вставить комбинацией клавиш ctrl + V)

echo "Enter your github name:"
read userName
echo "Enter your email:"
read userEmail

sudo apt-get install git -y

sudo apt install xclip -y

git config --global user.name "$userName"
git config --global user.email $userEmail
git config --global init.defaultBranch main

ssh-keygen -t rsa -b 4096 -C "$userEmail"

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

cat << end >> ~/.ssh/config
Host github.com-$userName
HostName github.com
User git
IdentityFile ~/.ssh/id_rsa.pub
end

cat ~/.ssh/id_rsa.pub|xclip -i -selection clipboard

firefox https://github.com/settings/ssh/new

