FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/cluster-dns-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-dns-operator/cluster-dns-operator /usr/bin/
COPY manifests /manifests
RUN useradd cluster-dns-operator
USER cluster-dns-operator
ENTRYPOINT ["/usr/bin/cluster-dns-operator"]
LABEL io.openshift.release.operator true
LABEL io.k8s.display-name="OpenShift cluster-dns-operator" \
      io.k8s.description="This is a component of OpenShift and manages the lifecycle of cluster DNS services." \
      maintainer="Dan Mace <dmace@redhat.com>"
