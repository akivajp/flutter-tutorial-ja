@echo off
setlocal enabledelayedexpansion

rem ���W�X�g���L�[�̐ݒ�
rem set Key="HKCU\Environment"
set Key="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
rem �V�X�e�����ϐ�Path�̎擾
for /F "usebackq tokens=2*" %%A IN (`reg query %Key% /v PATH`) Do set CurrPath=%%B
rem Path���Z�~�R�����ŏI����Ă��Ȃ��ꍇ�͒ǉ�����
if not "%CurrPath:~-1%" == ";" (
  set "CurrPath=%CurrPath%;"
)


echo 1. Chocolatey �̃C���X�g�[��
where /q choco
if %ERRORLEVEL% == 0 (
  echo 1.1 Chocolatey �̓C���X�g�[���ς݂ł�
) else (
  echo 1.1 Chocolatey �̓C���X�g�[������Ă��܂���
  echo 1.2 Chocolatey ���C���X�g�[�����܂�
  @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  echo 1.3 chocolatey �̏������ł��܂���
)
timeout /t 3 /nobreak
echo;


echo 2. Android Studio �̃C���X�g�[��
choco list --local-only | find "androidstudio" >NUL
if %ERRORLEVEL% == 0 (
  echo 2.1 Android Studio �̓C���X�g�[���ς݂ł�
) else (
  echo 2.1 Android Studio �̓C���X�g�[������Ă��܂���
  echo 2.2 Android Studio ���C���X�g�[�����܂�
  choco install -y androidstudio
  echo 2.3 Android Studio �̃C���X�g�[�����������܂���
)
timeout /t 3 /nobreak
echo;


echo 3. Flutter �̃C���X�g�[��
where /q flutter
if %ERRORLEVEL% == 0 (
  echo 3.1 Flutter �̓C���X�g�[���ς݂ł�
) else (
  echo 3.1 Flutter �̓C���X�g�[������Ă��܂���
  echo 3.2 Flutter ���C���X�g�[�����܂�
  choco install -y flutter
  echo 3.3 Flutter �����ϐ� Path �ɒǉ����܂�
  set CurrPath=!CurrPath!C:\tools\flutter\bin
  setx Path "!CurrPath!" /M
  path !Path!;C:\tools\flutter\bin
  echo 3.4 Flutter �̏������ł��܂���
)
timeout /t 3 /nobreak
echo;


echo 4. Flutter �̍X�V�ƃ`�����l���`�F�b�N
flutter channel | find "* stable" >NUL
if %ERRORLEVEL% == 0 (
  echo 4.1 Flutter �� stable �`�����l���ɐݒ肳��Ă��܂�
  echo 4.2 Flutter �� beta �`�����l���Ɉڍs���܂�
  flutter channel beta
  echo 4.3 Flutter ��Web�h���C�o�[��L���ɂ��܂�
  flutter config --enable-web
  echo 4.4 Flutter ���ŐV��ԂɍX�V���܂�
  flutter upgrade
  echo 4.5 Flutter ���ŐV��ԂɂȂ�܂���
) else (
  echo 4.1 Flutter �� �J���Ń`�����l���ɐݒ肳��Ă��܂�
  echo 4.2 Flutter ��Web�h���C�o�[��L���ɂ��܂�
  flutter config --enable-web
  echo 4.3 Flutter ���ŐV��ԂɍX�V���܂�
  flutter upgrade
  echo 4.4 Flutter ���ŐV��ԂɂȂ�܂���
)
timeout /t 3 /nobreak
echo;


echo 5. Flutter �̐ݒ�󋵂��m�F���܂�
flutter doctor
timeout /t 3 /nobreak
echo;


echo �C���X�g�[�����I�����܂�
pause
refreshenv
