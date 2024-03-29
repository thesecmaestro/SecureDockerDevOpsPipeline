#FROM microsoft/dotnet:2.2.2-aspnetcore-runtime-alpine3.8
 
#WORKDIR /home/app

#COPY ["AccountOwnerServer/bin/Release/netcoreapp2.2/publish", "/home/app"]
#COPY ["Configs/Release/appsettings.json", "/home/app"]
#COPY ["Configs/Release/nlog.config", "/home/app"]
 
#ENTRYPOINT ["dotnet", "AccountOwnerServer.dll"]


FROM microsoft/dotnet as build-image

WORKDIR /home/app

COPY ./*.sln ./
COPY ./*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p ./${file%.*}/ && mv $file ./${file%.*}/; done
 
RUN dotnet restore

COPY . .

#RUN dotnet test ./Tests/Tests.csproj
#RUN dotnet test --verbosity=normal --results-directory /TestResults/ --logger "trx;LogFileName=test_results.xml" ./Tests/Tests.csproj
RUN dotnet test --verbosity=normal --results-directory /TestResults/ --logger "trx;LogFileName=test_results.xml" ./Tests/Tests.csproj

RUN dotnet publish -c Release ./AccountOwnerServer/AccountOwnerServer.csproj -o /publish/

# COPY ["Configs/Release/appsettings.json", "/publish"]
# COPY ["Configs/Release/nlog.config", "/publish"]


FROM microsoft/dotnet:2.2.2-aspnetcore-runtime-alpine3.8
 

WORKDIR /publish
 
COPY --from=build-image /publish .
COPY --from=build-image /TestResults /TestResults
 
ENV TEAMCITY_PROJECT_NAME = ${TEAMCITY_PROJECT_NAME}
 
ENTRYPOINT ["dotnet", "AccountOwnerServer.dll"]
