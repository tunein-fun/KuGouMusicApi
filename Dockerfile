FROM node:lts-alpine

RUN apk add --no-cache tini

# 固定 pnpm 版本：corepack 默认会拉最新版（pnpm 12+），
# 它把 esbuild 的 ignored build script 当作错误，导致 pnpm install 直接失败
RUN npm install -g pnpm@10.33.0

ENV NODE_ENV=production

WORKDIR /app

RUN chown node:node /app

COPY --chown=node:node package.json pnpm-lock.yaml ./

USER node

RUN pnpm install --prod --frozen-lockfile

COPY --chown=node:node . ./

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "app.js"]
