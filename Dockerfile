FROM mcr.microsoft.com/windows/servercore/iis
SHELL ["powershell", "-command"]

ENV SiteName="test.com"
ENV SVCUSER=testuser
ENV SVCPASS=testpass

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*


RUN Install-WindowsFeature Web-ASP;
RUN Install-WindowsFeature Web-ISAPI-Ext;
RUN Install-WindowsFeature Web-ISAPI-Filter;

RUN mkdir c:\inetpub\wwwroot\$Env:SiteName
RUN Remove-Website -Name 'Default Web Site';

RUN Start-IISCommitDelay
RUN New-IISSite -Name "$Env:SiteName" -BindingInformation "*:80:$Env:SiteName" -Protocol http -PhysicalPath "C:\inetpub\wwwroot\$Env:SiteName"
RUN New-IISSiteBinding -name "$Env:SiteName" -BindingInformation "*:80:www.$Env:SiteName" -Protocol http
RUN Stop-IISCommitDelay -Commit 1

RUN Import-Module WebAdministration
RUN Set-ItemProperty IIS:\AppPools\app-pool-name -name processModel -value @{userName="$env:SVCUSER";password="$env:SVCPASS";identitytype=3}

EXPOSE 80
EXPOSE 443

RUN $env:SecurePass=ConvertTo-SecureString $env:SVCPASS -asplaintext -force; if ($?) {\
    New-LocalUser -Name "$env:SVCUSER" -Password "$env:SecurePass" -Description "$env:SiteName Site User" }

#Need to do this in one operation. Seperate RUN commands fail to build.
RUN Import-Module WebAdministration; if ($?) {\
    Set-ItemProperty "IIS:\Sites\$env:SiteName" -Name logFile.enabled -Value False; if ($?) {\
    Set-ItemProperty "IIS:\Sites\$env:SiteName" -Name logFile.truncateSize 20971520; if ($?) {\
    New-WebAppPool –Name "$env:SiteName"; if ($?) {\
    Set-ItemProperty "IIS:\AppPools\$env:SiteName" -name processModel -value @{userName="$env:SVCUSER";password="$env:SVCPASS";identitytype=3}; if ($?) {\
    Stop-WebAppPool $env:SiteName; if ($?) {\
    Start-WebAppPool; }}}}}}

WORKDIR /inetpub/wwwroot
COPY $Env:SiteName/ $Env:SiteName/