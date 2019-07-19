FROM arm32v7/node

ENV PSITRANSFER_UPLOAD_DIR=/data \
    NODE_ENV=production
    
LABEL MAINTAINER="Christoph Wiechert <wio@psitrax.de>"
LABEL despription="PsiTransfer for RassberyPi"

WORKDIR /app

ADD *.js package.json README.md /app/
ADD lib /app/lib
ADD app /app/app
ADD public /app/public

# Rebuild the frontend apps
RUN cd app && \
    NODE_ENV=dev npm install --quiet 1>/dev/null && \
    npm run build && \
    cd .. && rm -rf app

# Install backend dependencies
RUN mkdir /data && \
    chown node /data && \
    npm install --quiet 1>/dev/null

EXPOSE 3000
VOLUME ["/data"]

USER node

HEALTHCHECK CMD wget -O /dev/null -q http://localhost:3000

CMD ["node", "app.js"]
