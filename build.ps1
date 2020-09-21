$IMAGE_ID="${Env:CR_USER}/${Env:IMAGE_NAME}"
$VERSION=(($Env:GITHUB_REF) -replace "master","latest") -replace "refs/heads/",""

echo "${Env:CR_PAT} | docker login -u ${Env:CR_USER} --password-stdin"
echo "${Env:CR_PAT}" | docker login -u ${Env:CR_USER} --password-stdin
docker tag "${Env:IMAGE_NAME}" "${IMAGE_ID}:${VERSION}"
docker push "${Env:IMAGE_ID}:${VERSION}"