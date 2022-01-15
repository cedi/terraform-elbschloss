FROM qmcgaw/godevcontainer

ARG TF_VERSION=1.0.11

RUN apk add yamllint curl unzip bash

RUN ARCH=$(uname -m) && \
    TF_LS_VERSION="0.24.0" && \
    [ $ARCH = "x86_64" ] && ARCH="amd64" && \
    DOWNLOAD_URL="https://releases.hashicorp.com/terraform-ls/${TF_LS_VERSION}/terraform-ls_${TF_LS_VERSION}_linux_${ARCH}.zip" && \
    TEMP_DIR=$(mktemp -d) && \
    cd $TEMP_DIR && \
    curl -L $DOWNLOAD_URL -o terraform-ls.zip && \
    unzip -d /usr/local/bin/ -o terraform-ls.zip && \
    cd $HOME && \
    rm -rf $TEMP_DIR

RUN TEMP_DIR=$(mktemp -d) && \
    cd $TEMP_DIR && \
    git clone https://github.com/tfutils/tfenv.git ./tfenv && \
    chmod +x ./tfenv/bin/* && \
    cp ./tfenv/bin/* /usr/local/bin/ && \
    cp ./tfenv/lib/* /usr/local/lib/ && \
    cp ./tfenv/share/* /usr/local/share/ && \
    cp -r ./tfenv/libexec /usr/local/ && \
    cd $HOME && \
    rm -rf $TEMP_DIR

RUN tfenv install ${TF_VERSION} && tfenv use ${TF_VERSION}
