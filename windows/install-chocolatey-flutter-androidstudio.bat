@echo off
setlocal enabledelayedexpansion

rem レジストリキーの設定
rem set Key="HKCU\Environment"
set Key="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
rem システム環境変数Pathの取得
for /F "usebackq tokens=2*" %%A IN (`reg query %Key% /v PATH`) Do set CurrPath=%%B
rem Pathがセミコロンで終わっていない場合は追加する
if not "%CurrPath:~-1%" == ";" (
  set "CurrPath=%CurrPath%;"
)


echo 1. Chocolatey のインストール
where /q choco
if %ERRORLEVEL% == 0 (
  echo 1.1 Chocolatey はインストール済みです
) else (
  echo 1.1 Chocolatey はインストールされていません
  echo 1.2 Chocolatey をインストールします
  @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  echo 1.3 chocolatey の準備ができました
)
timeout /t 3 /nobreak
echo;


echo 2. Android Studio のインストール
choco list --local-only | find "androidstudio" >NUL
if %ERRORLEVEL% == 0 (
  echo 2.1 Android Studio はインストール済みです
) else (
  echo 2.1 Android Studio はインストールされていません
  echo 2.2 Android Studio をインストールします
  choco install -y androidstudio
  echo 2.3 Android Studio のインストールが完了しました
)
timeout /t 3 /nobreak
echo;


echo 3. Flutter のインストール
where /q flutter
if %ERRORLEVEL% == 0 (
  echo 3.1 Flutter はインストール済みです
) else (
  echo 3.1 Flutter はインストールされていません
  echo 3.2 Flutter をインストールします
  choco install -y flutter
  echo 3.3 Flutter を環境変数 Path に追加します
  set CurrPath=!CurrPath!C:\tools\flutter\bin
  setx Path "!CurrPath!" /M
  path !Path!;C:\tools\flutter\bin
  echo 3.4 Flutter の準備ができました
)
timeout /t 3 /nobreak
echo;


echo 4. Flutter の更新とチャンネルチェック
flutter channel | find "* stable" >NUL
if %ERRORLEVEL% == 0 (
  echo 4.1 Flutter は stable チャンネルに設定されています
  echo 4.2 Flutter を beta チャンネルに移行します
  flutter channel beta
  echo 4.3 Flutter のWebドライバーを有効にします
  flutter config --enable-web
  echo 4.4 Flutter を最新状態に更新します
  flutter upgrade
  echo 4.5 Flutter が最新状態になりました
) else (
  echo 4.1 Flutter は 開発版チャンネルに設定されています
  echo 4.2 Flutter のWebドライバーを有効にします
  flutter config --enable-web
  echo 4.3 Flutter を最新状態に更新します
  flutter upgrade
  echo 4.4 Flutter が最新状態になりました
)
timeout /t 3 /nobreak
echo;


echo 5. Flutter の設定状況を確認します
flutter doctor
timeout /t 3 /nobreak
echo;


echo インストールを終了します
pause
refreshenv
