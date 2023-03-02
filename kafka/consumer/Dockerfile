FROM node:16-alpine

WORKDIR /app

COPY package.json .
RUN npm install

COPY consumer.js .

CMD ["node", "index.js"]