## install crds using kubectl_file_documents to split the YAML into individual manifests
data "kubectl_file_documents" "gateway_api_crds" {
  content = file("${path.module}/helm-values/gateway-api-standard.yaml")
}

resource "kubectl_manifest" "gateway_api_crds" {
  for_each = data.kubectl_file_documents.gateway_api_crds.manifests

  yaml_body = each.value

  server_side_apply = true
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

  depends_on = [kubectl_manifest.gateway_api_crds]
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