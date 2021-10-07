FROM node:latest
ENV NODE_ENV=production
COPY package.json ./
RUN npm install --production
COPY . . 
CMD [ "node", "index.js" ]