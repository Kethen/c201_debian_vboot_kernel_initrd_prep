set -xe

IMAGE_TAG=c201_kernel
DOCKER_FILE=Dockerfile

if [ "$REBUILD_IMAGE" == "true" ]
then
	podman image rm -f $IMAGE_TAG
fi

if ! podman image exists $IMAGE_TAG
then
	podman image build --arch armhf -f $DOCKER_FILE -t $IMAGE_TAG 
fi

ROOT="${ROOT:-/dev/mmcblk0p1}"

podman run \
	--arch armhf \
	--rm -it \
	-v ./:/work_dir \
	-v ./prep_podman.sh:/work_dir/prep_podman.sh \
	-v ./prep.sh:/work_dir/prep.sh \
	-w /work_dir \
	--env ROOT="$ROOT" \
	$IMAGE_TAG \
	bash prep.sh
