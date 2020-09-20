$IMAGE_ID="ghcr.io/${Env:REPO_OWNER}/${Env:IMAGE_NAME}"
$VERSION=(($Env:GITHUB_REF) -replace "master","latest") -replace "refs/heads/",""

docker tag "${Env:IMAGE_NAME}" "${Env:IMAGE_ID}:${Env:VERSION}"
echo "docker push ${Env:IMAGE_ID}:${Env:VERSION}"
docker push "${Env:IMAGE_ID}":"${Env:VERSION}"