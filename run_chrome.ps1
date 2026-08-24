$ErrorActionPreference = 'Stop'

Write-Host 'Preparing CIANTIS Calendar for Chrome...'

flutter config --enable-web

if (-not (Test-Path 'web')) {
  flutter create . --platforms=web
}

flutter pub get
flutter run -d chrome
