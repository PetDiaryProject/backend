#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["petdiary.csproj", "."]
RUN dotnet restore "./petdiary.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "petdiary.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "petdiary.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ["dotnet", "petdiary.dll"]