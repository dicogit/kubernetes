sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker
if [ -d "docker" ];
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/docker
    #git pull origin addrbook
    git checkout docker_addrbook
else
    git clone https://github.com/dicogit/docker.git
    cd /home/ec2-user/docker
    git pull origin docker_addrbook
    git checkout docker_addrbook
fi
mvn package
sudo cp /home/ec2-user/docker/target/addressbook.war /home/ec2-user/docker/
sudo docker build -t $1 /home/ec2-user/docker/
