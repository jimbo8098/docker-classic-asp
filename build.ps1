$IMAGE_ID="ghcr.io/${Env:REPO_OWNER}/${Env:IMAGE_NAME}"
$VERSION=(($Env:GITHUB_REF) -replace "master","latest") -replace "refs/heads/",""

# Use Docker `latest` tag convention
if($Env:VERSION -eq "master") { $Env:VERSION="latest"; }

echo "TAG: ${IMAGE_ID}:${VERSION}"

docker tag "${Env:IMAGE_NAME}" "${Env:IMAGE_ID}:${Env:VERSION}"
docker push "${IMAGE_ID}":"${Env:VERSION}"