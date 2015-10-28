FROM nginx
MAINTAINER Stephen Liang "docker-maint@stephenliang.pw"

ADD default.conf /etc/nginx/conf.d/default.conf

# SSL
ADD ssl /etc/ssl/sites/blog

ENV HEXO_VERSION 3.0.0

# Grab dependencies
RUN apt-get update && apt-get install -y curl &&  rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup | bash - && apt-get update && apt-get install -y curl git nodejs
RUN npm install -g hexo@${HEXO_VERSION}

# Create hexo base files
RUN hexo init /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
RUN npm install

RUN rm -rf source && git clone https://bitbucket.org/simplyintricate/blog-posts.git source
ADD _config.yml /usr/share/nginx/html/_config.yml

CMD hexo generate && nginx -g "daemon off;"
