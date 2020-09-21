$IMAGE_ID="jimbo8098/${Env:IMAGE_NAME}"
$VERSION=(($Env:GITHUB_REF) -replace "master","latest") -replace "refs/heads/",""

echo "docker tag ${Env:IMAGE_NAME} ${IMAGE_ID}:${VERSION}"
echo "docker push ${Env:IMAGE_NAME}:${VERSION}"
docker tag "${Env:IMAGE_NAME}" "${IMAGE_ID}:${VERSION}"
docker push "${Env:IMAGE_NAME}:${VERSION}"