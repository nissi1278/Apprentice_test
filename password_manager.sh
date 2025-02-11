echo "パスワードマネージャーへようこそ！"
pass="$HOME/.password.txt"
if [ ! -f "$pass" ]; then
touch "$pass"
        chmod 777 "$pass"
fi
while true; do
    read -p "サービス名を入力してください：" service_name
    if [ -n "$service_name" ]; then
        break
    else
        echo "エラー：サービス名が入力されていません。"
    fi
done

while true; do
    read -p "ユーザー名を入力してください：" user_name
    if [ -n "user_name" ]; then
        break
    else
        echo "エラー：ユーザー名が入力されていません。"
    fi
done

while true; do
        read -p "パスワードを入力してください：" password
        if [ -n "password" ]; then
                break
        else
                echo "エラー：パスワードが入力されていません。"
        fi
done
echo "Thank you!"        
echo "${service_name}:${user_name}:${password}" >> "$pass"