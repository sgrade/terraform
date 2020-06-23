# HTTP load balancer

Appetmpting to create my own load balancer module from pure Terraform GCP resources.

(without using Terraform modules)

## Note

Spent a couple of weeks trying to make the [Terraform module](https://github.com/terraform-google-modules/terraform-google-lb-http) work and gave up

Observed weird behavior with MIG submodule: 

- In documentation it is written that service account is optional, but, when you run it, it says it is required

- When I use existing service account, Terraform generates an error (cannot find default VM credentials)

- Too complex backend definition

In summary, it was too much of a hassle for me. 

Creating it from Terraform resources looks not much more complex (from required efforts perspective).
