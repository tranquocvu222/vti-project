terraform {
  cloud {
    organization = "vu-test"

    workspaces {
      name = "vti-demo"
    }
  }
}