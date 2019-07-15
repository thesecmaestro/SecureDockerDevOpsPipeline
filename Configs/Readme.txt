docker --version
docker images – lists all Docker images on your machine
docker ps – lists all running Docker containers on your machine
docker ps -a – lists all the attached but not running containers
docker --help – Docker help (no s..t Sherlock)
docker logs <container_name> – outputs the container logs (useful when running the container in a detached mode for example)
docker events – outputs the events that happen on the server, depending on the Docker object (attach, detach, copy, pull…)
docker stop <container_name> – stops the container by name
docker rm <container_name> – removes the container by name
docker rmi <image_id> – removes the image
docker rmi $(docker images -q -f dangling=true) -- force – removes all the images that are not tagged
docker rm $(docker ps -a -q) – removes all containers
docker rmi -f $(docker images -a -q) – removes all images

docker exec -it bc6fdf5178ce sh

docker build -t accountownerservice .
docker build --no-cache -t accountownerservice:build .
docker run -p 8080:80 accountownerservice
docker run --rm -it -p 8080:80 accountownerservice:build

docker-compose up -d
docker-compose up --build -d
docker-compose down
docker-compose flag -v  # This flag will tell Docker Compose explicitly to destroy any volumes created by the containers.

docker volume create my-vol  # Create a Volume
docker volume ls  # List a volume
docker volume inspect <volume name>  # inspect a volume
docker volume rm <volume name>  # remove a volume