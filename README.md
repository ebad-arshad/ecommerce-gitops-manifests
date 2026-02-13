# E-Commerce GitOps Manifests

This repository contains the GitOps manifests for deploying a microservices-based E-Commerce platform using ArgoCD and Helm. It manages the complete lifecycle of the application deployment, from infrastructure components to application services.

## Project Structure

The repository is organized into two main directories:

-   `argocd/`: Contains ArgoCD-specific manifests.
    -   `apps/`: Defines the ArgoCD Applications for different environments (e.g., `dev`, `shared`).
    -   `bootstrap/`: Contains the root application manifests used to bootstrap the environment (App of Apps pattern).
    -   `projects/`: Defines ArgoCD AppProjects for logical grouping and access control.
-   `helm/`: Contains the Helm charts used for deployment.
    -   `charts/`: Source code for the application and infrastructure Helm charts.
    -   `environments/`: Environment-specific value files.

## Prerequisites

Before getting started, ensure you have the following tools installed:

-   [Kubectl](https://kubernetes.io/docs/tasks/tools/)
-   [Helm](https://helm.sh/docs/intro/install/)
-   [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) (Optional, for CLI management)

## Getting Started

### 1. Install ArgoCD

A helper script is provided to install ArgoCD and retrieve the initial admin password.

```bash
chmod +x argocd-install.sh
./argocd-install.sh
```

 This script will:
1.  Add the ArgoCD Helm repo.
2.  Install ArgoCD into the `argocd` namespace using the `argocd-values.yaml` file.
3.  Wait for the initial admin secret to be generated.
4.  Output the initial admin password.

### 2. Access ArgoCD UI

Port-forward the ArgoCD server to access the UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open your browser and navigate to `https://localhost:8080`.
Username: `admin`
Password: Created in step 1.

### 3. Bootstrap the Environment

This project follows the "App of Apps" pattern. To deploy the entire suite of applications for the development environment, apply the bootstrap manifest:

```bash
kubectl apply -f argocd/bootstrap/root-app-dev.yaml
```

This will create a parent Application in ArgoCD that automatically manages and syncs all other applications defined in `argocd/apps/dev`.

## Applications

The following applications and services are deployed as part of the `dev` environment:

-   **API Gateway**: Entry point for the microservices.
-   **Auth Service**: Handles user authentication and authorization.
-   **Order Service**: Manages order processing.
-   **Product Service**: Manages product catalog and inventory.
-   **PostgreSQL**: Database for data persistence.
-   **RabbitMQ**: Message broker for asynchronous communication.

## Directory Layout

```
.
├── argocd
│   ├── apps            # Application definitions (dev, shared)
│   ├── bootstrap       # Root applications (App of Apps)
│   └── projects        # ArgoCD Projects
├── helm
│   ├── charts          # Helm charts
│   └── environments    # Environment values
├── argocd-install.sh   # Installation script
└── argocd-values.yaml  # ArgoCD Helm values
```
