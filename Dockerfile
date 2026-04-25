# BASE RUNTIME 
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

#  For ECS ALB, we need to listen on port 8080 instead of the default 80
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080


FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish


FROM base AS final
WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "aspnet-api-app.dll"]
