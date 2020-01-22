resource "google_cloudbuild_trigger" "app" {
  filename = "pipelines/app.yaml"

  included_files = [
    "src/*",
    "Dockerfile",
    "pipelines/app.yaml"
  ]

  substitutions = {
    _FOO = "bar"
    _BAZ = "qux"
  }

  github {
    owner = "cyclingwithelephants"
    name  = "example_golang_deployment"

    push {
      branch = "*"
      # tag    = ""
    }
  }
}
