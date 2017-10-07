#!/bin/bash
export USERNAME="ubuntu"

function install_Docker (){
    sudo apt update
    sudo apt install curl
    curl -fsSL htts://get.docker.com/ | sh
    sudo usermod -aG docker $USERNAME
    docker run hello-world
    # Should see, Hello from Docker....
    # If not, 
    # sudo service docker restart
}

function install_DockerCompose () {
    su root -c ./Docker_root_scripts.sh
    docker-compose -v

}
function deploy_WordPress () {
    read -rp 'IP ADDRESS: ' IP_ADDRESS
    read -rsp 'PASSWORD: ' PASSWORD
    mkdir  ~/wordpress-compose

    echo "FROM orchardup/php5
    ADD . /code" >> ~/wordpress-compose/Dockerfile

    echo "
wordpress:
    image: wordpress
    links:
     - mariadb:mysql
    environment:
     - WORDPRESS_DB_PASSWORD=$PASSWORD
    ports:
     - ""$IP_ADDRESS":80:80function " 
    volumes:
     - ./code:/code
     - ./html:/var/www/html
mariadb:
    image: mariadb
    environment:
     - MYSQL_ROOT_PASSWORD=$PASSWORD
     - MYSQL_DATABASE=wordpress
    volumes:
     - ./database:/var/lib/mysql
" >> ~/wordpress-compose/docker-compose.yml
    docker-compose up -d -f ~/wordpress-compose/docker-compose.yml
}

function check_for_Docker_updates (){
    # Check for updates:
    docker-compose pull
    docker-compose up -d -f ~/wordpress-compose/docker-compose.yml
}

function helpful_commands () {
    echo -e "\\n
    # Starts all stopped containers in the work directory \\n
    docker-compose start\\n
    # Stops all currently running containers in the work directory\\n
    docker-compose stop\\n
    # Validates and shows the configuration\\n
    docker-compose config\\n
    # Lists all running containers in the work directory\\n
    docker-compose ps\\n
    # Stops and removes all containers in the work directory\\n
    docker-compose down\\n"
}

function usage () {
    echo ""
    echo "Missing paramter. Please Enter one of the following options"
    echo ""
    echo "Usage: $0 {Any of the options below}"
    echo ""
    echo ""
    echo "  install_Docker"
    echo "     sudo apt update"
    echo "     curl install docker"
    echo "     add user to 'docker' group"
    echo "     run docker hello world"
    echo ""
    echo "  install_DockerCompose"
    echo "     download docker-compose to /usr/local/bin/docker-compose"
    echo "     chmod +x on docker compose"
    echo ""
    echo "  deploy_WordPress"
    echo "     mkdir  ~/wordpress-compose"
    echo "     create ~/wordpress-compose/Dockerfile"
    echo "     create docker-compose.yml"
    echo "     deploy WordPress in background mode"
    echo ""
    echo "  check_for_Docker_updates"
    echo "     Pull service images"
    echo "     Restart the containers"
    echo ""
    echo "  deploy_all"
    echo "     install_Docker"
    echo "     install_DockerCompose"
    echo "     deploy_Docker"

    
    echo "  helpful_commands"
}

function main () {
    echo ""
    echo " Setup WordPress in Docker"
    echo ""
    echo ""

    if [ -z "$1" ]; then
        usage
        exit 1
    fi

    if [ "$1" == "deploy_all" ]; then
        install_Docker
        install_DockerCompose
        deploy_Docker

    else
        case $1 in
        "install_Docker")
            install_Docker
            ;;
        "install_DockerCompose")
            install_DockerCompose
            ;;
        "deploy_WordPress")
            deploy_WordPress
            ;;
        "check_for_Docker_updates")
            check_for_Docker_updates
            ;;
        "helpful_commands")
            helpful_commands
            ;;
        esac
    fi
}

main "$1"
