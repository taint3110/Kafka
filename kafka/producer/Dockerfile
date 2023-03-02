FROM node:16-alpine

WORKDIR /app

COPY package.json .
RUN npm install

COPY producer.js .

CMD ["node", "index.js"]