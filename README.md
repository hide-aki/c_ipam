# c_ipam

Simplistic IPAM implementation with REST API. To use in conjuction with Docker IPAM driver ([lpfi/c_ipam-docker](https://github.com/lpfi/c_ipam-docker)), follow the steps below.

Pull source code

Run ```docker-compose up``` to start IPAM, IPAM DB and Docker driver

Create a block for the local address space ```curl -i -X POST -H "Content-Type: application/json" -d'{"cidr": "10.0.0.0/8", "network_view": "local"}' http://localhost:8080/api/v1/blocks```

Create docker network using the IPAM driver ```docker network create --ipam-driver c_ipam-docker mynetwork```

List pools ```curl -i http://localhost:8080/api/v1/pools```

List addresses ```curl -i http://localhost:8080/api/v1/addresses```
