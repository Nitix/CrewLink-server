# ottomated/crewlink-server

#Stage build
FROM node:14-alpine as build

# Folder used for build
RUN mkdir /build

# Change to the /build directory *and* make it the default execution directory
WORKDIR /build

# Copy the repo contents from the build context into the image
COPY ./ /build/

# Install NPM packages
RUN yarn install

# Compile project
RUN yarn compile

# Stage prod
FROM node:14-alpine

# Set env to production for yarn and node
ENV NODE_ENV=production

# Make a directory for the app, give node user permissions
RUN mkdir /app && chown node:node /app

# Change to the /app directory *and* make it the default execution directory
WORKDIR /app

# Do all remaining actions as node, and start the image as node
USER node

# Copy the repo contents from the build context into the image
COPY ./ /app/

# Copy build files
COPY --chown=node:node  --from=build /build/dist/ /app/dist/

# Install NPM packages
RUN yarn install

# Tell the Docker engine the default port is 9736
EXPOSE 9736

# Run the app when the container starts
CMD ["node", "dist/index.js"]
