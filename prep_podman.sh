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

# options
ROOT="${ROOT:-/dev/mmcblk0p1}"
ROOTFSTAR="${ROOTFSTAR:-false}"
ROOTFS="${ROOTFS:-ext4}"
ROOTFSOPT="${ROOTFSOPT:-defaults}"
USE_KDE="${USE_KDE:-true}"

podman run \
	--arch armhf \
	--rm -it \
	-v ./:/work_dir \
	-v ./prep_podman.sh:/work_dir/prep_podman.sh \
	-v ./prep.sh:/work_dir/prep.sh \
	-v ./mkc201vboot:/work_dir/mkc201vboot:ro \
	-v ./firmware:/work_dir/firmware:ro \
	-w /work_dir \
	--env ROOT="$ROOT" \
	--env ROOTFSTAR="$ROOTFSTAR" \
	--env ROOTFS="$ROOTFS" \
	--env ROOTFSOPT="$ROOTFSOPT" \
	localhost/$IMAGE_TAG \
	bash prep.sh
