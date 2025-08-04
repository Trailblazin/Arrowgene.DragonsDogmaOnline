#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish?tabs=netcore2x
read -r VERSION<ddon.version
mkdir ./release
for RUNTIME in linux-x64 osx-x64; do
	# Build Server
	if dotnet build Arrowgene.Ddon.Cli\Arrowgene.Ddon.Cli.csproj  --configuration Release; then
      # Publish Server Files
	  dotnet publish Arrowgene.Ddon.Cli\Arrowgene.Ddon.Cli.csproj /p:Version=%VERSION% --runtime %%x --self-contained --output ./publish/%%x-%VERSION%/Server
      # ReleaseFiles
      cp -r ./ReleaseFiles/. ./publish/$RUNTIME-$VERSION/
      # Pack
      tar cjf ./release/$RUNTIME-$VERSION.tar.gz ./publish/$RUNTIME-$VERSION
	else
	  echo "Build failed for runtime: ${RUNTIME}!"
done 