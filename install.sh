#!/bin/sh

GO_VERSION=go1.12.5
COSMOS_VERSION=v0.34.4

echo ""
echo "This script will install the latest version of GO, Gaiacli and Gaiad as well as any other required dependencies for linux 64 bit systems"
echo ""
echo "By default, gaiacli is not connected to any cosmos nodes, this script will aso configure gaiacli to connect to the MyCosmosValidator public nodes so it is fully ready to be used.  For more information visit https://mycosmosvalidator.com"
echo ""
echo "NOTE: If you have an older version of GO already installed, this script will update GO to the latest version and may also change your GO environment variables"
echo ""
echo "This script will install GO version $GO_VERSION and cosmos version $COSMOS_VERSION"

read -p "Are you sure you want to continue? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then

    echo "Checking required packages are installed"
    apt install -y wget git make gcc curl

    echo "Installing go"
    wget https://dl.google.com/go/$GO_VERSION.linux-amd64.tar.gz
    tar -C /usr/local -xzf $GO_VERSION.linux-amd64.tar.gz
    rm $GO_VERSION.linux-amd64.tar.gz

    echo "Setting up environment variables for GO"

    mkdir -p $HOME/go/bin   
    echo "export GOPATH=$HOME/go" >> ~/.bashrc
    echo "export GOBIN=\$GOPATH/bin" >> ~/.bashrc
    echo "export PATH=\$PATH:\$GOBIN:/usr/local/go/bin" >> ~/.bashrc
    source ~/.bashrc
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN:/usr/local/go/bin

    echo "Installing cosmos-sdk"

    mkdir -p $GOPATH/src/github.com/cosmos
    cd $GOPATH/src/github.com/cosmos
    git clone https://github.com/cosmos/cosmos-sdk
    cd cosmos-sdk && git checkout $COSMOS_VERSION
    make tools install

    gaiad version --long
    gaiacli version --long

    gaiacli config node mcv-sentry-1.mycosmosvalidator.com:26657
    gaiacli config trust-node true
    gaiacli config chain-id cosmoshub-2


    echo "Gaiacli and Gaiad successfully installed"
    echo ""
    echo ""
    echo "NOTE PLEASE RUN"
    echo ""
    echo "source ~/.bashrc"
    echo ""
    echo "to refresh your paths"
    echo ""
    echo ""
    echo "For more information and help on how to use gaiacli to send transactions and delegate, please visit https://mycosmosvalidator.com"
    echo ""
    echo "Try running gaiacli status to see the current status of the cosmos network"
    echo ""




fi
