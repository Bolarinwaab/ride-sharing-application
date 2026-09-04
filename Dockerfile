FROM node:20-alpine
WORKDIR /app
COPY package.json ./
COPY src ./src
COPY test ./test
RUN npm test
CMD ["node","-e","console.log('RideNow API container ready; connect service routes here')"]
