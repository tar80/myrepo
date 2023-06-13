Set-Service -Name wuauserv -StartupType Disabled
Stop-Service -Name wuauserv

Set-MpPreference -DisableCatchupFullScan $True
Set-MpPreference -DisableCatchupQuickScan $True
Set-MpPreference -DisableScanningNetworkFiles $True
Set-MpPreference -DisableRealtimeMonitoring $True

# 7=Saturday
Set-MpPreference -ScanScheduleDay 7

# Remediation完了後のフルスキャン
# 8=never
Set-MpPreference -RemediationScheduleDay 8

# スキャン日時
Set-MpPreference -ScanScheduleTime "01:00:00"
Set-MpPreference -ScanScheduleQuickScanTime "03:00:00"

# 1=quick, 2=full
Set-MpPreference -ScanParameters 1

# NTFS アクセス時のリアルタイム保護のスキャン方向
# 0=both, 1=inbound, 2=outbound
Set-MpPreference -RealTimeScanDirection 1

Set-MpPreference -ExclusionExtension css,html,js,ts,py,rb,md,txt,yml,yaml,json,rst,lib,obj,db,pyc
Set-MpPreference -ExclusionPath "c:\bin\repository", "C:\bin\scoop\apps"
