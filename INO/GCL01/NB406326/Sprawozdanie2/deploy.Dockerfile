FROM takenote_build

WORKDIR /takenote
RUN npm run build

EXPOSE 5000

ENTRYPOINT npm run prod