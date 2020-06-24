# HTTP load balancer

Load balancer from Terraform GCP resources (no Terraform registry modules used)

## Note

Spent a couple of weeks trying to make the [Terraform registry module](https://github.com/terraform-google-modules/terraform-google-lb-http) work and gave up

- Observed weird behavior with MIG submodule

- In documentation it is written that service account is optional, but, when you run it, it says it is required

- When I use existing service account, Terraform generates an error (cannot find default VM credentials)

- Too complex backend definition

In summary, it was too much of a hassle for me.

Creating it from Terraform resources looks not much more complex (from required efforts perspective).
