$IMAGE_ID="ghcr.io/${Env:REPO_OWNER}/${Env:IMAGE_NAME}"
$VERSION=(($Env:GITHUB_REF) -replace "master","latest") -replace "refs/heads/",""

docker tag "${Env:IMAGE_NAME}" "${IMAGE_ID}:${VERSION}"
echo "docker push ${IMAGE_ID}:${VERSION}"
docker push "${IMAGE_ID}":"${VERSION}"