# Projeto: Deploy de Aplicação Node.js em Cluster EKS com CI/CD via GitHub Actions

## Visão Geral

Este projeto tem como objetivo provisionar uma infraestrutura Kubernetes utilizando o Amazon EKS (Elastic Kubernetes Service), realizar o deploy de uma aplicação Node.js em containers Docker e automatizar todo o processo de build e deploy através do GitHub Actions.

A solução contempla:

- Provisionamento da infraestrutura com Terraform
- Criação de VPC e recursos de rede
- Criação do cluster EKS
- Configuração de permissões IAM
- Criação de repositório ECR
- Build e push da imagem Docker
- Deploy automatizado no Kubernetes
- Pipeline CI/CD utilizando GitHub Actions

---

# Arquitetura

```text
GitHub
   │
   │ Push
   ▼
GitHub Actions
   │
   ├── Build Docker Image
   ├── Push para ECR
   └── Deploy no EKS
            │
            ▼
     Amazon EKS
            │
            ▼
      Aplicação Node.js
```


# Estrutura do Projeto
```text
.
├── modules
│   ├── networking
│   └── eks
│
├── kubernetes
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
│
├── .github
│   └── workflows
│       └── ci-cd.yml
│
├── app
│   ├── server.js
│   ├── package.json
│   └── Dockerfile
│
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```
