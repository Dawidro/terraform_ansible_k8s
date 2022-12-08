<h3 align="center">Terraform libvirt</h3>

  <p align="center">
    Provisioning 4 virtual machines for Kubernetes cluster.
    <br />
    <a href="https://github.com/Dawidro/terraform_ansible_k8s/issues">Report Bug</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
Terraform code for creating 4 virtual machines to use for Kubernetes cluster. Setting up cluster is done by Ansible.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Clone and apply to start

### Prerequisites

In order to run it you have to have libvirt installed and configured

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/Dawidro/terraform_ansible_k8s
   ```
2. Initialaise Terraform with:
  ```sh
  terraform init
  ```
3. Then make plan with:
  ```sh
  terraform plan
  ```
4. And lastly apply plan:
  ```sh
  terraform apply -auto-approve
  ```


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

