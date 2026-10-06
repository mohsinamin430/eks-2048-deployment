module "shared_gateway-api-crds" {
  source  = "dasmeta/shared/any//modules/gateway-api-crds"
  version = "1.19.1"
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = "traefik"
  create_namespace = true
  version    = "41.6.0"

  set = [ {
    name = "providers.kubernetesGateway.enabled"
    value = "true"
    name  = "gateway.enabled"
    value = "true"
    name  = "gatewayClass.enabled"
    value = "true"
  } ]

  depends_on = [module.shared_gateway-api-crds]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "cert-manager"
  version          = "1.21.2"

   values = [
    file("${path.module}/helm-values/cert-manager.yaml")
  ]

  #Wait for the release to be fully deployed
  wait = true
}