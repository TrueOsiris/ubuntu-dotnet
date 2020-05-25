FROM ubuntu:19.10
MAINTAINER tim@chaubet.be
LABEL dotnet-version="3.1.4"

ENV TZ 'Europe/Brussels'

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && echo $TZ > /etc/timezone \
 && apt-get install -y net-tools \
                       iputils-ping \
                       curl \
                       wget \
                       unzip \
                       tzdata 
RUN DEBIAN_FRONTEND=noninteractive curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
 && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg 
RUN DEBIAN_FRONTEND=noninteractive wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
 && wget https://packages.microsoft.com/config/ubuntu/19.10/prod.list \
 && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list 
RUN DEBIAN_FRONTEND=noninteractive chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
 && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
 && sudo dpkg -i packages-microsoft-prod.deb 
# && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-artful-prod artful main" > /etc/apt/sources.list.d/dotnetdev.list' \
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y apt-transport-https
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y dotnet-sdk-3.1
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y aspnetcore-runtime-3.1
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y dotnet-runtime-3.1
                       
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["tail", "-f", "/dev/null"]
CMD ["bash"]
