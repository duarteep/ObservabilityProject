# Sobre o desafio
### Configuração e gerenciamento do Kubernetes 
1. Crie um Ingress para expor a aplicação\
*app/manifests/application-service.yaml*
2. Crie um Service para expor a aplicação\
*app/manifests/application-service.yaml*
3. Crie o Deployment da aplicação\
*app/manifests/application-deployment.yaml*
4. Configure os limits dos pod\
*app/manifests/application-deployment.yaml:65*
5. Configure os probes (HealthCheck) necessários\
*app/manifests/application-deployment.yaml:36*
6. Configure o HPA e calibre os thresholds necessários para escalar a aplicação por requisição\
*app/manifests/application-scaledObjects.yaml*
8. Configure a estratégia Rolling Update\
*app/manifests/application-deployment.yaml:15*

### Observability
1. **Métricas**: Realize a coleta das métricas pelo Prometheus Server e os dashboards necessários 
para monitorar a saúde da aplicação devem ser criados no Grafana.
    - Crie um Dashboard no Grafana com os 4 Golden Signals da aplicação.\
    *dashboards/four-golden-signals.json*
    - Crie um Dashboard no Grafana com o SPG (Single Pane of Glass) da aplicação.\
    *dashboards/spg.json*
2. **Logs**: Realize a coleta de logs da app e envie para ferramenta de logs (Splunk, CloudWatch, 
Graylog ou Grafana Loki).\
*dashboards/loki.json*
3. **Trace**: Realize a coleta do tracing utilizando alguma das ferramentas: (Jaeger, Zipkin ou 
qualquer outra ferramenta de sua preferência).
*dashboards/spg.json*

# Resolucao
## Requisitos do ambiente
- Docker Desktop https://docs.docker.com/desktop/install/linux-install/
- Kind: https://kind.sigs.k8s.io/docs/user/quick-start
```
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
- Helm: https://helm.sh/docs/intro/install/
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Como realizar o deploy e validar o ambiente?
 
1. Deploy da plataforma:
    ```
    sh 1_platform_deploy.sh
    ```

2. Deploy da aplicacao:
    ```
    sh 2_application_deploy.sh
    ```
    O Jaeger pode demorar cerca de 5 minutos para iniciar ate que as 3 instancias Cassandra fiquem disponiveis.
    
3. Exponha os servicos via port forward:
    ```
    sh 3_expose_services.sh
    ```
    
4. Validacao do ambiente:
    - Acesse a aplicacao e a stack de observabilidade:
        - Grafana: http://localhost:3000
            - Usuario: admin
            - Senha: prom-operator
        - Jaeger: http://localhost:8091
        - Application: http://localhost:8080
    - Importe os dashboards do Grafana que estao no diretorio *dashboards*;
    - Realize diversas chamadas para a aplicacao e observe a escalabilidade por requisicoes (Keda):
        ```
        while true
        do
            curl http://localhost:8080/
        done
        while true
        do
            curl http://localhost:8080/notfound
        done
        ```
    - Acesse os dashboards importados no Grafana e observe o comportamento da aplicacao:
        - Metricas sendo coletadas pelo Prometheus e exibidas no Grafana;
        - LOGs sendo coletados pelo Grafana Loki;
        - Traces sendo coletados pelo Jaeger;
5. Destroy do ambiente:
    ```
    sh 4_destroy_environment.sh
    ```