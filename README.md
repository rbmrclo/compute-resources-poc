## Configure Compute Resources with `LimitRange`

A proof of concept of how CPU and Memory usage are allocated per container when using `LimitRange`.

### Current Output

Remarks:

- nginx-deployment pod gets assigned a QoS class of Burstable

```
$ ./deploy.sh

Switched to context "docker-for-desktop".
deployment.extensions "nginx-deployment" deleted
limitrange "cpu-limit-range" deleted

deployment.apps "nginx-deployment" created
limitrange "cpu-limit-range" created

=============================
Limits:
NAME              AGE
cpu-limit-range   0s
=============================
=============================
Quality of Service Class:
Burstable
=============================

=============================
Compute Resources:
{
  "limits": {
    "cpu": "1"
  },
  "requests": {
    "cpu": "1m"
  }
}
=============================
```

### Confirm with node capacity

```
$ kubectl get nodes

NAME                 STATUS    ROLES     AGE       VERSION
docker-for-desktop   Ready     master    35d       v1.10.11
```

```
$ kubectl describe node docker-for-desktop

.. omitted

Capacity:
 cpu:                4
 ephemeral-storage:  61255492Ki
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             10216828Ki
 pods:               110
Allocatable:
 cpu:                4
 ephemeral-storage:  56453061334
 hugepages-1Gi:      0
 hugepages-2Mi:      0
 memory:             10114428Ki
 pods:               110

 .. omitted

Non-terminated Pods:         (9 in total)
  Namespace                  Name                                          CPU Requests  CPU Limits  Memory Requests  Memory Limits
  ---------                  ----                                          ------------  ----------  ---------------  -------------
  default                    nginx-deployment-584cdf8c7f-llgjk             1m (0%)       1 (25%)     0 (0%)           0 (0%)
  docker                     compose-74649b4db6-hwgpf                      0 (0%)        0 (0%)      0 (0%)           0 (0%)
  docker                     compose-api-769f8d59b9-cstbl                  0 (0%)        0 (0%)      0 (0%)           0 (0%)
  kube-system                etcd-docker-for-desktop                       0 (0%)        0 (0%)      0 (0%)           0 (0%)
  kube-system                kube-apiserver-docker-for-desktop             250m (6%)     0 (0%)      0 (0%)           0 (0%)
  kube-system                kube-controller-manager-docker-for-desktop    200m (5%)     0 (0%)      0 (0%)           0 (0%)
  kube-system                kube-dns-86f4d74b45-45mr8                     260m (6%)     0 (0%)      110Mi (1%)       170Mi (1%)
  kube-system                kube-proxy-j5kg5                              0 (0%)        0 (0%)      0 (0%)           0 (0%)
  kube-system                kube-scheduler-docker-for-desktop             100m (2%)     0 (0%)      0 (0%)           0 (0%)
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  CPU Requests  CPU Limits  Memory Requests  Memory Limits
  ------------  ----------  ---------------  -------------
  811m (20%)    1 (25%)     110Mi (1%)       170Mi (1%)
```

- We have an allocatable `4 vCPU`
- As we can see, the CPU limit has reached `25%` of the node's CPU capacity.
- This means that with this current setup, once we add more replicas of the `nginx-deployment` pod, we could overcommit the node which could affect it's stability.
