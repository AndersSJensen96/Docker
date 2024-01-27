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
    - creating a deployment through `kubectl create deployment` or `kubectl apply -f <deployment.yaml>` sets up pods on available nodes. To remove you can use `kubectl delete deployment`. A deployment can be created with previous mentioned `kubectl apply -f` by also having a deployment.yml file that contains information regarding Kind, selector, labels and for containers image, name, port.
    - kinda like a compose in docker
- service
    - Normally when creating a pods, it has an internal ip making it possible for communication inside the cluster. Outside though is not possible until you make a service. A service is an abstraction that uses a selector and labels to know which pods that needs to be exposed to the outside (for external IP you can use metallb addon in microk8s).
    - Because services are an abstraction, it means that you can call this without having to worry about the status of the pods behind it, since it just chooses whatever is available that matches the label.
    - Services contain a load-balancer for managing traffic to pods.
    - types
        - ClusterIP (default)
            - exposes on an internal ip
        - NodePort
            - exposes the service on the same port on each node and can be accessed externally by `<nodeip>:<port>`. Uses NAT to resolve.
        - LoadBalancer
            - creates an external loadbalancer and exposes a fixed external IP if available on the cloud solution (available on digitalocean). 
            - **Setup api-gateway with this and expose only it to the outside while making it communicate with services internally.**
        - ExternalName
            - maps the service to the content of an external name like `foo.bar.example.com`. No proxy needed.
- Troubleshooting and kubectl commands
    - Note: Most of these are used for pods, nodes or services
    - `kubectl get`
        - list resources
    - `kubectl describe`
        - show detailed info
    - `kubectl logs`
        - show logs - pods
    - `kubectl exec`
        - access to terminal for executing commands - pods
    - other
        - `kubectl delete`
            - delete pod or service 
- Scaling
    - Scaling is done with replicas, which can be defined when running a deployment. increase number of the specific pods on available nodes.
    - Kubernetes does have an option for autoscaling too: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ 
    - You can change replicas on the fly with `kubectl scale <deployment> --replica=<number-of-replicas>`
        - use `kubectl get pods -o wide` to see the pod information
- Updating
    - Rolling updates is a way to update you pods by replacing old with new pods. This is done incrementally and with zero downtime.
    - by default the max number of pods that can be created and unavailable is one. This can be changed to wither numbers or percentages.
    - deployments are versioned and can be rolled back to last stable version if needed.
    - to update the image use `kubectl set image <deployment> <new-image>`
        - confirm with `kubectl rollout status <deployment>`, `kubectl describe pods` (check image) or run a curl on the node if exposed
    - for rollback use `kubectl rollout undo <deployment>`
        - rollback to previous known state

# Deployment yaml
- kind deployment:
    - metadata contains general data on the deployment for later identification

- spec
    - contains information about the pod
        - replicas: number of replicas to make on initialization
        - selector-matchLabels: label matching, so the replicaset knows which pods to manage
            - matchlabel is key-value pair.
            - should match temaplte labels

- template
    - Defines the template that the pods should be created by.
    - Labels is for identifying pods that are the same deployments
    - specs
        - Contains information regarding the containers that should be started on deployment.

# Service yaml
- Similar to deployment, but kind Service instead and only metadata name is needed.
- spec contains
    - type which can be whatever you need, but is default CluserIp
    - Selector, which is the pods that is connected to the service
    - Ports, which contains
        - port for the services port
        - targetport for the pods port
        - protocol, if you need to define the protocol.
- Quick note:
    - use describe to check the service after creation and look at endpoints to see if there's any pods endpoint addresses defined. If it is `<none>`, something is wrong
    - also
        - `kubectl get ep`
        - `kubectl describe ep`