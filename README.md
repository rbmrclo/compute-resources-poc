# Configure Compute Resources with `LimitRange`

A proof of concept of how CPU and Memory usage are allocated per container when using `LimitRange`.

#### Current Output

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
