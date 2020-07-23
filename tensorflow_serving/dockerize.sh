#!/bin/bash

DOCKER_PATH="tensorflow_serving/tools/docker"

docker_build() {
  docker build --pull -t $USER/tensorflow-serving-devel-gpu:20.07.15 --build-arg TF_SERVING_VERSION_GIT_BRANCH=r2.11 --build-arg TF_SERVING_VERSION_GIT_COMMIT=d46ec812c9fd976699d654795191d85dc8bd79aa -f $DOCKER_PATH/Dockerfile.devel-gpu $DOCKER_PATH
  docker build -t $USER/tensorflow-serving-gpu:20.07.15 --build-arg TF_SERVING_BUILD_IMAGE=$USER/tensorflow-serving-devel-gpu:20.07.15 --build-arg TF_SERVING_VERSION_GIT_BRANCH=r2.11 -f $DOCKER_PATH/Dockerfile.gpu $DOCKER_PATH
}

docker_run() {
 docker run -it -p 8500:8500 -p 8501:8501 --name serving_0 --gpus '"device=0"' --mount type=bind,source=/home/sa_104714913194317373801/enko/20200304.hyupjojeon_export,target=/models/enko --mount type=bind,source=/home/sa_104714913194317373801/koen/20200304.hyupjojeon_export,target=/models/koen --mount type=bind,source=/home/sa_104714913194317373801/tf_serving.conf,target=/config/config.conf --mount type=bind,source=/home/sa_104714913194317373801/batching_param.conf,target=/config/batching_param.conf -d -t sa_104714913194317373801/tensorflow-serving-gpu:20.07.15 --model_config_file=/config/config.conf --enable_batching --batching_parameters_file=/config/batching_param.conf;
}

docker_stop() {
  docker stop serving_0
}

docker_rmi() {
  docker rmi $USER/tensorflow-serving-devel-gpu:20.07.15
  docker rmi $USER/tensorflow-serving-gpu:20.07.15
}

if [ "$#" -lt 1 ]; then
  echo "Usage: dockerize.sh {build|run|stop|rmi}"
  exit 1
fi

case "$1" in
  "build")
    docker_build
    ;;
  "run")
    docker_run
    ;;
  "stop")
    docker_stop
    ;;
  "rmi")
    docker_rmi
    ;;
  *)
    echo "Usage: dockerize.sh {build|run|stop|rmi}"
    ;;
esac

