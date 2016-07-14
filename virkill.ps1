param(
	[bool]$force	
	)

$host.ui.RawUI.WindowTitle = "VirKill"

$scriptpath = $MyInvocation.MyCommand.Path
$storageDir = Split-Path $scriptpath

$webclient = New-Object System.Net.WebClient

$error.clear()
	
$webclient.DownloadString("http://www.google.com") | Out-Null

if($error) { 
cls
Write-Warning "Something went wrong with the download."
Write-Warning "Copying current local files."
exit
} 
 
#Begin BleepingComputer list.
$downloadlinks = @(
                        "http://www.bleepingcomputer.com/download/combofix/dl/12/",
                        "http://www.bleepingcomputer.com/download/adwcleaner/dl/125/",
                        "http://www.bleepingcomputer.com/download/rkill/dl/10/",
                        "http://www.bleepingcomputer.com/download/minitoolbox/dl/65/",
						"http://www.bleepingcomputer.com/download/junkware-removal-tool/dl/293/",
						"http://www.bleepingcomputer.com/download/hijackthis/dl/89/"
					)
                                       
$downloadparse = @(
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/ComboFix.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/AdwCleaner.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/rkill.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/MiniToolBox.exe',
                        'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/JRT.exe',
						'https://download.bleepingcomputer.com/dl/+[\w-]+(/[\w- ./?%&=]*)*/HijackThis.exe'
					)
 
$downloadname = @(
                        "ComboFix",
                        "ADWCleaner",
                        "rkill",
                        "MiniToolBox",
						"JRT",
						"HijackThis"
					)
 
$dlinksarraylength = $downloadlinks.length
$dlinksarraylength--
#End BleepingComputer list.

#Begin Custom Download list.
#Only include static links.
$customdownloadlinks = @(
							'http://dl.emsisoft.com/EmsisoftEmergencyKit.exe',
							'https://downloads.malwarebytes.org/file/mbam_current/',
							'http://data.mbamupdates.com/tools/mbam-rules.exe'
						)
$customdownloadname = @(
							'EmsisoftEmergencyKit',
							'Malwarebytes',
							'Malwarebytes Defintions'
						)

$customdownloadexe = @(
							'EmsisoftEmergencyKit',
							'mbam-setup',
							'mbam-rules'
						)
$customdownloadlength = $customdownloadlinks.length
$customdownloadlength--
#End Custom Download list.

$i = 0
$s = 0
 
while ($i -le $dlinksarraylength)
		{
                $dlink = $downloadlinks[$i]
                $dname = $downloadname[$i]
                $dparse = $downloadparse[$i]
				
				$host.ui.RawUI.WindowTitle = "VirKill (Downloading $dname)"

				Write-host
                Write-host "Downloading $dname"
                Write-host "-------------------"
               
			   $dexist = Test-Path $storageDir\files\$dname.exe
               if ($force -ne "False")
               {
			   if ($dexist -eq "True")
				{
					$dhours = New-Timespan -Start (dir $storageDir\files\$dname.exe).LastWriteTime | Select -ExpandProperty Hours
					if ($dhours -le 6)
					{
					Write-host "Recently updated. ($dhours hour(s) ago)"
					Write-host "Skipping."
					Write-host
					$i++
					continue
					}
				}
                }
				$htmlfile = "$storageDir\Download.html"
                $webclient.DownloadFile($dlink,$htmlfile)
				
				$purl = select-string -Path $storageDir\Download.html -Pattern $dparse | % { $_.Matches} | % { $_.Value} | Select -Skip 1
			
				
                $dfilename = "$storageDir\files\$dname.exe"
                $webclient.DownloadFile($purl,$dfilename)
                Remove-Item "$storageDir\Download.html"
				
                $i++
        }

while ($s -le $customdownloadlength)
		{
                $dlink = $customdownloadlinks[$s]
                $dname = $customdownloadname[$s]
                $dexe = $customdownloadexe[$s]
				
				$host.ui.RawUI.WindowTitle = "VirKill (Downloading $dname)"
				
				Write-host
                Write-host "Downloading $dname"
                Write-host "-------------------"
               
			   $dexist = Test-Path $storageDir\files\$dexe.exe
               if ($force -ne "False")
               {
			   if ($dexist -eq "True")
				{
					$dhours = New-Timespan -Start (dir $storageDir\files\$dexe.exe).LastWriteTime | Select -ExpandProperty Hours
					if ($dhours -le 24)
					{
					Write-host "Recently updated. ($dhours hour(s) ago)"
					Write-host "Skipping."
					Write-host
					$s++
					continue
					}
				}
				}
                $dfilename = "$storageDir\files\$dexe.exe"
                $webclient.DownloadFile($dlink,$dfilename)
               
                $s++
        }
