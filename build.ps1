set IMAGE_ID="ghcr.io/${{ github.repository_owner }}/${Env:IMAGE_NAME}"
set VERSION=$Env:GITHUB_REF

# Use Docker `latest` tag convention
if($Env:VERSION -eq "master") { $Env:VERSION="latest"; }

echo "Image Name=${Env:IMAGE_NAME}"
echo "IMAGE_ID=${Env:IMAGE_ID}"
echo "IMAGE_ID=$env:IMAGE_ID"
echo "IMAGE_ID=$IMAGE_ID"
echo "Version= ${Env:Version}"


echo "TAG: ${IMAGE_ID}:${VERSION}"

docker tag "${Env:IMAGE_NAME}" "${Env:IMAGE_ID}:${Env:VERSION}"
docker push "${IMAGE_ID}":"${Env:VERSION}"