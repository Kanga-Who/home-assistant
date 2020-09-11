    echo "Docker-ce"
    read name

    dpkg -s $name &> /dev/null  

    if [ $? -ne 0 ]

        then
            echo "Docker-ce is not present - installing now"  
            curl -fsSL get.docker.com | sh

        else
            echo    "Docker-CE is already installed"
    fi
