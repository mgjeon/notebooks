# NVIDIA Modulus

https://docs.nvidia.com/modulus/index.html

https://github.com/NVIDIA/modulus

```
docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --runtime nvidia -v ${PWD}:/workspace -it --rm nvcr.io/nvidia/modulus/modulus:24.12 bash
```