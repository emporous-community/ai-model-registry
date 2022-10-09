FROM fedora AS build

WORKDIR /mrdemo

RUN dnf install -y go gettext jq 
#git make


#RUN curl -L https://github.com/uor-framework/uor-client-go/releases/latest/download/uor-client-go-linux-amd64 --output uor-client-go-linux-amd64 \
#      && chmod +x uor-client-go-linux-amd64

#RUN git clone https://github.com/uor-framework/uor-client-go.git

#RUN cd uor-client-go && make all && cp ./bin ../uor-client-go-linux-amd64

#RUN cd ..

RUN GOBIN=$PWD go install github.com/google/go-containerregistry/cmd/registry@latest


COPY ./ .



ENTRYPOINT [ "./end-to-end.sh" ]

