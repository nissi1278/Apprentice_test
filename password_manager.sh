echo "パスワードマネージャーへようこそ！"
pass="$HOME/.password.txt"
encrypt_pass="$HOME/.password.txt.gpg"

while true; do
    # パスワードファイルが存在しない場合、作成。
    if [ ! -f "$pass" ] && [ ! -f "$encrypt_pass" ]; then
        touch "$pass"
        chmod 600 "$pass"
        #パスワードの圧縮化にgpg(AES256)を使用
        gpg --symmetric --cipher-algo AES256 "$pass"
        rm "$pass"
    fi

    read -p "次の選択肢から入力してください(Add Password/Get Password/Exit):" action
    case "$action" in
        "Add Password")
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
            if [ -n "$user_name" ]; then
                break
            else
                echo "エラー：ユーザー名が入力されていません。"
            fi
        done
        while true; do
                read -p "パスワードを入力してください：" password
                if [ -n "$password" ]; then
                    break
                else
                    echo "エラー：パスワードが入力されていません。"
                fi
        done

        # 暗号化されたファイルを一旦復号化
        gpg --quiet --batch --yes --decrypt --passphrase="$GPG_PASSPHRASE" --output "$pass" "$encrypt_pass"

        echo "${service_name}:${user_name}:${password}" >> "$pass"

        # ファイルを再度暗号化し、元ファイルは削除。
        gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase="$GPG_PASSPHRASE" "$pass"
        rm "$pass"

        echo "パスワードの追加は成功しました。"
        ;;
    "Get Password")
        read -p "登録しているサービス名を入力してください。" service_name

        # 暗号化されたファイルを一旦復号化
        gpg --quiet --batch --yes --decrypt --passphrase="$GPG_PASSPHRASE" --output "$pass" "$encrypt_pass"

        #データの存在チェック&データ取得
        if grep -q "^${service_name}:" "${pass}"; then
            #awk -Fオプションで:を区切り文字として指定
             grep "^${service_name}:" "$pass" | awk -F: '{print "サービス名：" $1 "\nユーザー名：" $2 "\nパスワード：" $3}'
        else
            echo "エラー：そのサービスは登録されていません。"
        fi

        #復号化したファイルは削除
        rm "$pass"
        ;;
    "Exit")
        echo "Thank you!"
        exit 0
        ;;
    *)
        echo "エラー：入力が間違えています。 Add Password / Get Password / Exit のいずれかを入力してください。"
        ;;
    esac
done
