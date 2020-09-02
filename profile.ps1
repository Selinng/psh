$today = Get-Date
[string]$formatTime = $today.ToString('yyyy-MM-dd HH:mm:ss')
[int]$hour = $today.Hour
[string]$timeSlot
if ($hour -lt 12) {
  $timeSlot = '上午'
}
if (($hour -lt 18) -and ($hour -ge 12)) {
  $timeSlot = '下午'
}
if ($hour -ge 18) {
  $timeSlot = '晚上'
}
Write-Host $timeSlot'好，先生,现在是北京时间'$formatTime