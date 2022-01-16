# build environment
FROM node:lts-alpine3.14 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# install from package.json
COPY ../package.json package-lock.json ./
RUN npm install

# copy everything from the build environment to the workdir
COPY .. ./

# run the build
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]