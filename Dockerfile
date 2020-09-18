FROM mcr.microsoft.com/windows/servercore/iis
SHELL ["powershell", "-command"]

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

ARG SITENAME="test.com"
ARG SVCUSER="testuser"
ARG SVCPASS="P@ssW0rd"


RUN Install-WindowsFeature Web-ASP;
RUN Install-WindowsFeature Web-ISAPI-Ext;
RUN Install-WindowsFeature Web-ISAPI-Filter;

RUN mkdir c:\inetpub\wwwroot\${env:SITENAME}
RUN Remove-Website -Name 'Default Web Site';

RUN Start-IISCommitDelay
RUN New-IISSite -Name "${env:SITENAME}" -BindingInformation "*:80:${env:SITENAME}" -Protocol http -PhysicalPath "C:\inetpub\wwwroot\${env:SITENAME}"
RUN New-IISSiteBinding -name "${env:SITENAME}" -BindingInformation "*:80:www.${env:SITENAME}" -Protocol http
RUN Stop-IISCommitDelay -Commit 1

EXPOSE 80
EXPOSE 443

RUN $SecurePass=ConvertTo-SecureString "$env:SVCPASS" -AsPlainText -Force; if ($?) {\
    New-LocalUser -Name "$env:SVCUSER" -Password $SecurePass }

#Need to do this in one operation. Seperate RUN commands fail to build.
RUN Import-Module WebAdministration; if ($?) {\
    Set-ItemProperty "IIS:\Sites\$env:SITENAME" -Name logFile.enabled -Value False; if ($?) {\
    Set-ItemProperty "IIS:\Sites\$env:SITENAME" -Name logFile.truncateSize 20971520; if ($?) {\
    New-WebAppPool –Name "${env:SITENAME}"; if ($?) {\
    Set-ItemProperty "IIS:\AppPools\$env:SITENAME" -name processModel -value @{userName="${env:SVCUSER}";password="${env:SVCPASS}";identitytype=3}; if ($?) {\
    Stop-WebAppPool "$env:SITENAME"; if ($?) {\
    Start-WebAppPool "$env:SITENAME"; }}}}}}

WORKDIR /inetpub/wwwroot
COPY $SITENAME/ $SITENAME/