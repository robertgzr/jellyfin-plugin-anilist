# syntax=docker/dockerfile:1.2-labs

ARG DOTNET_VERSION=5.0
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}-buster-slim AS base

WORKDIR /src
ENV \
    BaseIntermediateOutputPath=/obj/

FROM base AS build
RUN --mount=target=. \
    --mount=type=cache,target=/root/.nuget \
    --mount=type=tmpfs,target=/obj \
    dotnet build --nologo --configuration Debug --output /out

FROM base AS release
RUN --mount=target=.,rw \
    --mount=type=cache,target=/root/.nuget \
    --mount=type=tmpfs,target=/obj \
    dotnet publish --nologo --configuration Release --output /out --force

FROM scratch AS final
COPY --from=release /out/Jellyfin.Plugin* /
COPY --from=release /out/AnitomySharp* /
