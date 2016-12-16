param ([switch]$DEV,$modulepathmodifier='modules',$configpathmodifier='config')
if ( $DEV) #Used to indicate that the system this is being run on should be recognized as a dev system, in other scripts I use this flag to modify the behavior
{ 
    [Environment]::SetEnvironmentVariable("DBMS_DEV", $true, "Machine") 
    $env:DBMS_DEV = $true
}
if ($PSCommandPath -notlike "*beta*" )
{
    #Gets the current module path that is set and detects if the scriptroot + modifier are in place
    $CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
    $modulepath = $(Get-ChildItem $psscriptroot\..\.. | Where-Object { $_ -like "*$modulepathmodifier*" }).fullname
    if ($currentvalue -notlike "*$modulepath*" ) 
    { 
        [Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + ";$modulepath", "Machine") 
    }
    #Gets the current config path that is set and detects if the scriptroot + modifier are in place
    $CurrentConfigValue = [Environment]::GetEnvironmentVariable("ConfigPath", "Machine")
    $configpath = $($($(Get-ChildItem $psscriptroot\..\..\..\$configpathmodifier -File)[0]).directory).fullname
    if ($currentvalue -notlike "*$configpath*" ) 
    { 
        [Environment]::SetEnvironmentVariable("ConfigPath", $configpath, "Machine") 
    }
    $env:PSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
    $env:dbmsconfigpath = [Environment]::GetEnvironmentVariable("ConfigPath", "Machine")
}