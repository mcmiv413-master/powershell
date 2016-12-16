[cmdletbinding()]
$scriptpathmodifier = "scripts"
$modulepathmodifier = "scripts\modules"
$scriptpathmodifier = "config"

$scriptroot = $MyInvocation.PSScriptRoot 
write-warning $psscriptroot
$rootdirparts = $($scriptroot.split("\"))
$rootdir = ''
$flag = 0
foreach ( $rootdirpart in $rootdirparts )
{
    if ( $rootdirpart -like "$scriptpathmodifier" ) { $flag = 1 } 
    if ($flag -notlike "1" ) { $rootdir += "$rootdirpart\" }
} 
#$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
$moduleroot = $psscriptroot
if ($moduleroot -notlike "*$rootdir*")
{
    if(test-path $("$rootdir" + "$scriptpathmodifier")){$env:dbmsconfigpath = "$rootdir" + "$scriptpathmodifier"}
    if(test-path $("$rootdir" + "$modulepathmodifier"))
    {
        $currentmodpath = $($env:psmodulepath.split(';') | where { $_ -like "*$modulepathmodifier*"}) -replace "\\",'\\'
        $env:PSModulePath = $env:psmodulepath -replace "$currentmodpath",$("$rootdir" + "$modulepathmodifier")
    }
    #write-warning "$env:psmodulepath"
    import-module AutoReloadModule -force
    return
}
else { if ($scriptroot -like "$null") { Write-warning "Unable to determine script path loading $pscommandpath by default" } }