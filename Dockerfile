FROM mcr.microsoft.com/windows/servercore/iis
SHELL ["powershell", "-command"]

ENV SiteName="test.com"

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*


RUN Install-WindowsFeature Web-ASP;
RUN Install-WindowsFeature Web-ISAPI-Ext;
RUN Install-WindowsFeature Web-ISAPI-Filter;

RUN mkdir c:\inetpub\wwwroot\$SiteName
RUN Remove-Website -Name 'Default Web Site';

RUN Start-IISCommitDelay
RUN New-IISSite -Name "$SiteName" -BindingInformation "*:80:$SiteName" -Protocol http -PhysicalPath "C:\inetpub\wwwroot\$SiteName"
RUN New-IISSiteBinding -name "$SiteName" -BindingInformation "*:80:www.$SiteName" -Protocol http
RUN Stop-IISCommitDelay -Commit 1

RUN Import-Module WebAdministration
RUN Set-ItemProperty IIS:\AppPools\app-pool-name -name processModel -value @{userName="$env:SVCUSER";password="$env:SVCPASS";identitytype=3}

EXPOSE 80
EXPOSE 443

#Need to do this in one operation. Seperate RUN commands fail to build.
RUN Import-Module WebAdministration; if ($?) {\
    Set-ItemProperty 'IIS:\Sites\$SiteName' -Name logFile.enabled -Value False; if ($?) {\
    Set-ItemProperty 'IIS:\Sites\$SiteName' -Name logFile.truncateSize 20971520 }}

WORKDIR /inetpub/wwwroot
COPY $SiteName/ $SiteName/