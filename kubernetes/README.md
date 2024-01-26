# Kubernetes sandbox
This is my kubernetes sandbox for learning about kubernetes and how to use it it.
Currently running microk8s with containerd as the container runtime on my laptop because it's lightweight.
Files here are mostly gonna be deployment or service files with maybe some other stuff like Dockerfiles for image creation.

## Express-gateway
Because of intern related stuff with microservices, it has been decided that we use the open-source express-gateway as an api-gateway to access the microservices running on kubernetes. This folder will hold files related to that for test purposes.


# Quick notes
- Cluster
    - a collection of nodes with a control pane that handle communication and management
- Node
    - VM or bare metal server on which you hold a kubetes and container runtime that is connected to a cluster. A node can contain multiple pods.
- pod
    - Abstraction that hold 1-* containers that share storage/volume, network and other information about eachother.
- deployment
    - creating a deployment through `kubectl create deployment` or `kubectl apply` sets up pods on available nodes. To remove you can use `kubectl delete deployment`. A deployment can be created with previous mentioned `kubectl apply` by also having a deployment.yml file that contains information regarding Kind, selector, labels and for containers image, name, port.
- service
    - Normally when creating a pods, it has an internal ip making it possible for communication inside the cluster. Outside though is not possible until you make a service. A service is an abstraction that uses a selector and labels to know which pods that needs to be exposed to the outside (for external IP you can use metallb addon in microk8s).
    - types
        - ClusterIP (default)
            - exposes on an internal ip
        - NodePort
            - exposes the service on the same port on each node and can be accessed by `<nodeip>:<port>`. Uses NAT to resolve.
        - LoadBalancer
            - creates an external loadbalancer and exposes a fixed external IP if available on the cloud solution (available on digitalocean). 
            - **Setup api-gateway with this and expose only it to the outside while making it communicate with services internally.**
        - ExternalName
            - maps the service to the content of an external name like `foo.bar.example.com`. No proxy needed.
