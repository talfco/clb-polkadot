# README

This is a Polkadot Validator Node Docker Image base on Ubuntu 16.04 (Jelastic PaaS ready)

Refer to the [following tutorial](https://medium.com/coinmonks/polkadot-hello-world-1-cost-effective-cloud-deployment-of-a-validator-node-d3c1bbdb9200) for more instructions.

Latest Install Instructions on the Polkadot Wiki:
* https://wiki.polkadot.network/en/latest/polkadot/node/guides/how-to-validate/

## Docker Build Commands

 * docker build -t=talfco/clb-polkadot:v0.2.3 .
 * docker run --rm -it --mount source=data,destination=/media/disk1/chains  talfco/clb-polkadot:v0.2.3
 * docker push talfco/clb-polkadot:v0.2
 
 
## Miscellaneous 
* Polkadot DB Location: will be mapped to the `/data`
 
 