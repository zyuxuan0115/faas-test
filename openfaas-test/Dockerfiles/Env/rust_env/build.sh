#!/bin/bash
sudo docker build --no-cache  -t zyuxuan0115/rust-env:latest -f Dockerfile . 
sudo docker push zyuxuan0115/rust-env:latest
