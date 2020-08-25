FROM node:14.8.0-stretch-slim

RUN mkdir /app
WORKDIR /app
COPY . .
RUN npm install

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

CMD ["npm", "start"]
