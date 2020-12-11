#requires -Version 2 -Modules posh-git
# 对Paradox主题进行自定制的一些改动，放到PowerShell\Modules\oh-my-posh\${version}\Themes\目录下即可
function Write-Theme {
  param(
      [bool]
      $lastCommandFailed,
      [string]
      $with
  )

  $lastColor = $sl.Colors.PromptBackgroundColor
  $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

  #check the last command state and indicate if failed
  If ($lastCommandFailed) {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
  }

  #check for elevated prompt
  If (Test-Administrator) {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
  }

  $user = $sl.CurrentUser
  $computerEmoji = '💻 '
  $computer = $sl.CurrentHostname
  $path = Get-FullPath -dir $pwd
  if (Test-NotDefaultUser($user)) {
      $prompt += Write-Prompt -Object "$user$computerEmoji@$computer " -ForegroundColor $sl.Colors.SessionInfoForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
  }

  if (Test-VirtualEnv) {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
  }
  else {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
  }

  # Writes the drive portion
  $prompt += Write-Prompt -Object "$path " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

  $status = Get-VCSStatus
  if ($status) {
      $themeInfo = Get-VcsInfo -status ($status)
      $lastColor = $themeInfo.BackgroundColor
      $prompt += Write-Prompt -Object $($sl.PromptSymbols.SegmentForwardSymbol) -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
      $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
  }

  # Writes the postfix to the prompt
  $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor

  $timeStamp = Get-Date -UFormat %R
  $clock = "🕥"
  $timestamp = "$clock $timeStamp"

  # $prompt += Set-CursorForRightBlockWrite -textLength ($timestamp.Length + 1)
  # $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.PromptForegroundColor
  $prompt += Set-CursorForRightBlockWrite -textLength $timestamp.Length
  $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.DriveForegroundColor

  $prompt += Set-Newline

  if ($with) {
      $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
  }
  $prompt += Write-Prompt -Object (getRandomEmoji) -ForegroundColor $sl.Colors.PromptBackgroundColor
  $prompt += ' '
  $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.StartSymbol = ''
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.PromptSymbols.HomeSymbol = '🏠'
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptSymbolColor = [ConsoleColor]::red
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.GitForegroundColor = [ConsoleColor]::White
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White
$sl.Colors.SessionInfoBackgroundColor = [System.ConsoleColor]::Transparent

