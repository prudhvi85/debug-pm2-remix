FROM --platform=linux/amd64 node:20-alpine as builder
WORKDIR /app

COPY package.json yarn.lock tsconfig.json \
    tailwind.config.ts postcss.config.cjs \
    vite.config.ts   ./

COPY app ./app

COPY public ./public
RUN yarn install
RUN yarn build
COPY ecosystem.config.cjs  ./
# EXPOSE 3120
# CMD ["remix-serve", "build/index.js"]


FROM --platform=linux/amd64 node:20-alpine
WORKDIR /app
# Install remix globally
RUN yarn global add remix pm2
RUN yarn global add @remix-run/serve
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/ecosystem.config.cjs ./ecosystem.config.cjs

EXPOSE 3120

#CMD ["remix-serve", "build/index.js"]
CMD ["pm2-runtime", "ecosystem.config.cjs"]