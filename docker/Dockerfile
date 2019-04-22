FROM ringleai/mt-cicd-base:v1
  
RUN git clone https://github.com/xinfn/MT-awesome.git && \
    mv MT-awesome/* . && \
    rm -rf MT-awesome

WORKDIR ./src/server

RUN ./build.sh

EXPOSE 8080

CMD ./bin/mt-server

