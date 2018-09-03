# use node:9-alpine image as parent image
FROM node:9-alpine as builder

# Runtime arguments
ARG VERSION

ARG TEST

RUN echo ${VERSION}
RUN echo ${TEST}

# set the wrking directory to app
WORKDIR /app

# copy the current directory contents to the container at /app
COPY ./ /app

RUN ls -lrt


# Installign CLI tools
RUN npm install -g json

# setting up ./npmrc and installing node_moduls
RUN touch .npmrc \
    && echo '@dineth:registry=http://10.1.11.37:8081/artifactory/api/npm/npm/' >> .npmrc \
    && echo "//10.1.11.37:8081/artifactory/api/npm/npm/:_password=QVAyRzZtakdCcVhTQlBvcGdITERGaGNIZUx0" >> .npmrc \
    && echo "//10.1.11.37:8081/artifactory/api/npm/npm/:username=admin" >> .npmrc \
    && echo '//10.1.11.37:8081/artifactory/api/npm/npm/:email=youremail@email.com' >> .npmrc \
    && echo '//10.1.11.37:8081/artifactory/api/npm/npm/:always-auth=true' >> .npmrc \
    && cp .npmrc ~/.npmrc 

RUN json -I -f ./package.json -e 'this.version="'${VERSION}'"'

RUN mkdir dist 
RUN cp package.json ./dist 
RUN cp index.js ./dist 
RUN cd dist/ 
RUN npm publish
